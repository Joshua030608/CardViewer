//
//  FolderListView.swift
//  CardViewer
//
//  Created by Joshua Ford on 5/23/23.
//

import SwiftUI


struct FolderListView: View {
    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var folderStore: FolderStore
    
    @StateObject private var viewModel = FolderListMainViewModel(navigationModel: navigationModel, folderStore: folderStore)
    
    @AppStorage("hasAddedAFolder") var hasAddedAFolder: Bool = false
    
    init(navigationModel: NavigationModel, folderStore: FolderStore) {
        self.navigationModel = navigationModel
        self.folderStore = folderStore
    }
    
    var body: some View {
        
        if hasAddedAFolder == false {
            ZStack {
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
                Text("test")
            }
        }
    }
}
