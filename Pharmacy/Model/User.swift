//
//  User.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 26.06.23.
//

import Foundation

class User: ObservableObject {
    static let shared = User()
    
    @Published  var username: String?
    @Published var userLastName : String?
    @Published  var userMobilePhone : String?
    
    var userNamePlusLastName : String {
        "\(username ?? "") \(userLastName ?? "")"
    }
    
    private init() { }
 
    func writeUserData(userName: String?, userLastName: String?, userMobilePhone: String?) async {
        await MainActor.run {
            self.userLastName = userLastName
            self.userMobilePhone = userMobilePhone
            self.username = userName
        }
    }
}
