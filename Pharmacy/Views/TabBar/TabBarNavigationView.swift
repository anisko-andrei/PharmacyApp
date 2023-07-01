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
                
                LoadingView()
                    .tag(Tab.cart)
                
                ContactsView()
                    .tag(Tab.phone)
                
                ProfileView(tabBarVM: vm)
                    .tag(Tab.person)
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
