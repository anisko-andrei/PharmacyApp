//
//  CatalogVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 1.07.23.
//

import Foundation
class CatalogVM : MainVM {
    @Published var categories: [ResultCategories] = []

    @Published var pharm : [ResultSalePharm] = []
    var AFMAnager: AlamofireManagerProtocol = AlamofireManager()
    
    func getCategories() async {
        
            do{
                let result = try await AFMAnager.getCategories()
                await MainActor.run(body: {
                    categories = result.results
                })
            }
            catch {
                print("=(")
            }
    
    }
    
    func getPharm(path: String)  async{
   
            do{
                let result = try await AFMAnager.getPharm(path: path)
                await MainActor.run(body: {
                    pharm = result.results
                })
            }
            catch {
                await MainActor.run(body: {
                    pharm = []
                })
                print("=(")
            }
    
    }

    
    
    
}
