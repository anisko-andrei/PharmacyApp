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
        VStack{
            
           ScrollView {
                ForEach(vm.searchResult, id: \.objectID) { item in
                    PharmCard(item: item, vm: vm)
                }
            }
           .searchable(text: $vm.searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
        .autocorrectionDisabled()
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

