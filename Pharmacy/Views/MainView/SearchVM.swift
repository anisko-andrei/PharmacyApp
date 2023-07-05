//
//  SearchVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 5.07.23.
//

import Foundation
import Combine
class SearchVM : MainVM {
    @Published var pharms: [ResultSalePharm] = []
    @Published var searchResult: [ResultSalePharm] = []
    @Published var searchText: String = ""
   
    private var cancellableSet : Set<AnyCancellable> = []
    
    override init() {
        super.init()
        $searchText
            .sink(receiveValue: {[weak self] sText in
                guard let self else {return}
                if sText.isEmpty {
                    self.searchResult = self.pharms
                            } else {
                                self.searchResult = self.pharms.filter{$0.title.contains(sText.lowercased())}
                            }
            })
            .store(in: &cancellableSet)
    }
  
    deinit {
        cancellableSet.removeAll()
    }
    func getPharms() async {
    
        do {
            let result = try await AFManager.getPharm(path: "allCases")
            await MainActor.run(body: {
                pharms = result.results.map{ResultSalePharm(objectID: $0.objectID, title: $0.title.lowercased(), logo: $0.logo, price: $0.price, description: $0.description, createdAt: $0.createdAt, updatedAt: $0.updatedAt)}.sorted(by: {$0.title < $1.title})
                searchResult = pharms
            })
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
