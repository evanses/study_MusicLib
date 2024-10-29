//
//  ArtistLibApp.swift
//  ArtistLib
//
//  Created by eva on 29.10.2024.
//

import SwiftUI

@main
struct ArtistLibApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
