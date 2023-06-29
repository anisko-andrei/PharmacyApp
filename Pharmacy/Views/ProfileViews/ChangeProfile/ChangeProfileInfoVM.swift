//
//  ChangeProfileInfoVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 29.06.23.
//

import Foundation
class ChangeProfileInfoVM : ObservableObject {
    @Published var nameText: String = User.shared.username ?? "name"
    @Published var lastName: String = User.shared.userLastName ?? "lastName"
    @Published var phoneNumber: String = User.shared.userMobilePhone ?? "+37653434344"
    @Published var isEditing: Bool = false
   
    func saveChanges() {
        //waitBackEnd =(
        
        User.shared.writeUserData(userName: nameText, userLastName: lastName, userMobilePhone: phoneNumber)
        isEditing.toggle()
    }
}

enum TextFieldType: CaseIterable {
    case name, lastName, phone
}
