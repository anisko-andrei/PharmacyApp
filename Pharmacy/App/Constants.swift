//
//  Constants.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 20.06.23.
//

import Foundation
import Alamofire

class Constants {
    // String Urls
    static let phoneSendUrl = "http://localhost:3000/api/v1/auth/phoneNumber/login"
    static let phoneAndOTPSendUrl = "http://localhost:3000/api/v1/auth/phoneNumber/confirm"
    static let registerUrl = "http://localhost:3000/api/v1/auth/phoneNumber/register"
    static let authWithToken = "http://localhost:3000/api/v1/auth/me"
    static let savedAddressesUrl = "https://parseapi.back4app.com/classes/MyAddresses/"
    // Images
    
    static let pharmacyLogoImage = "loadingImage"
    static let otpImage = "OTPImage"
    static let telegramIco = "telegramIco"
    
    //Urls
    static var telegramUrl : URL? = URL(string: "https://t.me/oksinaa")
       
    
    //HTTPHeaders
    static let back4appHeader: HTTPHeaders = [
        "X-Parse-Application-Id" : "jdvDvQao8tePsPKJuw3VVeU6xjZkIKzzvK1ry46N",
        "X-Parse-REST-API-Key" : "BQ7HWLuwvUfyiD2SoqPTaHoEsCPeXptaOyOreAvw"
    ]
}
