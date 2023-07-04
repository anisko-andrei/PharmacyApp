//
//  OrderHistoryVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 29.06.23.
//

import Foundation
class OrderHistoryVM : ObservableObject {
    @Published var allOrders: [OrdersResult] = []
    let AFManager : AlamofireManagerProtocol = AlamofireManager()
    func getOrders() async {
        do {
            let result = try await AFManager.getOrders()
            await MainActor.run(body: {
                allOrders = result.results
            })
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
