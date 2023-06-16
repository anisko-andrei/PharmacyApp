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
    @Published var alertMessage = ""
    @Published var showCodeScreen = false
    @Published var alertBody : AppAlert? {
        didSet {
            self.alertIsPresented.toggle()
        }
    }
    
    func getOTPCode() {
        let mobile =  mobileNumberText.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
        if mobile.count == 13 {
            print(mobile)
            showCodeScreen.toggle()
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
