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
        guard !nameText.isEmpty, !lastName.isEmpty, !phoneNumber.isEmpty else {return}
        Task {
            await User.shared.writeUserData(userName: nameText, userLastName: lastName, userMobilePhone: phoneNumber.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: ""))
            
            
        }
        isEditing.toggle()
    }
    func startStopEditing() {
        isEditing.toggle()
        nameText = User.shared.username ?? "name"
        lastName = User.shared.userLastName ?? "lastName"
        phoneNumber = User.shared.userMobilePhone ?? "+37653434344"
    }
    func checState() -> Bool {
        return !nameText.isEmpty && !lastName.isEmpty && !phoneNumber.isEmpty
    }
}

enum TextFieldType: CaseIterable {
    case name, lastName, phone
}
