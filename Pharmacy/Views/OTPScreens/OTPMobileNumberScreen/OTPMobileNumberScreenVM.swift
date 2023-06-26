//
//  OTPMobileNumberScreenVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 11.06.23.
//

import Foundation


final class OTPMobileNumberScreenVM: ObservableObject {
   
    let otpLength: Int = 6
    var profileLoginStatus: ProfileLoginStatus?
    let AFManager: AlamofireManagerProtocol = AlamofireManager()
    
    @Published var mobileNumberText = "+375"
    @Published var flagIsHidden = true
    @Published var alertIsPresented = false
    @Published var showCodeScreen = false
    @Published var showRegistrationView = false
    @Published var otpText: String = ""
    @Published var fields: [String] = []
    @Published var showTabBar = false
    @Published var sheetToShow : OTPScreens?
    @Published var name: String = ""
    @Published var lastName: String = ""
    @Published var alertBody : AppAlert? {
        didSet {
            self.alertIsPresented.toggle()
        }
    }
    var mobile : String  {
        mobileNumberText.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
    }
    
    func getOTPCode() {
       
        if mobile.count == 13 {
            print(mobile)
            
            Task{
                do{
                    let sendOTPStatus = try await AFManager.sendPhone(phone: mobile)
                    print(sendOTPStatus)
                    await MainActor.run(body: {
                        //showCodeScreen.toggle()
                        sheetToShow = .otpCodeScreen
                        profileLoginStatus = .alradyExistProfile
                    })
                }
                catch {
                    await MainActor.run(body: {
                        sheetToShow = .registration
                        profileLoginStatus = .newProfile
                    })
                }
            }
        }
        else {
            alertBody = AppAlert(message: String(localized: "Invalid phone number"))
        }
    }
    
 

    
   
    
    init() {
        fields = Array(repeating: "", count: self.otpLength)
    }
    
    func checkState() -> Bool {
        return fields.contains("")
    }
    
    func verifyAndSend() {
        
        otpText = fields.reduce("", { res, str in
            return res + str
        })
        Task {
            do{
                switch profileLoginStatus {
                case .alradyExistProfile :
                    _ = try await AFManager.sendOTPCode(otp: otpText,
                                                        phone: mobile)
                case .newProfile :
                    _ = try await AFManager.registerNewProfile(name: name,
                                                               lastName: lastName,
                                                               phone: mobile,
                                                               otp: otpText)
                case .none:
                    alertBody = AppAlert(message: String(localized: "Eror"))
                }
                
               
                await MainActor.run(body: {
                    showTabBar.toggle()
                })
            }
            catch {
                await MainActor.run(body: {
                    alertBody = AppAlert(message: String(localized: "Invalid OTP code"))
                })
            }
        }
    }
    
    func checkOtp(index: Int, newValue: String) -> Int? {
        
        if newValue.count == 6 {
            fields =  newValue.map{String($0)}
        }
        if !checkState() {
            return nil
        }
        if !newValue.isEmpty {
            if newValue.count >= 1 {
                fields[index] = String(newValue.first ?? " ")
                return index + 1
            }
        }
      
        if index > 0, !fields[index - 1].isEmpty, fields[index].isEmpty{
            return index - 1
        }
        return 0
    }
}

struct AppAlert : Identifiable {
    var id: String {message}
    var message: String
}

enum OTPScreens: Int, Identifiable {
    var id: Int { self.rawValue }
    
    case registration = 0
    case otpCodeScreen = 1
}

enum ProfileLoginStatus {
    case newProfile
    case alradyExistProfile
}
