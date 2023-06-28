//
//  TabBarNavigationVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 20.06.23.
//

import Foundation

class TabBarNavigationVM : ObservableObject {
    @Published var tabSelected: Tab = .house
    @Published var isLogOut = false
}
