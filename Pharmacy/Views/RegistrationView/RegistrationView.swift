//
//  RegistrationView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 20.06.23.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var vm: OTPMobileNumberScreenVM
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            Spacer()
            Image("OTPImage")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 230)
                .padding(.bottom)
            Text("Registration")
                .font(.system(size: 24))
           
            RegistrationTextField(labelText: "Name", inputText: $vm.name)
                .padding(.vertical,8)
            RegistrationTextField(labelText: "Last name", inputText: $vm.lastName)
                .padding(.vertical,8)
            Spacer()
            OTPButton(title: "Next") {
                Task {
                    await MainActor.run(body: {
                        dismiss()
                    })
                    vm.sheetToShow = .otpCodeScreen
             }
    }
         
           
            .disabled(vm.name.isEmpty  || vm.lastName.isEmpty)
            .opacity(vm.name.isEmpty || vm.lastName.isEmpty ? 0.5 : 1.0)
            Spacer()
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(vm: OTPMobileNumberScreenVM())
    }
}

struct RegistrationTextField: View {
    var labelText: LocalizedStringKey
    @Binding var inputText: String
    
    var body: some View {
        VStack {
            TextField(labelText, text: $inputText)
                .padding(.horizontal,100)
                .font(.system(size: 20))
                .submitLabel(.done)
            Rectangle()
                .frame(maxHeight: 1)
                .padding(.horizontal, 90)
                .foregroundColor(.blue)
        }
    }
}
