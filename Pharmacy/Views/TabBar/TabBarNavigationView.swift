//
//  TabBarNavigationView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 20.06.23.
//

import SwiftUI
import KeychainSwift

struct TabBarNavigationView: View {
   
    @StateObject var vm: TabBarNavigationVM = TabBarNavigationVM()
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $vm.tabSelected) {
                MainView()
                    .tag(Tab.house)
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(.hidden, for: .tabBar)
                CartView()
                    .tag(Tab.cart)
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(.hidden, for: .tabBar)

                ContactsView()
                    .tag(Tab.phone)
                    .toolbar(.hidden, for: .tabBar)
                ProfileView(tabBarVM: vm)
                    .tag(Tab.person)
                    .toolbar(.visible, for: .tabBar)
            }
            
            
            ZStack{
                CustomTabBar(selectedTab: $vm.tabSelected)
                    .padding(.bottom, -14)
            }
        }
    
        .ignoresSafeArea(.keyboard , edges: .bottom)
        
        .fullScreenCover(isPresented: $vm.isLogOut) {
            OTPMobileNumberScreen()
        }
    }
}

struct TabBarNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarNavigationView()
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
                   ZStack {
                       Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                           .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
                           .foregroundColor(tab == selectedTab ? .green : .gray)
                           .font(.system(size: 20))
                       if tab == .cart, selectedTab != .cart {
                           Text("1")
                               .lineLimit(1)
                               .foregroundColor(.white)
                               .font(.system(size: 20))
                               .minimumScaleFactor(0.05)
                               .frame(width: 14, height: 14)
                               .padding(4)
                               .background(.green)
                               .clipShape(Circle())
                              
                               .offset(CGSize(width: 14, height: -10))
                       }
                   }
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
