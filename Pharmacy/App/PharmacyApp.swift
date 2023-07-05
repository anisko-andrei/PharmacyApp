//
//  PharmacyApp.swift
//  Pharmacy
//
//  Created by Андрей Аниськович on 11.06.23.
//

import SwiftUI

@main
struct PharmacyApp: App {
    var body: some Scene {
        WindowGroup {
          
                
                ContentView()
                    .environmentObject(ContentViewVM())
               //TabBarNavigationView()
            
        }
    }
}
