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
        NavigationView {
            VStack {
                LogoView()
                    .padding(.vertical)
                SearchButton()
                   
                
                List {
                    ForEach(vm.categories, id: \.objectID) { item in
                        NavigationLink {
                            PharmCatalogView(vm: vm, item: item)
                               //.onAppear {
                                   
                              //  }
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
        }
        
        .task {
            vm.getCategories()
        }
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView()
    }
}


