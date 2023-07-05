//
//  ProfileView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 28.06.23.
//

import SwiftUI
import KeychainSwift
import iPhoneNumberField
struct ProfileView: View {
    @ObservedObject var tabBarVM: TabBarNavigationVM
    @StateObject var user = User.shared
    var body: some View {
        NavigationStack {
            
            
            VStack {
                HStack{
                    Image(systemName: "person.circle")
                        .font(.system(size: 70))
                    Spacer()
                    VStack{
                        Text(user.userNamePlusLastName)
                            .font(.system(size: 22))
                        
                      
                        iPhoneNumberField("+375-29-111-11-11", text: .constant(user.userMobilePhone ?? "23"))
                                .prefixHidden(false)
                                .font(.systemFont(ofSize: 18))
                                .maximumDigits(9)
                                .multilineTextAlignment(.center)
                            
                               
                                .font(.system(size: 20))
                              
                            
                                .disabled(true)
                    }
                    
                    Spacer()
                    
                }
                .padding()
                List {
                    NavigationLink {
                        OrderHistoryView()
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
                       ChangeProfileInfoView()
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
                Spacer()
                OTPButton(title: "Log Out") {
                    tabBarVM.isLogOut.toggle()
                    KeychainSwift().delete("userToken")
                }
                .padding()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(tabBarVM: TabBarNavigationVM())
    }
}
