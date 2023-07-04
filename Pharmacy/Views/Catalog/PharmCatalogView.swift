//
//  PharmCatalogView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 1.07.23.
//

import SwiftUI

struct PharmCatalogView :View {
    @ObservedObject var vm : CatalogVM
    
    var item: ResultCategories
    var body: some View {
        VStack {
            LogoView()
                .padding()
            ScrollView {
                ForEach(vm.pharm, id: \.objectID) { item in
                    PharmCard(item: item, vm: MainVM())
                }
            }
        
        }
        .navigationTitle(item.name)
        .task {
            await vm.getPharm(path: item.objectID)
        }
    }
        
}

struct PharmCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        PharmCatalogView(vm: CatalogVM(), item: .init(objectID: "rXb1OuevvD", name: "Chtoto", createdAt: "", updatedAt: ""))
    }
}
