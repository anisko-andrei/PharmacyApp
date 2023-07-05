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

enum LoadingStatus {
    case loading, noResult, showResult
}

class MainVM : ObservableObject, DynamicProperty {
    @Published var sheetToOpen: MainScreenButtons?
    @Published var sheetItem : ResultSalePharm?
    var AFManager: AlamofireManagerProtocol = AlamofireManager()
    @Published var salesResult: [ResultSalePharm] = []
    @Published var realmDB: [CartItem] = []
    @Published var loadingStatus: LoadingStatus = .loading
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
                    loadingStatus = .showResult
                })
            }
            catch {
                print("nezagr")
                await MainActor.run(body: {
                    
                    loadingStatus = .noResult
                })
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

