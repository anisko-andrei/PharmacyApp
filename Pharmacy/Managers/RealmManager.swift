//
//  RealmManager.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 5.07.23.
//
import RealmSwift

import Foundation

protocol RealmManagerProtocol {
    var realm : Realm? {get set}
    func addToCart(item: ResultSalePharm)
    func deleteFromCart(item: CartItem)
    func editItemCountMinus(item: CartItem)
    func cleanCart()
    func editItemCountPlus(item: CartItem) 
}

class RealmManager : RealmManagerProtocol {
    var realm = try? Realm()
    
    func addToCart(item: ResultSalePharm) {
        guard let realm else {return}
        try? realm.write({
            realm.add(CartItem(title: item.title, price: item.price, logo: item.logo, count: 1, itemId: item.objectID))
        })
        
    }
    func deleteFromCart(item: CartItem) {
        guard let realm else {return}
        try? realm.write({
            realm.delete(item)
        })
    }
    func editItemCountMinus(item: CartItem) {
        guard let realm else {return}
        if item.count > 1 {
          
                try? realm.write {
                    item.count -= 1
                }
        
        }
        else {
            try? realm.write({
                realm.delete(item)
            })
            
            
        }
    }
    func cleanCart() {
        if let realm {
            try? realm.write({
                realm.deleteAll()
            })
        }
    }
    func editItemCountPlus(item: CartItem) {
        guard let realm else {return}
      
                try? realm.write {
                    item.count += 1
                }
    }

}
