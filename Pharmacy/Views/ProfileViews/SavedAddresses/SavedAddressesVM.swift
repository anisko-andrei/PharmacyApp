//
//  SavedAddressesVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 29.06.23.
//

import Foundation
import Alamofire

class SavedAddressesVM : ObservableObject {
    @Published var addresses: Addresses = Addresses(results: [])
    @Published var newAddress: String = ""
    @Published var newAddressAdd: Bool = false
    let AFManager: AlamofireManagerProtocol = AlamofireManager()
    func delete(at offsets: IndexSet) {
        guard let index = offsets.first else {return}
        Task {
            do {
                try await AFManager.deleteAddressAtServer(addressId: addresses.results[index].objectID)
                await MainActor.run(body: {
                    addresses.results.remove(atOffsets: offsets)
                })
            }
            catch {
                print("ne ydalilos'")
            }
        }
       
        }

    func cancelButtonTaped() {
        newAddressAdd.toggle()
        newAddress = ""
    }
    
    func addNew(newAddress: String) {
        Task {
            do {
                try await AFManager.addAddress(newAddress: newAddress)
                let newV = try await AFManager.getSaved()
                await MainActor.run(body: {
                    addresses = newV
                    cancelButtonTaped()
                })
            }
            catch{
                print("eerrr")
            }
        }
    }
    func loadAdres() {
        Task {
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
    }
}
