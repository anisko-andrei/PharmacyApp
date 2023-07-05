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
    
   convenience init(title: String, price: Double, logo: String, count: Int, itemId: String) {
        self.init()
        self.title = title
        self.price = price
        self.logo = logo
        self.count = count
        self.itemId = itemId
    }
}
