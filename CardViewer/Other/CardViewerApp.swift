//
//  CardViewerApp.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/14/23.
//

import SwiftUI

class NavigationModel: ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var currentFolder: Folder?
    @Published var currentCard: Card?
    @Published var scannerViewIsIn = false
}

@main
struct CardViewerApp: App {
    
    @StateObject private var folderStore = FolderStore()
    @StateObject var navigationModel = NavigationModel()
    @State var namesCache = NamesCache(source: NetworkService.shared)
    var body: some Scene {
        WindowGroup {
            ContentView(folderStore: folderStore)
                .environmentObject(folderStore)
                .environmentObject(navigationModel)
                .environment(namesCache)
        }
    }
}
