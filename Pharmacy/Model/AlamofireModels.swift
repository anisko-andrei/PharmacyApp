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
    let entity: String

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, createdAt, updatedAt, deletedAt, role, status
        case entity = "__entity"
    }
}


struct Role: Decodable {
    let id: Int
    let name, entity: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case entity = "__entity"
    }
}
