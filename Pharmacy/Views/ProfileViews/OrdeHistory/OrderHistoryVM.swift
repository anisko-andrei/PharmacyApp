//
//  OrderHistoryVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 29.06.23.
//

import Foundation
class OrderHistoryVM : ObservableObject {
    @Published var allOrders: [String] = []
}
