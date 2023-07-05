//
//  MainScreenVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 1.07.23.
//

import Foundation
import RealmSwift
import SwiftUI
import Combine
class MainVM : ObservableObject, DynamicProperty {
    @Published var sheetToOpen: MainScreenButtons?
    @Published var sheetItem : ResultSalePharm?
    var AFManager: AlamofireManagerProtocol = AlamofireManager()
    @Published var salesResult: [ResultSalePharm] = []
    @Published var realmDB: [CartItem] = []
    var notificationToken: NotificationToken?
    var realmManager: RealmManagerProtocol = RealmManager()

    
        
    func startObserv() {
       
        guard let realm = realmManager.realm else {return}
        notificationToken = realm.observe({ notification, realm in
            self.realmDB = realm.objects(CartItem.self).compactMap{$0}
            
                
        })
        
    }
    deinit {
        notificationToken?.invalidate()
    }
    init() {
        guard let realm = realmManager.realm else {return}
        self.realmDB = realm.objects(CartItem.self).compactMap{$0}
        startObserv()
    }
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
            realmManager.deleteFromCart(item: itemInCart)
        }
        else {
            realmManager.addToCart(item: item)
        }
    }
    
    
    
   
    func checkInCart(item: ResultSalePharm) -> Bool {
        return realmDB.contains{$0.itemId == item.objectID}
    }
}
