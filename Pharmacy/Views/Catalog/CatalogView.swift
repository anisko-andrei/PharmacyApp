//
//  CatalogView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 1.07.23.
//

import SwiftUI

struct CatalogView: View {
    @StateObject var vm: CatalogVM = CatalogVM()
   
    var body: some View {
        NavigationStack {
            VStack {
                LogoView()
                    .padding()
                NavigationLink {
                    SearchView()
                } label: {
                    SearchButton()
                }
                   
                List {
                    ForEach(vm.categories, id: \.objectID) { item in
                        NavigationLink {
                            PharmCatalogView(vm: vm, item: item)
                        } label: {
                            Button {
                                print(item.objectID)
                            } label: {
                                Label {
                                    Text(item.name)
                                } icon: {
                                    Image(Constants.pharmPlaceholder)
                                        .resizable()
                                        .scaledToFit()
                                }
                            }

                        }
                        
                       
                        
                    }
                
                }
             
                .listStyle(.inset)
            }
            .navigationTitle("Catalog")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
            leading: NavigationCustomBackButton())
        }
        
        
        .task {
          await vm.getCategories()
        }
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView()
    }
}


