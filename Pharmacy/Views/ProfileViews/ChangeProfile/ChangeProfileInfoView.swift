//
//  ChangeProfileInfoView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 29.06.23.
//

import SwiftUI

struct ChangeProfileInfoView: View {
    @StateObject var vm: ChangeProfileInfoVM = ChangeProfileInfoVM()
    @FocusState var focusField: TextFieldType?
    var body: some View {
        NavigationStack {
            VStack{
                if vm.isEditing {
                    
                    Group{
                        RegistrationTextField(labelText: "Name", inputText: $vm.nameText)
                            .padding(.vertical,8)
                            .focused($focusField, equals: .name)
                            .submitLabel(.next)
                        RegistrationTextField(labelText: "Last name", inputText: $vm.lastName)
                            .padding(.vertical,8)
                            .focused($focusField, equals: .lastName)
                            .submitLabel(.next)
                        RegistrationTextField(labelText: "Phone", inputText: $vm.phoneNumber)
                            .padding(.vertical,8)
                            .focused($focusField, equals: .phone)
                            .submitLabel(.done)
                    }
                    .onSubmit {
                        switch focusField {
                        case .name:
                            focusField = .lastName
                        case .lastName:
                            focusField = .phone
                        default :
                            focusField = nil
                        }
                    }
                   
                    HStack {
                        OTPButton(title: "Save") {
                            vm.saveChanges()
                        }
                        OTPButton(title: "Cancel") {
                            vm.isEditing.toggle()
                        }
                    }
                    .padding(.vertical, 8)
                } else
                {
                    ProfileText(text: {User.shared.username ?? "name"}())
                        .padding(.vertical,8)
                    ProfileText(text: User.shared.userLastName ?? "lastName")
                        .padding(.vertical,8)
                    ProfileText(text: User.shared.userMobilePhone ?? "+3752923232323")
                        .padding(.vertical,8)
                }
            }
        }
        .navigationTitle("Change profile")
        .toolbar {
            Button {
                vm.isEditing.toggle()
            } label: {
                Image(systemName: vm.isEditing ? "pencil.circle.fill" : "pencil.circle")
                    .foregroundColor(.green)
            }

        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
                        leading: NavigationCustomBackButton())
    }
}

struct ChangeProfileInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeProfileInfoView()
    }
}

struct ProfileText : View {
    var text: String
    var body: some View {
        VStack (alignment: .leading) {
           Text(text)
                .padding(.horizontal,100)
                .font(.system(size: 20))
                
            Rectangle()
                .frame(maxHeight: 1)
                .padding(.horizontal, 90)
                .foregroundColor(.green)
        }
        
    }
}
