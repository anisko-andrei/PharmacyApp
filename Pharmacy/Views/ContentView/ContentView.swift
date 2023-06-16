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
        switch vm.authState {
        case .loading :
            EmptyView()
        case .logged :
            EmptyView()
        case .unlogged :
            OTPMobileNumberScreen()
    
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
