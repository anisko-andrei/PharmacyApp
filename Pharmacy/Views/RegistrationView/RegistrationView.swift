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
    @FocusState var focusField : FormFields?
    var body: some View {
        VStack {
            Spacer()
            Image(Constants.otpImage)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 230)
                .padding(.bottom)
            Text("Registration")
                .font(.system(size: 24))
            
            Group {
                RegistrationTextField(labelText: "Name", inputText: $vm.name)
                    .padding(.vertical,8)
                    .focused($focusField, equals: .name)
                    .submitLabel(.next)
                RegistrationTextField(labelText: "Last name", inputText: $vm.lastName)
                    .focused($focusField, equals: .lastName)
                    .submitLabel(.done)
                    .padding(.vertical,8)
            }
            .onSubmit {
                switch focusField {
                case .name:
                    focusField = .lastName
                default :
                    focusField = nil
                }
            }
            Spacer()
                
            OTPButton(title: "Next") {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
    var submitLabel : SubmitLabel = .continue
    var body: some View {
        VStack {
            TextField(labelText, text: $inputText)
                .padding(.horizontal,100)
                .font(.system(size: 20))
            Rectangle()
                .frame(maxHeight: 1)
                .padding(.horizontal, 90)
                .foregroundColor(.green)
        }
    }
}

enum FormFields {
    case name, lastName
}
