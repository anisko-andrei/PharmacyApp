//
//  TabBarNavigationView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 20.06.23.
//

import SwiftUI
import KeychainSwift

struct TabBarNavigationView: View {
    @State var tabSelected: Tab = .house
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $tabSelected) {
                OTPMobileNumberScreen()
                    .tag(Tab.house)
                
                LoadingView()
                    .tag(Tab.cart)
                
                ProstoView()
                    .tag(Tab.phone)
                
                ProstoView()
                    .tag(Tab.person)
            }
        
            ZStack{
                CustomTabBar(selectedTab: $tabSelected)
                    .padding(.bottom, -14)
            }
        }
        .ignoresSafeArea(.keyboard , edges: .bottom)
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

enum Tab: String, CaseIterable {
    case house
    case cart
    case phone
    case person
    
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    private var fillImage: String {
        selectedTab.rawValue.appending(".fill")
    }

    var body: some View {
       HStack {
           ForEach(Tab.allCases, id: \.rawValue) { tab in
               Spacer()
               Button {
                   selectedTab = tab
               } label: {
                   Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                       .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
                        .foregroundColor(tab == selectedTab ? .green : .gray)
                        .font(.system(size: 20))
                }
               Spacer()
            }
        }
       .frame(height: 50)
       .background(.thinMaterial)
       .cornerRadius(9)
       .padding()
       .shadow(color: .black, radius: 100)
    }
}
