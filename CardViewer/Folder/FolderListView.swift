//
//  FolderListView.swift
//  CardViewer
//
//  Created by Joshua Ford on 5/23/23.
//

import SwiftUI


struct FolderListView: View {
    
    private enum sortingModes {
        case league
        case cardsAscending
        case cardsDescending
        case nameAscending
        case nameDescending
    }
    
    @EnvironmentObject var navigationModel: NavigationModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ObservedObject var folderStore: FolderStore
    @State private var folderAddEditIsShowing = false
    @State private var newFolderName = ""
    @State private var newFolderLeague: League = .NFL
    @State private var sortingMode: sortingModes = .nameDescending
    
    private var folders: [[Folder]] {
        
        switch sortingMode {
        case .league:
            for folder in folderStore.folders {
                
            }
        case .cardsAscending:
            <#code#>
        case .cardsDescending:
            <#code#>
        case .nameAscending:
            <#code#>
        case .nameDescending:
            <#code#>
        }
    }
    
    init(folderStore: FolderStore) {
        self.folderStore = folderStore
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(folders) { folder in
                    Button {
                        navigationModel.currentFolder = folder
                        navigationModel.navigationPath.append(Views.folderView)
                    } label: {
                        FolderListCell(folder: folder)
                    }

                }
                .onDelete(perform: folderStore.deleteFolder)
            }
            .toolbar {
                ToolbarItem {
                    EditButton()
                }
                ToolbarItem(placement: .principal) {
                    Menu {
                        Label("Most Cards To Least Cards", systemImage: "xbox.logo")
                        Button {
                            sortFoldersByLeague()
                        } label: {
                            Text("Sort By League")
                        }

                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
            Button {
                folderAddEditIsShowing = true
            } label: {
                Text("Add Folder")
                    .font(.largeTitle)
            }
        }
        .sheet(isPresented: $folderAddEditIsShowing, content: {
            AddEditFolderSheetView(folderStore: folderStore)
        })
    }
}
