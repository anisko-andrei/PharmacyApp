//
//  OTPCodeScreenVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 11.06.23.
//

import Foundation

final class OTPCodeScreenVM: ObservableObject {
    let otpLength: Int = 6
    @Published var otpText: String = ""
    @Published var fields: [String] = []
    
    let AFManager: AlamofireManagerProtocol = AlamofireManager()
    
    init() {
        fields = Array(repeating: "", count: self.otpLength)
    }
    
    func checkState() -> Bool {
        for index in 0 ..< otpLength {
            if fields[index].isEmpty {
                return true
            }
        }
        return false
    }
    
    func verify() {
        otpText = fields.reduce("", { res, str in
            return res + str
        })
        print("OTP \(otpText)")
    }
    
}
