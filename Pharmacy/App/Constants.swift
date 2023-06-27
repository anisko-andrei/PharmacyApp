//
//  Constants.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 20.06.23.
//

import Foundation

class Constants {
    // String Urls
    static let phoneSendUrl = "http://localhost:3000/api/v1/auth/phoneNumber/login"
    static let phoneAndOTPSendUrl = "http://localhost:3000/api/v1/auth/phoneNumber/confirm"
    static let registerUrl = "http://localhost:3000/api/v1/auth/phoneNumber/register"
    static let authWithToken = "http://localhost:3000/api/v1/auth/me"
    // Images
    
    static let pharmacyLogoImage = "loadingImage"
    static let otpImage = "OTPImage"
    static let telegramIco = "telegramIco"
    
    //Urls
    static var telegramUrl : URL {
        if let url = URL(string: "https://t.me/oksinaa") {
            return url
        } else {
            return URL(string: "https://google.com")!
        }
    }
}
