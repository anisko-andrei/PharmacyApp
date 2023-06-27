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
//        TabView {
//            ProstoView()
//                .tabItem {
//                    Image(systemName: "house") //house.fill
//                    Text("Home")
//                }
//            ProstoView()
//                .tabItem {
//                    Image(systemName: "cart") //cart.fill
//                    Text("Cart")
//                }
//            ProstoView()
//                .tabItem {
//                    Image(systemName: "phone") //phone.fill
//                    Text("Contact")
//                }
//            ProstoView()
//                .tabItem {
//                    Image(systemName: "person") //person.fill
//                    Text("Account")
//                }
//        }
        ZStack {
            VStack {
                TabView(selection: $tabSelected) {
                    ForEach(Tab.allCases, id: \.rawValue) { tab in
                        HStack {
                            switch tab {
                            case .house :
                                ProstoView()
                            case.person :
                                OTPMobileNumberScreen()
                            default:
                                LoadingView()
                            }
                        }
                        .tag(tab)
                        
                    }
                }
            }
                VStack{
                    Spacer()
                    CustomTabBar(selectedTab: $tabSelected)
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
        VStack {
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
                    }.background(Color.red)
                    
                    
                    Spacer()
                }
            }
            .frame(height: 55)
            .background(.thinMaterial)
            .cornerRadius(9)
            .padding()
        }
    }
}
