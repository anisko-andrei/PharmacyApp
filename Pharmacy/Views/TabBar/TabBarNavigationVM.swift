//
//  TabBarNavigationVM.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 20.06.23.
//

import Foundation
import RealmSwift

class TabBarNavigationVM : ObservableObject {
    @Published var tabSelected: Tab = .house
    @Published var isLogOut = false
    @Published var countInCart = 0
   
    var notificationToken: NotificationToken?
    var realmManager: RealmManagerProtocol = RealmManager()

    
        
    func startObserv() {
       
        guard let realm = realmManager.realm else {return}
        notificationToken = realm.observe({ notification, realm in
            self.countInCart = realm.objects(CartItem.self).compactMap{$0}.count
            
                
        })
        
    }
    deinit {
        notificationToken?.invalidate()
    }
    init() {
        guard let realm = realmManager.realm else {return}
        self.countInCart = realm.objects(CartItem.self).compactMap{$0}.count
        startObserv()
    }
}
