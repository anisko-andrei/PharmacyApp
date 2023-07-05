//
//  ContactsView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 28.06.23.
//

import SwiftUI

struct ContactsView : View {
    var body: some View {
        NavigationStack {
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
                    if let firstPhoneUrl = URL(string: "tel:+375295158494") {
                        Link(destination:
                                firstPhoneUrl) {
                            Label {
                                Text("+375-29-515-84-94")
                            } icon: {
                                Image(systemName: "phone")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    if let secondPhoneUrl = URL(string: "tel:+375295158495") {
                        Link(destination: secondPhoneUrl ) {
                            Label {
                                Text("+375-29-515-84-95")
                            } icon: {
                                Image(systemName: "phone")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    
                    if let telegramUrl = Constants.telegramUrl {
                        Link(destination: telegramUrl) {
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
                }
                .listStyle(.inset)
                .scrollDisabled(true)
                Spacer()
            
        }
            .navigationTitle("About us")
            .navigationBarBackButtonHidden(false)
            .navigationBarTitleDisplayMode(.inline)
            
        }

    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
