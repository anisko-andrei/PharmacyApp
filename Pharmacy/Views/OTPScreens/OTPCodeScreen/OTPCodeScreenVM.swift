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
    @Published var showTabBar = false
    @Published var alertIsPresented = false
    @Published var alertBody : AppAlert? {
        didSet {
            self.alertIsPresented.toggle()
        }
    }
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
    
    func verifyAndSend(phone: String) {
        otpText = fields.reduce("", { res, str in
            return res + str
        })
        Task {
            do{
                
                _ = try await AFManager.sendOTPCode(otp: otpText, phone: phone.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: ""))
                await MainActor.run(body: {
                    showTabBar.toggle()
                })
            }
            catch {
                await MainActor.run(body: {
                    alertBody = AppAlert(message: String(localized: "Invalid OTP code"))
                })
            }
        }
    }
    
}
