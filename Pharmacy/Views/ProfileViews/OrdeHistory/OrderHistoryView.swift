//
//  OrderHistoryView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 29.06.23.
//

import SwiftUI

struct OrderHistoryView: View {
    @StateObject var vm: OrderHistoryVM = OrderHistoryVM()
    var body: some View {
        NavigationStack {
            if vm.allOrders.isEmpty {
                VStack {
                    Image(systemName: "cart.badge.minus")
                        .font(.system(size: 30))
                        .foregroundColor(.green)
                    Text("You haven't placed any orders")
                }
            } else {
                List {
                
                    ForEach (vm.allOrders, id: \.objectID) { order in
                        orderHistoryRow(item: order)
                    }
                }
            }
        
       
        }
        .task {
            await vm.getOrders()
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Order history")
        .navigationBarItems(
                        leading: NavigationCustomBackButton())
    }
}

struct OrderHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        OrderHistoryView()
    }
}

struct orderHistoryRow : View {
    var item : OrdersResult
    var body: some View {
        VStack (spacing: 16) {
            HStack {
                Text("Order ID")
                Spacer()
                Text(item.objectID ?? "orderID")
            }
          //  .padding()
            HStack {
                Text("Price")
                Spacer()
                Text(String(format: "%.2f", item.price ?? 0)) + Text("r.")
            }
          //  .padding()
            
            HStack {
                Text("Address")
                Spacer()
                Text(item.address ?? "address")
                    .multilineTextAlignment(.trailing)
            }
          //  .padding()
            HStack {
                Text("Created date")
                Spacer()
                Text(item.createdAt?.dateToString() ?? "date")
                    .multilineTextAlignment(.center)
            }
            //.padding()
            
            HStack {
                Text("Status")
                Spacer()
                if item.isDelivered ?? false {
                    Text("Delivered")
                        .multilineTextAlignment(.center)
                        .padding(4)
                        .background(.green)
                        .cornerRadius(4)
                }
                else {
                    Text("Not delivered")
                        .multilineTextAlignment(.center)
                        .padding(4)
                        .background(.red)
                        .cornerRadius(4)
                }
                
            }
           
           
        }
       
        .font(.system(size: 16))
        .padding(.horizontal)
        
    }
    
 
    
}

extension String {
    func dateToString() -> Self {
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        let dateN = formatter.date(from: self)
        let dateF = DateFormatter()
        dateF.dateFormat = "YYYY-MM-dd HH:MM"
        return dateF.string(from: dateN ?? .now)
    }
}
