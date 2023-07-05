//
//  ChangeProfileInfoView.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 29.06.23.
//

import SwiftUI
import iPhoneNumberField
import PhoneNumberKit

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
                        
                        
                        iPhoneNumberField("+375-29-111-11-11", text: $vm.phoneNumber)
                            .prefixHidden(false)
                           
                            .maximumDigits(9)
                          
                            
                            .padding(.horizontal,100)
                            .font(.system(size: 20))
                            .submitLabel(.done)
                            
                            .padding(.vertical,8)
                            .focused($focusField, equals: .phone)
                            .submitLabel(.done)
                        Rectangle()
                            .frame(maxHeight: 1)
                            .padding(.horizontal, 90)
                            .foregroundColor(.green)
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
                        .opacity(vm.checState() ? 1 : 0.3)
                        .disabled(!vm.checState())
                        OTPButton(title: "Cancel") {
                            vm.startStopEditing()
                        }
                        
                    }
                    .padding(.vertical, 8)
                } else
                {
                    ProfileText(text: {User.shared.username ?? "name"}())
                        .padding(.vertical,8)
                    ProfileText(text: User.shared.userLastName ?? "lastName")
                        .padding(.vertical,8)
                    
                    iPhoneNumberField("+375-29-111-11-11", text: $vm.phoneNumber)
                        .prefixHidden(false)
                        .font(.systemFont(ofSize: 20))
                        .maximumDigits(9)
                      
                       
                        .padding(.horizontal,100)
                        .font(.system(size: 20))
                        .submitLabel(.done)
                        
                        .padding(.vertical,8)
                        .disabled(true)
                    Rectangle()
                        .frame(maxHeight: 1)
                        .padding(.horizontal, 90)
                        .foregroundColor(.green)
                    
                  
                }
            }
        }
        .navigationTitle("Change profile")
        .toolbar {
            Button {
                vm.startStopEditing()
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
