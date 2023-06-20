//
//  RegistrationView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 20.06.23.
//

import SwiftUI

struct RegistrationView: View {
    @Binding var text: String
    var body: some View {
        Text(text)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(text: .constant("Hello"))
    }
}
