//
//  OTPMobileNumberScreenVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 11.06.23.
//

import Foundation
import KeychainSwift

final class OTPMobileNumberScreenVM: ObservableObject {
   
    let otpLength: Int = 6
    var profileLoginStatus: ProfileLoginStatus?
    let AFManager: AlamofireManagerProtocol = AlamofireManager()
    let keychain = KeychainSwift()
    var user : LoginInfo?
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
    func showOTP() {
        if otpText.count > 6 {
            otpText = String(otpText.prefix(6))
        }
        if otpText.count == 6 {
            fields = otpText.map{String($0)}
        }
        if otpText.count  < otpLength {
            fields[otpText.count] = ""
        }
        if otpText.count <= 6 && otpText.count > 0 {
            fields[otpText.count - 1] = String(otpText[otpText.index(otpText.startIndex, offsetBy: otpText.count - 1)])
            
            
        }
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
    
        Task {
            do{
                switch profileLoginStatus {
                case .alradyExistProfile :
                    user = try await AFManager.sendOTPCode(otp: otpText,
                                                        phone: mobile)
                    
                case .newProfile :
                    user = try await AFManager.registerNewProfile(name: name,
                                                               lastName: lastName,
                                                               phone: mobile,
                                                               otp: otpText)
                case .none:
                    alertBody = AppAlert(message: String(localized: "Eror"))
                }
                
                keychain.set(user?.token ?? "", forKey: "userToken")
               await User.shared.writeUserData(userName: user?.customer.firstName, userLastName: user?.customer.lastName, userMobilePhone: mobile)
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


struct RowModel: Identifiable {
    let id = UUID()
    var name: String
}
