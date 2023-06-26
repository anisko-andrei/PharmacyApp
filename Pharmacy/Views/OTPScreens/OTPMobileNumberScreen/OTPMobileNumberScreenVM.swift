//
//  OTPMobileNumberScreenVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 11.06.23.
//

import Foundation


final class OTPMobileNumberScreenVM: ObservableObject {
    
    @Published var mobileNumberText = "+375"
    @Published var flagIsHidden = true
    @Published var alertIsPresented = false
    @Published var showCodeScreen = false
    @Published var showRegistrationView = false
    @Published var alertBody : AppAlert? {
        didSet {
            self.alertIsPresented.toggle()
        }
    }
    
    @Published var sheetToShow : OTPScreens?
    @Published var name: String = ""
    @Published var lastName: String = ""
    var profileLoginStatus: ProfileLoginStatus?
    let AFManager: AlamofireManagerProtocol = AlamofireManager()
 
    
    
    func getOTPCode() {
        let mobile =  mobileNumberText.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
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
                        //alertBody = AppAlert(message: String(localized: "no register"))
                        //showRegistrationView.toggle()
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
}

struct AppAlert : Identifiable {
    var id: String {message}
    var message: String
}

enum OTPScreens: Int, Identifiable {
    var id: Int { self.rawValue }
    
    case registration
    case otpCodeScreen
}

enum ProfileLoginStatus {
    case newProfile
    case alradyExistProfile
}
