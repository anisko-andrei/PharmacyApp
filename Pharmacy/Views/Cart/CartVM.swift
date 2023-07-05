//
//  CartVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 4.07.23.
//

import Foundation
import RealmSwift
import SwiftUI
class CartVM: ObservableObject, DynamicProperty {
    @Published var isContinue = false
    @Published var selected: String?
    @Published var addresses: Addresses = Addresses(results: [])
    @Published var payment: PaymentMethod?
    @Published var newAddress: String = ""
    @Published var newAddressAdd: Bool = false
    @Published var totalPrice: Double = 0
    let AFManager: AlamofireManagerProtocol = AlamofireManager()
    @Published var alertIsPresented = false
    @Published var alertBody : AppAlert = AppAlert(message: "") {
        didSet {
            self.alertIsPresented.toggle()
        }
    }
   // @Published var realmDB: [CartItem] = []
    var notificationToken: NotificationToken?
    var realmManager: RealmManagerProtocol = RealmManager()
   
          
    
        
    func startObserv() {
       
        guard let realm = realmManager.realm else {return}
        notificationToken = realm.objects(CartItem.self).observe({ (changes: RealmCollectionChange) in
            switch changes {
            case .initial(let cartItems):
                self.totalPrice = cartItems.compactMap{$0}.reduce(0, {$0 + (Double($1.count) * $1.price)})
            case .update(let cartItems, _, _, _):
                self.totalPrice = cartItems.compactMap{$0}.reduce(0, {$0 + (Double($1.count) * $1.price)})
            case .error(_):
                self.notificationToken?.invalidate()
            }
        })
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    init() {
        startObserv()
    }
    
    func placeOrderButtonTaped(total: Double) {
        totalPrice = total
        isContinue.toggle()
        
    }
    func loadAdres() async{
       
            do{
                let result = try await AFManager.getSaved()
                await MainActor.run(body: {
                    addresses = result
                })
                print(addresses)
            }
            catch {
                print("eror")
            }
        
    }
    
    func editItemCountMinus(item: CartItem) {
//        if item.count > 1 {
//            if let thawedItem = item.thaw() {
//                try? thawedItem.realm?.write {
//                    thawedItem.count -= 1
//                }
//            }
//        }
//        else {
//            if let thawedItem = item.thaw() {
//                try? thawedItem.realm?.write {
//                    thawedItem.realm?.delete(thawedItem)
//                }
//            }
//
//        }
        Task {
       await     MainActor.run {
                realmManager.editItemCountMinus(item: item)
            }
           
        }
    }
    
     func editItemCountPlus(item: CartItem) {
//
//            if let thawedItem = item.thaw() {
//                try? thawedItem.realm?.write {
//                    thawedItem.count += 1
//                }
//            }
         realmManager.editItemCountPlus(item: item)
    }
        
    
    
    func addNew(newAddress: String) {
        Task {
            do {
                try await AFManager.addAddress(newAddress: newAddress)
                let newV = try await AFManager.getSaved()
                await MainActor.run(body: {
                    addresses = newV
                    selected = newAddress
                    cancelButtonTaped()
                    
                })
            }
            catch{
                print("eerrr")
            }
        }
    }
    
    func newOrder() {
        guard let address = selected,
              let paymentM = payment?.rawValue
        
        else {
            alertBody = AppAlert(message: String(localized: "Enter all data"), title: String(localized: "Error"))
            return
            
        }
        Task {
            
            do{
                try await AFManager.sendOrder(price: totalPrice, paymentMethod: paymentM, address: address)
                
                await MainActor.run {
                    alertBody = AppAlert(message: String(localized: "Ordering is complete"), title: String(localized: "Ordering"))
                   
                    cleanCart()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { self.isContinue.toggle()})
            }
            catch {
                print(error
                    .localizedDescription)
            }
        }
    }
    func cancelButtonTaped() {
        newAddressAdd.toggle()
        newAddress = ""
    }
    func cleanCart() {
//        if let realm = try? Realm(){
//            try? realm.write({
//                realm.deleteAll()
//            })
//        }
        realmManager.cleanCart()
    }
}

