//
//  OrderHistoryView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 29.06.23.
//

import SwiftUI

struct OrderHistoryView: View {
    @State var vm: OrderHistoryVM = OrderHistoryVM()
    var body: some View {
        NavigationView {
            if vm.allOrders.isEmpty {
                VStack {
                    Image(systemName: "cart.badge.minus")
                        .font(.system(size: 30))
                        .foregroundColor(.green)
                    Text("You haven't placed any orders")
                }
            } else {
                List {
                    ForEach (vm.allOrders, id: \.self) { order in
                        NavigationLink(order) {
                            //SomeView with orderInfo
                        }
                        
                    }
                }
            }
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

class OrderHistoryVM : ObservableObject {
    @Published var allOrders: [String] = []
}
