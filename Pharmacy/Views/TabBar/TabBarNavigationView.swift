//
//  TabBarNavigationView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 20.06.23.
//

import SwiftUI
import KeychainSwift

struct TabBarNavigationView: View {
    var body: some View {
        TabView {
            ProstoView()
                .tabItem {
                    Image(systemName: "square.and.arrow.down.on.square")
                    Text("dddsd")
                }
            ProstoView()
                .tabItem {
                    Image(systemName: "square.and.arrow.down.on.square")
                    Text("fdf")
                }
        }
    }
}

struct TabBarNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarNavigationView()
    }
}

struct ProstoView : View {
    var body: some View {
        VStack{
            Text("hello, \(User.shared.username ?? "world")")
            Text("hello, \(User.shared.userLastName ?? "world")")
            Text("hello, \(User.shared.userMobilePhone ?? "world")")
            Button("logOut") {
                KeychainSwift().delete("userToken")
            }
    }
        
    }
}
