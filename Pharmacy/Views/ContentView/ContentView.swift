//
//  ContentView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 11.06.23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: ContentViewVM
    var body: some View {
        Group {
            switch vm.authState {
            case .loading :
                LoadingView()
            case .logged :
                TabBarNavigationView()
            case .unlogged :
                OTPMobileNumberScreen()
            }
        
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                vm.checkAuth()
            }
        }
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
