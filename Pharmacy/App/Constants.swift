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
    static let phoneSendUrl = "https://teikly.com/api/v1/auth/phoneNumber/login"
    static let phoneAndOTPSendUrl = "https://teikly.com/api/v1/auth/phoneNumber/confirm"
    static let registerUrl = "https://teikly.com/api/v1/auth/phoneNumber/register"
    static let authWithToken = "https://teikly.com/api/v1/auth/me"
    static let savedAddressesUrl = "https://parseapi.back4app.com/classes/MyAddresses/"
    static let salesPramUrl = "https://parseapi.back4app.com/classes/salePharm"
    static let categoriesPramUrl = "https://parseapi.back4app.com/classes/categories"
    static let pramUrl = "https://parseapi.back4app.com/classes/"
    static let ordersUrl = "https://parseapi.back4app.com/classes/orders"
    // Images
    
    static let pharmacyLogoImage = "loadingImage"
    static let otpImage = "OTPImage"
    static let telegramIco = "telegramIco"
    static let pharmPlaceholder = "pharmPlaceholder"
    
    //Urls
    static var telegramUrl : URL? = URL(string: "https://t.me/oksinaa")
       
    
    //HTTPHeaders
    static let back4appHeader: HTTPHeaders = [
        "X-Parse-Application-Id" : "jdvDvQao8tePsPKJuw3VVeU6xjZkIKzzvK1ry46N",
        "X-Parse-REST-API-Key" : "BQ7HWLuwvUfyiD2SoqPTaHoEsCPeXptaOyOreAvw"
    ]
}
