//
//  MainScreenVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 1.07.23.
//

import Foundation
import RealmSwift
import SwiftUI

class MainVM : ObservableObject, DynamicProperty {
    @Published var sheetToOpen: MainScreenButtons?
    @Published var sheetItem : ResultSalePharm?
    var AFManager: AlamofireManagerProtocol = AlamofireManager()
    @Published var salesResult: [ResultSalePharm] = []
    @ObservedResults(CartItem.self) var realmDB
    
    func getSales() async {
    
            do {
                let result = try await AFManager.getSales()
                await MainActor.run(body: {
                    salesResult = result.results
                })
            }
            catch {
                print("nezagr")
            }
        
    }
    
    func addOrDeleteItemInCart(item: ResultSalePharm) {
        if let itemInCart = realmDB.first(where: {$0.itemId == item.objectID}) {
            deleteFromCart(item: itemInCart)
        }
        else {
            addToCart(item: item)
        }
    }
    
    func addToCart(item: ResultSalePharm) {
            $realmDB.append(CartItem(value: ["title":item.title,
                                             "price":item.price,
                                             "logo":item.logo,
                                             "count": 1,
                                             "itemId": item.objectID] as [String : Any]))
        }
    
    func deleteFromCart(item: CartItem) {
       
        $realmDB.remove(item)
    }
    func checkInCart(item: ResultSalePharm) -> Bool {
        return realmDB.contains{$0.itemId == item.objectID}
    }
}
