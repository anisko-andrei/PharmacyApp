//
//  CartView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 2.07.23.
//

import SwiftUI
import RealmSwift
struct CartView: View {
    @ObservedResults(CartItem.self) var cartValues
    @StateObject var vm = CartVM()
    var body: some View {
        VStack {
            LogoView()
                .padding()
            if cartValues.count  < 1 {
                VStack {
                    Spacer()
                    Image(systemName: "cart.badge.minus")
                        .font(.system(size: 30))
                        .foregroundColor(.green)
                    Text("Your cart is empty")
                    Spacer()
                }
            }
            
           else {
                ScrollView {
                    ForEach (cartValues, id: \._id) { item in
                        
                        CartRow(item: item, vm: vm)
                    }
                }
                .listStyle(.inset)
            }
            Spacer()
            if cartValues.count > 0 {
                HStack{
                    Button {
                        vm.cleanCart()
                    } label: {
                      
                        Text("Clean")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 9)
                            .inset(by: 0.5)
                            .stroke(.black)
                    )
                    .padding(4)
                    Spacer()
                    Button {
                        vm.placeOrderButtonTaped()
                       
                    } label: {
                        
                        Text("Place an order")
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 9)
                            .inset(by: 0.5)
                            .stroke(.black)
                    )
                    .padding(4)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, -4)
                .background(.green)
            }
            HStack{
                Text("Total:")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)
                Spacer()
                Group {
                    Text("\(vm.totalPrice, specifier: "%.2f")")  + Text("r.")
                }
                    .font(.title3)
                    .bold()
                    .foregroundColor(.black)
            }
            
            .padding()
            
            .background(.green)
            .padding(.top, -8)
        }
      
        .sheet(isPresented: $vm.isContinue) {
            PlaceOrderView(vm: vm)
        }
    }
}
extension CartItem {
    static let test = CartItem(value: ["title":"Paracatamol",
                                       "price": 5.6,
                                       "logo": "https://www.mongodb.com/developer/_next/image/?url=https%3A%2F%2Fimages.contentstack.io%2Fv3%2Fassets%2Fblt39790b633ee0d5a7%2Fblt8c5aec4b7f6a4881%2F647a2dfe095bb782e057f817%2Frealm-mobile.jpg&w=3840&q=75",
                                       "count": 1,
                                       "itemId": ""] as [String : Any])
}
struct CartView_Previews: PreviewProvider {
    static var previews: some View {
       // CartView()
        CartRow(item: CartItem.test, vm: CartVM() )
    }
}

struct CartRow: View {
    var item : CartItem
    @ObservedObject var vm : CartVM
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: item.logo)) { logo in
                    ZStack{
                        Rectangle()
                            .frame (maxWidth: 80,  maxHeight: 80)
                            .cornerRadius(9)
                            .foregroundColor(.white)
                            
                        logo
                            .resizable()
                            .scaledToFit()
                            .padding(8)
                            .frame (maxWidth: 80,  maxHeight: 80)
                            .cornerRadius(9)
                    
                    }
                }
                placeholder: {
                    Image(Constants.pharmPlaceholder)
                        .resizable()
                        .scaledToFit()
                        .padding(8)
                        .frame (maxWidth: 80,  maxHeight: 80)
                }
            .overlay(
                RoundedRectangle(cornerRadius: 9)
                    .inset(by: 0.5)
                    .stroke(.green)
                )
            
            .padding(.leading, 8)
            .padding(.vertical, 8)
            
            VStack(alignment: .leading) {
                Text(item.title.capitalized)
                    .font(.system(size: 18))
                    .bold()
                    .padding(.leading, 4)
                HStack {
                    Group{
                    Text("Total:") +
                    
                        Text("\(Double(item.count) * item.price, specifier: "%.2f")")  +
                    Text("r.")
                }
                        .font(.system(size: 16))
                        .padding(.leading, 4)
                    
                    Spacer()
                    
                    HStack() {
                        
                        Button {
                            vm.editItemCountMinus(item: item.thaw() ?? CartItem())
                        } label: {
                            Image(systemName: "minus")
                                .foregroundColor(.green)
                                .font(.system(size: 16))
                                .padding(4)
                        }
                        Spacer()
                        Text(String(item.count))
                            .minimumScaleFactor(0.5)
                            .scaledToFit()
                            .foregroundColor(Color(UIColor.label))
                            .padding(.horizontal,8)
                           
                        Spacer()
                        Button {
                            vm.editItemCountPlus(item: item.thaw() ?? CartItem())
                            
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.green)
                                .font(.system(size: 16))
                                .padding(4)
                            
                        }
                     
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .frame(width: 120)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(9)
                    .overlay(
                      RoundedRectangle(cornerRadius: 9)
                        .inset(by: 0.5)
                        .stroke(.green)
                    )
                    
                }
                
            }
            Spacer()
        }
        
        
        .frame(maxWidth: .infinity)
        .frame(height:  110)
        .background(.thinMaterial)
        .cornerRadius(9)
        .padding(.horizontal)
    }
}
