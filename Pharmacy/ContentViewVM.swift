//
//  ContentViewVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 11.06.23.
//

import Foundation

enum AuthState{
    case loading, logged, unlogged
}


final class ContentViewVM: ObservableObject {
    
    @Published var authState: AuthState = .unlogged
    
}
