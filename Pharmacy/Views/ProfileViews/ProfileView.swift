//
//  ProfileView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 28.06.23.
//

import SwiftUI
import KeychainSwift
struct ProfileView: View {
    @ObservedObject var tabBarVM: TabBarNavigationVM
    var body: some View {
        NavigationView {
            
            
            VStack {
                HStack{
                    Image(systemName: "person.circle")
                        .font(.system(size: 70))
                    Spacer()
                    VStack{
                        Text("\(User.shared.username ?? "userName") \(User.shared.userLastName ?? "useerLastName")")
                            .font(.system(size: 22))
                        Text("\(User.shared.userMobilePhone ?? "+375292222222")")
                            .font(.system(size: 18))
                    }
                    Spacer()
                }
                .padding()
                List {
                    NavigationLink {
                        LoadingView()
                    } label: {
                        Label {
                            Text("Order history")
                        } icon: {
                            Image(systemName: "archivebox")
                                .foregroundColor(.green)
                        }
                    }
                    
                    NavigationLink {
                        SavedAddresses()
                    } label: {
                        Label {
                            Text("Saved addresses")
                        } icon: {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.green)
                        }
                    }
                    
                    NavigationLink {
                        LoadingView()
                    } label: {
                        Label {
                            Text("Change profile information")
                        } icon: {
                            Image(systemName: "person.text.rectangle")
                                .foregroundColor(.green)
                        }
                    }
                }
                .listStyle(.inset)
                .scrollDisabled(true)
                OTPButton(title: "Log Out") {
                    tabBarVM.isLogOut.toggle()
                    KeychainSwift().delete("userToken")
                }
                .padding()
                
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(tabBarVM: TabBarNavigationVM())
    }
}
