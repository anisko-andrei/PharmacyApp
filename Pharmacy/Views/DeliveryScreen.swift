//
//  DeliveryScreen.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 1.07.23.
//

import SwiftUI

struct DeliveryScreen: View {
    var body: some View {
        NavigationStack {
            VStack() {
                LogoView()
                    .padding()
                Text("Something about delivery, will add text later")
                Spacer()
            }
            .navigationTitle("Delivery")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
            leading: NavigationCustomBackButton())
        }
       
    }
        
}

struct DeliveryScreen_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryScreen()
    }
}
