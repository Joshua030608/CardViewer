//
//  ContentView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/14/23.
//

import SwiftUI

enum Views: String {
    case contentView = "ContentView"
    case folderListView = "FolderListView"
    case folderView = "FolderView"
    case scannerView = "ScannerView"
    case cardAddEditView = "CardAddEditView"
    case cardInfoView = "CardInfoView"
}

struct ContentView: View {
    @ObservedObject private var folderStore: FolderStore
    @EnvironmentObject var navigationModel: NavigationModel
    var body: some View {
        NavigationStack(path: $navigationModel.navigationPath) {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    Image(systemName: "lanyardcard")
                        .resizable()
                        .frame(maxWidth: 100, maxHeight: 150)
                        .imageScale(.large)
                        .font(.largeTitle)
                        .foregroundStyle(.orange)
                    Text("CardViewer")
                        .font(.custom("San Francisco", size: 50))
                        .foregroundStyle(.orange)
                    Button {
                        navigationModel.navigationPath.append(Views.folderListView)
                    } label: {
                            Text("START")
                                .font(.largeTitle)
                                .foregroundStyle(.green)
                    }
                    .padding(30)
                }
            }.navigationDestination(for: Views.self) { viewsCase in
                switch viewsCase {
                case .contentView:
                    ContentView(folderStore: folderStore)
                case .folderListView:
                    FolderListView(navigationModel: navigationModel, folderStore: folderStore)
                case .folderView:
                    FolderView(folderStore: folderStore, folder: navigationModel.currentFolder!)
                case .scannerView:
                    ScannerView()
                case .cardAddEditView:
                    CardAddEditView(folderStore: folderStore, folder: navigationModel.currentFolder!, card: navigationModel.currentCard)
                case .cardInfoView:
                    CardInfoView(card: navigationModel.currentCard!, navigationModel: navigationModel)
                }
            }
        }
    }
    init(folderStore: FolderStore) {
        self.folderStore = folderStore
    }
}
