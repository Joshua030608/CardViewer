//
//  CardViewerApp.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/14/23.
//

import SwiftUI

@main
struct CardViewerApp: App {
    @StateObject private var folderStore = FolderStore()
    var body: some Scene {
        WindowGroup {
            ContentView(folderStore: folderStore)
        }
    }
}
