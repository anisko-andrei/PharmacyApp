//
//  SearchView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 4.07.23.
//

import SwiftUI

struct SearchView: View {
    @StateObject var vm : SearchVM = SearchVM()
    var body: some View {
        NavigationView {
            
           ScrollView {
                ForEach(vm.searchResult, id: \.objectID) { item in
                    PharmCard(item: item, vm: vm)
                }
            }.searchable(text: $vm.searchText)
        }
        .task {
            await vm.getPharms()
        }
    }
}
struct SearchViev_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
class SearchVM : MainVM {
    @Published var pharms: [ResultSalePharm] = []
    @Published var searchResult: [ResultSalePharm] = []
    @Published var searchText: String = "" {
        didSet {
            if searchText.isEmpty {
                searchResult = pharms
            } else {
                searchResult = pharms.filter{$0.title.contains(searchText.lowercased())}
            }
        }
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
