//
//  OTPMobileNumberScreenVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 11.06.23.
//

import Foundation
import Alamofire

final class OTPMobileNumberScreenVM: ObservableObject {
    
    @Published var mobileNumberText = "+375"
    @Published var flagIsHidden = true
    @Published var alertIsPresented = false
    @Published var alertMessage = ""
    @Published var showCodeScreen = false
    @Published var alertBody : AppAlert? {
        didSet {
            self.alertIsPresented.toggle()
        }
    }
    
    func sendPhone(phone: String) async throws -> Msg {
        try await withCheckedThrowingContinuation { continuation in
            AF.request("http://localhost:3000/api/v1/auth/phoneNumber/login", method: .post, parameters: ["phoneNumber": phone],encoding: JSONEncoding.default).responseDecodable(of: Msg.self, completionHandler:  { result in
                switch result.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            })
        }
    }
        
    
    
    func getOTPCode() {
        let mobile =  mobileNumberText.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
        if mobile.count == 13 {
            print(mobile)
            
            Task{
                do{
                let sendOTPStatus = try await sendPhone(phone: mobile)
                    print(sendOTPStatus)
                    await MainActor.run(body: {
                        showCodeScreen.toggle()
                    })
                }
                catch {
                    await MainActor.run(body: {
                        alertBody = AppAlert(message: String(localized: "no register"))
                    })
                }
            }
        }
        else {
            alertBody = AppAlert(message: String(localized: "Invalid phone number"))
        }
    }
}

struct AppAlert : Identifiable {
    var id: String {message}
    var message: String
}


// MARK: - Welcome
struct Welcome: Decodable {
    let customer: Customer
}

// MARK: - Customer
struct Customer: Decodable {
    let firstName, lastName: String
}

struct Msg: Decodable {
    let message: String
}
