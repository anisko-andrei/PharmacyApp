//
//  LoadingView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 26.06.23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image("loadingImage")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 80)
            Text("Pharmacy")
                .font(.system(size: 30))
            Text("Health first")
                .font(.system(size: 18).italic())
            
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
