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
    @StateObject private var folderStore: FolderStore
    @EnvironmentObject var navigationModel: NavigationModel
    var body: some View {
        NavigationStack(path: $navigationModel.navigationPath) {
            ZStack {
                Color.red
                    .ignoresSafeArea()
                VStack {
                    //                    Button {
                    //                        navigationModel.navigationPath.append(Views.folderListView)
                    //                    } label: {
                    //                        Text("Add to Path")
                    //                    }
                    
                    Image(systemName: "globe")
                        .resizable()
                        .frame(maxWidth: 100, maxHeight: 100)
                        .imageScale(.large)
                        .font(.largeTitle)
                    Text("CardViewer")
                        .font(.largeTitle)
                    Button {
                        navigationModel.navigationPath.append(Views.folderListView)
                    } label: {
                        Text("Start")
                            .font(.largeTitle)
                            .background(Color.black)
                    }
                    .padding()
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
        self._folderStore = StateObject(wrappedValue: folderStore)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(folderStore: FolderStore())
    }
}
