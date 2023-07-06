//
//  LoadingView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 26.06.23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        LogoView()
    }
}


struct LogoView: View {
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Image(Constants.pharmacyLogoImage)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 80)
            VStack {
                Text("Pharmacy")
                    .font(.system(size: 30))
                Text("Health first")
                    .font(.system(size: 18).italic())
            }
            Spacer()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
