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
    @Published var allertIsPresented = false
    @Published var alertMessage = ""
  
    func getOTPCode() {
        let mobile =  mobileNumberText.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
        if mobile.count == 13 {
            print(mobile)
        }
        else {
            alertMessage = String(localized: "Invalid phone number")
            allertIsPresented.toggle()
        }
    }
}
