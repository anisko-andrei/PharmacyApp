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
    let firstName, lastName, phoneNumber : String
    let createdAt, updatedAt: String?
    let deletedAt: String?
    let role, status: Role
    let entity: String?

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, createdAt, updatedAt, deletedAt, role, status, phoneNumber
        case entity = "__entity"
    }
}

struct AuthToken: Decodable {
    let id: Int
    let firstName, lastName, createdAt, updatedAt, phoneNumber: String
    let deletedAt: String?
    let role, status: Role
    let entity: String

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, createdAt, updatedAt, deletedAt, role, status, phoneNumber
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

struct SalePharm: Codable {
    let results: [ResultSalePharm]
}

struct ResultSalePharm: Codable, Identifiable {
    var id: String {self.objectID}
    
    var objectID, title: String
    var logo: String
    var price : Double
    var oldPrice: Double?
    var description, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case objectID = "objectId"
        case title, logo, price, oldPrice, description, createdAt, updatedAt
    }
}

struct Categories: Decodable {
    let results: [ResultCategories]
}


struct ResultCategories: Decodable {
    let objectID, name, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case objectID = "objectId"
        case name, createdAt, updatedAt
    }
}
