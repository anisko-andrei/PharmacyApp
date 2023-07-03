//
//  CartView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 2.07.23.
//

import SwiftUI

struct CartView: View {
    var body: some View {
        VStack {
            LogoView()
                .padding()
            Spacer()
            
            HStack{
                Text("Total:")
                    .font(.title2)
                    .bold()
                Spacer()
                Text(String.localizedStringWithFormat(NSLocalizedString("r.", comment: ""), 34.34))
                    .font(.title3)
                    .bold()
            }
            .padding()
            .background(.green)
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
