//
//  MainView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 29.06.23.
//

import SwiftUI
import RealmSwift
struct MainView: View {
    @StateObject var vm: MainVM = MainVM()
    var body: some View {
       NavigationView {
            VStack {
                LogoView()
                    .padding()
                NavigationLink {
                    SearchView()
                } label: {
                    SearchButton()
                }

                
                HStack{
                    ForEach(MainScreenButtons.allCases, id: \.self) { item in
                        HStack{
                           
                            Button(action: {
                                vm.sheetToOpen = item
                            }, label: {
                                Label {
                                    Text(item.name)
                                        .padding(.vertical, 12)
                                        .padding(.trailing, 8)
                                        .font(.system(size: 14))
                                } icon: {
                                    Image(systemName: item.imageName)
                                        .padding(.leading, 8)
                                }

                            })
                            .foregroundColor(.black)
                           
                            .background(.green)
                            .cornerRadius(9)
                            
                        }
                        
                    }
                }
                .padding()
                ScrollView{
                    if vm.salesResult.isEmpty {
                        ProgressView()
                    } else {
                        VStack {
                           
                            ForEach(vm.salesResult, id: \.objectID) { item in
                               
                                PharmCard(item: item, vm: vm)
                                }
                            }
                        
                    }
                }
            }
            
            .task {
             await vm.getSales()
            }
            .sheet(item: $vm.sheetToOpen) { sheet in
                switch sheet {
                case .myOrders :
                    OrderHistoryView()
                case .catalog :
                    CatalogView()
                case .delivery :
                    DeliveryScreen()
                }
        }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

enum MainScreenButtons: Int ,Identifiable, CaseIterable {
    var id: Int {self.rawValue}
    var imageName : String {
        switch self {
            
        case .myOrders:
            return "cart"
        case .catalog:
            return "menucard"
        case .delivery:
            return "car.side"
        }
    }
    var name: LocalizedStringKey {
        switch self {
        case .myOrders:
            return "Orders"
        case .catalog:
            return "Catalog"
        case .delivery:
            return "Delivery"
        }
    }
    case myOrders = 1
    case catalog = 2
    case delivery = 3
}

struct PharmCard: View {
    var item : ResultSalePharm
    @State var isPresented = false
    @ObservedObject var vm: MainVM
    var id: String?
    var body: some View {
        Button {
            isPresented.toggle()
        } label: {
            HStack {
                      AsyncImage(url: URL(string: item.logo)) { logo in
                          logo
                              .resizable()
                              .scaledToFit()
                              .frame (maxWidth: 80,  maxHeight: 80)
                              .cornerRadius(9)
                      } placeholder: {
                          Image(Constants.pharmPlaceholder)
                              .resizable()
                              .scaledToFit()
                              .frame (maxWidth: 80,  maxHeight: 80)
                      }
                      .padding(.leading, 8)
                      .padding(.vertical, 8)
                      
                      VStack(alignment: .leading) {
                          Text(item.title.capitalized)
                              .font(.system(size: 20))
                          HStack {
                              VStack {
                                  if let oldPrice = item.oldPrice {
                                      Text(String(format: "%.2f", oldPrice))
                                          .strikethrough()
                                  }
                                  Text(String(format: "%.2f", item.price))
                                      .font(.system(size: 20))
                                      .foregroundColor(.red)
                              }
                               Spacer()
                              Button {
                                  vm.addOrDeleteItemInCart(item: item)
                              } label: {
                             
                                  Image(systemName:  vm.checkInCart(item: item) ? "minus" : "plus")
                                      .foregroundColor(.green)
                                      .font(.system(size: 25))
                                      .frame(width: 40, height: 40)
                                      .background(.gray)
                                      .mask(Circle())
                              }
   
                          }
                          
                      }
                      Spacer()
                  }
        }

        .foregroundColor(.black)
        .sheet(isPresented: $isPresented, content: {
            FullPharmCard(item: item, vm: vm)
        })
        .frame(maxWidth: .infinity)
        .frame(height:  110)
        .background(.thinMaterial)
        .cornerRadius(9)
        .padding(.horizontal)
       
    }
}

struct SearchButton: View {
    var body: some View {
      
            HStack() {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.green)
                    .padding(.leading,8)
                Text("Catalog Search")
                    .foregroundColor(.green)
                    .padding(.vertical, 16)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .cornerRadius(9)
            .padding(.horizontal,40)
        }
    
}
