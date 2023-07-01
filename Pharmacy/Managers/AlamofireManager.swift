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
    func loginWithToken(token: String) async throws -> AuthToken
    func deleteAddressAtServer (addressId: String) async throws
    func getSaved() async throws -> Addresses
    func addAddress(newAddress: String) async throws
    func getSales() async throws -> SalePharm
    func getCategories() async throws -> Categories
    func getPharm(path: String) async throws -> SalePharm
}

class AlamofireManager : AlamofireManagerProtocol {
    func getPharm(path: String) async throws -> SalePharm {
        return try await AF.request(Constants.pramUrl.appending(path),
                                        method: .get,
                                    headers: Constants.back4appHeader)
                                .serializingDecodable(SalePharm.self).value
    
    }
    
    
    func getCategories() async throws -> Categories {
        return try await AF.request(Constants.categoriesPramUrl,
                                        method: .get,
                                    headers: Constants.back4appHeader)
                                .serializingDecodable(Categories.self).value
    }
    
    func getSales() async throws -> SalePharm {
        return try await AF.request(Constants.salesPramUrl,
                                        method: .get,
                                    headers: Constants.back4appHeader)
                                .serializingDecodable(SalePharm.self).value
    }
    
    func loginWithToken(token: String) async throws -> AuthToken {
        return try await AF.request(Constants.authWithToken,
                                    method: .get,
                                    headers: [.authorization(bearerToken: token)])
                            .serializingDecodable(AuthToken.self).value
    }
    
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
    
    func deleteAddressAtServer (addressId: String) async throws {
        _ = try await AF.request(Constants.savedAddressesUrl.appending(addressId),
                             method: .delete,
                              headers: Constants.back4appHeader).serializingDecodable(Empty.self, emptyResponseCodes: [200])
            .value
    }
    
  
    
    func getSaved() async throws -> Addresses {
        return try await AF.request(Constants.savedAddressesUrl,
                                        method: .get,
                                    headers: Constants.back4appHeader)
                                .serializingDecodable(Addresses.self).value
        
    }
    
    func addAddress(newAddress: String) async throws  {
        let _ = try await AF.request(Constants.savedAddressesUrl,
                             method: .post,
                             parameters: ["address":newAddress],
                             encoding: JSONEncoding.default,
                             headers: Constants.back4appHeader).serializingDecodable(Result.self).value
    }
    
}
    
    


