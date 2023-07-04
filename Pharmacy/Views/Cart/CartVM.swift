//
//  CartVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 4.07.23.
//

import Foundation
import RealmSwift
class CartVM: ObservableObject {
    @Published var isContinue = false
    @Published var selected: String?
    @Published var addresses: Addresses = Addresses(results: [])
    @Published var payment: PaymentMethod?
    @Published var newAddress: String = ""
    @Published var newAddressAdd: Bool = false
    @Published var totalPrice: Double = 0
    let AFManager: AlamofireManagerProtocol = AlamofireManager()
    @Published var alertIsPresented = false
    @Published var alertBody : AppAlert? {
        didSet {
            self.alertIsPresented.toggle()
        }
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
                try await AFManager.sendOrder(price: totalPrice , paymentMethod: paymentM, address: address)
                
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
        if let realm = try? Realm(){
            try? realm.write({
                realm.deleteAll()
            })
        }
    }
}

