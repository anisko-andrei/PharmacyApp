//
//  AlamofireModels.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 20.06.23.
//

import Foundation

struct SendPhoneMessage: Decodable {
    let message: String
}

struct LoginInfo: Decodable {
    let customer: Customer
    let token: String
}


struct Customer: Decodable {
    let id: Int
    let firstName, lastName, createdAt, updatedAt: String
    let deletedAt: String?
    let role, status: Role
    let entity: String?

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, createdAt, updatedAt, deletedAt, role, status
        case entity = "__entity"
    }
}
struct AuthToken: Decodable {
    let id: Int
    let phoneNumber, provider, firstName, lastName: String
    let createdAt, updatedAt: String
    let deletedAt: String?
    let role, status: Role
    let entity: String

    enum CodingKeys: String, CodingKey {
        case id, phoneNumber, provider, firstName, lastName, createdAt, updatedAt, deletedAt, role, status
        case entity = "__entity"
    }
}

struct Role: Decodable {
    let id: Int
    let name, entity: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case entity = "__entity"
    }
}


struct Addresses: Decodable {
    var results: [Result]
}

struct Result: Decodable {
    var objectID:String
    var  address, createdAt, updatedAt : String?
    enum CodingKeys: String, CodingKey {
        case objectID = "objectId"
        case address, createdAt, updatedAt
    }
}
