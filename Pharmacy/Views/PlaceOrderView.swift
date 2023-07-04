//
//  PlaceOrderView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 4.07.23.
//

import SwiftUI

struct PlaceOrderView: View {
   
    @ObservedObject var vm: cartVM
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack(alignment: .leading) {
                  
                        Text("Select your address:")
                        .padding()
                    HStack{
                        Menu(content: {
                            ForEach(vm.addresses.results, id: \.objectID) { item in
                                Button {
                                    vm.selected = item.address
                                } label: {
                                    Text(item.address ?? "")
                                }
                                
                                
                            }}, label: {
                                Text(vm.selected ?? "Select")
                            })
                        
                        .foregroundColor(.green)
                        
                        Spacer()
                        
                        Button(action: {
                            vm.newAddressAdd.toggle()
                        }, label: {
                            Text("Add new")
                        })
                        .foregroundColor(.green)
                    }
                    .padding(.horizontal)
                    HStack() {
                        Text("Select your payment method:")
                        Menu(content: {
                            ForEach(PaymentMethod.allCases, id: \.id) { item in
                                Button {
                                    vm.payment = item
                                } label: {
                                    Text(item.rawValue)
                                }
                                
                                
                            }}, label: {
                                Text(vm.payment?.rawValue ?? "Select")
                            })
                        
                        .foregroundColor(.green)
                        .listStyle(.grouped)
                        
                    }
                    Spacer()
                    OTPButton(title: "Order") {
                        vm.newOrder()
                    }
                    .padding()
                }
                    .navigationTitle("Ordering")
                    .navigationBarTitleDisplayMode(.inline)
                
                if vm.newAddressAdd {
                    ZStack{
                        BlurView(style: .systemChromeMaterialDark)
                            .ignoresSafeArea()
                        
                        VStack {
                            Text("Enter your new address")
                                .font(.system(size: 24))
                            HStack {
                                Image(systemName: "location")
                                    .padding(16)
                                TextField("Enter address", text: $vm.newAddress)
                                // .padding(.vertical,16)
                            }
                            .background(.background)
                            .cornerRadius(12)
                            .padding(8)
                            
                            
                            
                            
                            
                            HStack {
                                OTPButton(title: "Save") {
                                    vm.addNew(newAddress: vm.newAddress)
                                }
                                .padding(.horizontal, -8)
                                OTPButton(title: "Cancel") {
                                    vm.cancelButtonTaped()
                                    
                                }
                                .padding(.horizontal, -8)
                            }
                        }
                        .padding(16)
                        .background()
                        .cornerRadius(12)
                        .padding(16)
                    }
                    
                }
                }
                

            }
            
            
        .task {
          await vm.loadAdres()
        }
      
    }
}
struct PlaceOrderView_Previews: PreviewProvider {
    
    static var previews: some View {
        PlaceOrderView(vm: cartVM())
    }
}


enum PaymentMethod : String, CaseIterable, Identifiable {
   
    
    var id: String {self.rawValue}
    
    case card = "Card"
    case cash = "Cash"
    
    
}

//class PlaceOrderVM : ObservableObject {
//    @Published var selected: String?
//    @Published var addresses: Addresses = Addresses(results: [])
//    @Published var payment: PaymentMethod?
//    @Published var newAddress: String = ""
//    @Published var newAddressAdd: Bool = false
//
//    let AFManager: AlamofireManagerProtocol = AlamofireManager()
//
//    func loadAdres() async{
//
//            do{
//                let result = try await AFManager.getSaved()
//                await MainActor.run(body: {
//                    addresses = result
//                })
//                print(addresses)
//            }
//            catch {
//                print("eror")
//            }
//
//    }
//
//    func addNew(newAddress: String) {
//        Task {
//            do {
//                try await AFManager.addAddress(newAddress: newAddress)
//                let newV = try await AFManager.getSaved()
//                await MainActor.run(body: {
//                    addresses = newV
//                    selected = newAddress
//                    cancelButtonTaped()
//
//                })
//            }
//            catch{
//                print("eerrr")
//            }
//        }
//    }
//
//    func newOrder() {
//        guard let address = selected,
//              let paymentM = payment?.rawValue else {return}
//        Task {
//
//            do{
//                try await AFManager.sendOrder(price: 1, paymentMethod: paymentM, address: address)
//
//                await MainActor.run {
//
//                }
//            }
//        }
//    }
//    func cancelButtonTaped() {
//        newAddressAdd.toggle()
//        newAddress = ""
//    }
//}
