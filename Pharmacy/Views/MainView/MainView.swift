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
       NavigationStack {
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
                switch vm.loadingStatus {
                case .loading :
                    VStack{
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                case .showResult :
                    if vm.salesResult.isEmpty {
                        NoResultLogo(text: "Sorry, there are no discounts right now.", imageName: "nosign")
                    }
                    else {
                            ScrollView{
                            VStack {
                               
                                ForEach(vm.salesResult, id: \.objectID) { item in
                                   
                                    PharmCard(item: item, vm: vm)
                                    }
                                }
                            
                        }
                    }
                case .noResult :
                   NoResultLogo(text: "Something's wrong try again later", imageName: "gear.badge.xmark")
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

struct NoResultLogo: View {
    var text: LocalizedStringKey
    var imageName: String
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: imageName)
                .font(.system(size: 30))
                .foregroundColor(.green)
            Text(text)
            Spacer()
        }
    }
}

struct SearchButton: View {
    var body: some View {
      
            HStack() {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.green)
                    .padding(.leading,8)
                Text("Catalog Search")
                    .foregroundColor(Color(UIColor.label))
                    .padding(.vertical, 16)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .cornerRadius(9)
            .padding(.horizontal,40)
        }
    
}
