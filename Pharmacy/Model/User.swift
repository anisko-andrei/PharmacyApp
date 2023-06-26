//
//  User.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 26.06.23.
//

import Foundation

class User {
    static let shared = User()
    
    var username: String?
    var userLastName : String?
    var userMobilePhone : String?
    
    private init() { }
 
   func writeUserData(userName: String?, userLastName: String?, userMobilePhone: String?) {
        self.userLastName = userLastName
        self.userMobilePhone = userMobilePhone
        self.username = userName
    }
}
