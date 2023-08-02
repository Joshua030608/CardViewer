//
//  CardViewerApp.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/14/23.
//

import SwiftUI

class NavigationModel: ObservableObject {
    @Published var navigationPath = NavigationPath()
}

@main
struct CardViewerApp: App {
    @StateObject private var folderStore = FolderStore()
    @StateObject var navigationModel = NavigationModel()
    var body: some Scene {
        WindowGroup {
            ContentView(folderStore: folderStore)
                .environmentObject(folderStore)
                .environmentObject(navigationModel)
        }
    }
}
