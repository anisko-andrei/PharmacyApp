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
            if cartValues.count < 1 {
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
                    ForEach(cartValues, id: \._id) { item in
                        
                        CartRow(item: item)
                    }
                    
                    .onDelete(perform: $cartValues.remove)
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
                        vm.isContinue.toggle()
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
                Text(String.localizedStringWithFormat(NSLocalizedString("r.", comment: ""), cartValues.reduce(0, { $0 + ($1.price * Double($1.count))
                })))
                
                    .font(.title3)
                    .bold()
                    .foregroundColor(.black)
            }
            
            .padding()
            
            .background(.green)
            .padding(.top, -8)
        }
        .onChange(of: cartValues.reduce(0, { $0 + ($1.price * Double($1.count))
        }), perform: { newValue in
            vm.totalPrice = newValue
        })
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
        CartView()
        // CartRow(item: CartItem.test )
    }
}

struct CartRow: View {
    @ObservedRealmObject var item : CartItem
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: item.logo)) { logo in
                ZStack {
                    Rectangle()
                        .frame (maxWidth: 60,  maxHeight: 60)
                        .background(.white)
                        .cornerRadius(9)
                    logo
                        .resizable()
                        .scaledToFit()
                        .frame (maxWidth: 60,  maxHeight: 60)
                        .cornerRadius(9)
                }
            } placeholder: {
                Image(Constants.pharmPlaceholder)
                    .resizable()
                    .scaledToFit()
                    .frame (maxWidth: 60,  maxHeight: 60)
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
                    .font(.system(size: 20))
                    .padding(.leading, 4)
                HStack {
                
                    Text("Total:")
                        .padding(.leading, 4)
                    Text(String.localizedStringWithFormat(NSLocalizedString("r.", comment: ""), (Double(item.count) * item.price)))
                    
                        .font(.system(size: 16))
                       
                    
                    Spacer()
                    
                    HStack() {
                        
                        Button {
                            if $item.count.wrappedValue > 1 {
                                $item.count.wrappedValue -= 1
                            }
                            else {
                                if let thawedItem = item.thaw() {
                                    try? thawedItem.realm?.write {
                                        thawedItem.realm?.delete(thawedItem)
                                    }
                                }
                                
                            }
                        } label: {
                            Image(systemName: "minus")
                                .foregroundColor(.green)
                                .font(.system(size: 16))
                                .padding(4)
                        }
                        Spacer()
                        Text(String(item.count))
                            .foregroundColor(.black)
                            .padding(4)
                        Spacer()
                        Button {
                            $item.count.wrappedValue += 1
                            
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.green)
                                .font(.system(size: 16))
                                .padding(4)
                            
                        }
                     
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .frame(width: 120)
                    .background(.white)
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
