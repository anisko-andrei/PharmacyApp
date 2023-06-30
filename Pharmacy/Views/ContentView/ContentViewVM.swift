//
//  ContentViewVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 11.06.23.
//

import Foundation
import KeychainSwift

enum AuthState{
    case loading, logged, unlogged
}


final class ContentViewVM: ObservableObject {
    var keychain = KeychainSwift()
    var AFManager: AlamofireManagerProtocol = AlamofireManager()
    @Published var authState: AuthState = .loading
    
    func checkAuth() {
        guard let token = keychain.get("userToken"),
              !token.isEmpty
        else {
            authState = .unlogged
            return
        }
        Task {
            do {
                let user = try await AFManager.loginWithToken(token: token)
                 await User.shared.writeUserData(userName: user.firstName, userLastName: user.lastName, userMobilePhone: user.phoneNumber)
                await MainActor.run(body: {
                    authState = .logged
                })
            }
            catch {
                await MainActor.run(body: {
                    authState = .unlogged
                })
            }
        }
        
        
    }
}
