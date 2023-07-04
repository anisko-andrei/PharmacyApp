//
//  RealmModel.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 3.07.23.
//

import Foundation
import RealmSwift
final class CartItem: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var price: Double
    @Persisted var logo: String
    @Persisted var count: Int
    @Persisted var itemId: String
    
}
