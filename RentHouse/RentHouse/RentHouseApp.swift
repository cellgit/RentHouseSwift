//
//  RentHouseApp.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/27.
//

import SwiftUI

@main
struct RentHouseApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
