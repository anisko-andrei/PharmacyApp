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
}

class AlamofireManager : AlamofireManagerProtocol {

    func sendPhone(phone: String) async throws -> SendPhoneMessage {
        try await withCheckedThrowingContinuation { continuation in
            AF.request(Constants.phoneSendUrl,
                       method: .post,
                       parameters: ["phoneNumber" : phone],
                       encoding: JSONEncoding.default)
            .responseDecodable(of: SendPhoneMessage.self,
                               completionHandler:  { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            })
        }
    }

    func sendOTPCode(otp: String, phone: String) async throws -> LoginInfo {
        try await withCheckedThrowingContinuation { continuation in
            AF.request(Constants.phoneAndOTPSendUrl,
                       method: .post,
                       parameters: ["phoneNumber" : phone,
                                    "otp" : otp],
                       encoding: JSONEncoding.default)
            .responseDecodable(of: LoginInfo.self,
                               completionHandler:  { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                    
                }
            })
        }
    }
}
    
    


