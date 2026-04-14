//
//  ListTestApp.swift
//  ListTest
//
//  Created by Cristian Palage on 3/21/26.
//

import SwiftUI
import SwiftData

@main
struct ListTestApp: App {
    let sharedModelContainer: ModelContainer

    init() {
        let schema = Schema([ListItem.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            sharedModelContainer = container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
    }
}
