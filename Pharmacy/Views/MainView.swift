//
//  MainView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 29.06.23.
//

import SwiftUI

struct MainView: View {
    @StateObject var vm: MainVM = MainVM()
    var body: some View {
        VStack {
            LogoView()
            
            Button {
            print("open fullcover search")
            } label: {
                HStack() {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.green)
                        .padding(.leading,8)
                    Text("Catalog Search")
                        .foregroundColor(.black)
                        .padding(.vertical, 16)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)
                .cornerRadius(9)
                .padding(.horizontal,40)
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
                           
                            PharmCard(item: item)
                                .onTapGesture {
                                    vm.sheetItem = item
                                }
                            }
                        }
                    
                }
            }
        }
        .task {
            vm.getSales()
        }
        .sheet(item: $vm.sheetToOpen) { sheet in
            switch sheet {
            case .myOrders :
                LoadingView()
            case .catalog :
                SavedAddresses()
            case .delivery :
                LogoView()
            }
        }
        .sheet(item: $vm.sheetItem) { item in
            PharmCard(item: item)
        }
       
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
        //        PharmCard(item: .constant(ResultSalePharm(objectID: "", title: "Paracetomall", logo: "https://apteka-adel.by/upload/iblock/901/6s66iuhoj2sy5a6umgg1eqgb74d1grot.jpg", price: 5.45, oldPrice: 6, description: "his file was generated from JSON Schema using quicktype, do not modify it directly.", createdAt: "", updatedAt: "")))
        //    }
    }
}

class MainVM : ObservableObject {
    @Published var sheetToOpen: MainScreenButtons?
    @Published var sheetItem : ResultSalePharm?
    var AFManager: AlamofireManagerProtocol = AlamofireManager()
    @Published var salesResult: [ResultSalePharm] = []
    func getSales() {
        Task {
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
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: item.logo)) { logo in
                logo
                    .resizable()
                    .frame (maxWidth: 80,  maxHeight: 80)
                    .cornerRadius(9)
            } placeholder: {
                Image(Constants.pharmPlaceholder)
                    .resizable()
                    .frame (maxWidth: 55,  maxHeight: 55)
            }
            .padding(.leading, 8)
            .padding(.vertical, 8)
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.system(size: 20))
                if let oldPrice = item.oldPrice {
                    Text(String(format: "%.2f", oldPrice))
                        .strikethrough()
                }
                Text(String(format: "%.2f", item.price))
                    .font(.system(size: 20))
                    .foregroundColor(.red)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(.thinMaterial)
        .cornerRadius(9)
        .padding(.horizontal)
       
    }
}
