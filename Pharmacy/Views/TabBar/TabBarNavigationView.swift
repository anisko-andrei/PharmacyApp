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
                ContactsView()
                    .tag(Tab.house)
                
                LoadingView()
                    .tag(Tab.cart)
                
                ContactsView()
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
            Link("1234567890", destination: URL(string: "tel:1234567890")!)
    }
        
    }
}
struct ContactsView : View {
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    Image(Constants.pharmacyLogoImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 80)
                    Text("Pharmacy")
                        .font(.system(size: 30))
                }
                Text("© Pharmacy Holding Management Company LLC, 2017. All rights reserved.")
                    .padding(.horizontal, 16)
                List {
                    
                    Link(destination: URL(string: "tel:+375295158494")!) {
                        Label {
                            Text("+375-29-515-84-94")
                        } icon: {
                            Image(systemName: "phone")
                                .foregroundColor(.green)
                        }
                    }
                    
                    Link(destination: URL(string: "tel:+375295158495")!) {
                        Label {
                            Text("+375-29-515-84-95")
                        } icon: {
                        Image(systemName: "phone")
                                .foregroundColor(.green)
                        }
                    }
                    
                    Link(destination: Constants.telegramUrl) {
                        Label {
                            Text("Telegram")
                        } icon: {
                            Image(Constants.telegramIco)
                                .resizable()
                                .scaledToFit()
                                //.foregroundColor(.green)
                        }
                    }

                }
                .listStyle(.inset)
                
                Spacer()
            
        }
            .navigationTitle("About us")
            .navigationBarBackButtonHidden(false)
            .navigationBarTitleDisplayMode(.inline)
            
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
