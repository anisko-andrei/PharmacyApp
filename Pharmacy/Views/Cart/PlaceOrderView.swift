//
//  PlaceOrderView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 4.07.23.
//

import SwiftUI

struct PlaceOrderView: View {
   
    @ObservedObject var vm: CartVM
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack(alignment: .leading) {
                  
                        Text("Select your address:")
                         .padding(.horizontal, 8)
                    HStack(spacing: 8){
                        Menu(content: {
                            ForEach(vm.addresses.results, id: \.objectID) { item in
                                Button {
                                    vm.selected = item.address
                                } label: {
                                    Text(item.address ?? "")
                                }
                                
                                
                            }}, label: {
                                Text(vm.selected ?? String(localized: "Select"))
                               
                                    .foregroundColor(.black)
                                    .font(.system(size: 16))
                                    .frame(maxWidth: .infinity, maxHeight: 40)
                                    .background(Color.green)
                                    .cornerRadius(14)
                                    .padding(.leading, 16)
                            })
                        
                        .foregroundColor(.green)
                
                        Button(action: {
                            vm.newAddressAdd.toggle()
                        }, label: {
                            Image(systemName: "plus")
                            
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                                .frame(maxWidth: 40, maxHeight: 40)
                                .background(Color.green)
                                .cornerRadius(14)
                                .padding(.trailing, 16)
                        })
                        .foregroundColor(.green)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text("Select your payment method:")
                            
                        Menu(content: {
                            ForEach(PaymentMethod.allCases, id: \.id) { item in
                                Button {
                                    vm.payment = item
                                } label: {
                                    Text(item.localized)
                                    
                                }
                                
                                
                            }}, label: {
                                Text(vm.payment?.localized ?? "Select")
                                    .foregroundColor(.black)
                                    .font(.system(size: 16))
                                    .frame(maxWidth: .infinity, maxHeight: 40)
                                    .background(Color.green)
                                    .cornerRadius(14)
                                    .padding(.horizontal, 16)
                            })
                        
                        .foregroundColor(.green)
                        .listStyle(.grouped)
                        
                    }
                    .padding(.horizontal)
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
            .alert(vm.alertBody.title, isPresented: $vm.alertIsPresented, presenting: vm.alertBody) { _ in
                Button("ok", role: .cancel) {}
            } message: { bodyM in
                Text(bodyM.message)
            }

            }
            
            
        .task {
          await vm.loadAdres()
        }
      
    }
}
struct PlaceOrderView_Previews: PreviewProvider {
    
    static var previews: some View {
        PlaceOrderView(vm: CartVM())
    }
}


enum PaymentMethod : String, CaseIterable, Identifiable {
    var id: String {self.rawValue}
    case card = "Card"
    case cash = "Cash"
    
    var localized : LocalizedStringKey {
        switch self {
        case .card:
            return "Card"
        case .cash:
            return "Cash"
        }
    }
    
}
