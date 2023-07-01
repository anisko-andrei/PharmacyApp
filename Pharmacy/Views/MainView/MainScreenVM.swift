//
//  MainScreenVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 1.07.23.
//

import Foundation

class MainVM : ObservableObject {
    @Published var sheetToOpen: MainScreenButtons?
    @Published var sheetItem : ResultSalePharm?
    var AFManager: AlamofireManagerProtocol = AlamofireManager()
    @Published var salesResult: [ResultSalePharm] = []
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
}
