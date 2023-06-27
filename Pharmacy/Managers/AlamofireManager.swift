//
//  AlamofireManager.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 20.06.23.
//

import Foundation
import Alamofire

protocol AlamofireManagerProtocol {
    func sendPhone(phone: String) async throws  -> SendPhoneMessage
    func sendOTPCode(otp: String, phone: String) async throws -> LoginInfo
    func registerNewProfile(name: String, lastName: String, phone: String, otp: String) async throws -> LoginInfo
}

class AlamofireManager : AlamofireManagerProtocol {
    func registerNewProfile(name: String, lastName: String, phone: String, otp: String) async throws -> LoginInfo {
        return try await AF.request(Constants.registerUrl,
                                    method: .post,
                                    parameters: ["phoneNumber": phone,
                                                 "firstName": name,
                                                 "lastName": lastName,
                                                 "otp": otp],
                                    encoding: JSONEncoding.default)
                            .serializingDecodable(LoginInfo.self).value
    }
    

    func sendPhone(phone: String) async throws -> SendPhoneMessage {
        return try await AF.request(Constants.phoneSendUrl,
                                    method: .post,
                                    parameters: ["phoneNumber" : phone],
                                    encoding: JSONEncoding.default)
                            .serializingDecodable(SendPhoneMessage.self).value
    }

    func sendOTPCode(otp: String, phone: String) async throws -> LoginInfo {
        return try await AF.request(Constants.phoneAndOTPSendUrl,
                                    method: .post,
                                    parameters: ["phoneNumber" : phone,
                                                 "otp" : otp],
                                    encoding: JSONEncoding.default)
                            .serializingDecodable(LoginInfo.self).value
    }
}
    
    


