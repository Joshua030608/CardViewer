//
//  FolderListMainView.swift
//  CardViewer
//
//  Created by Joshua Ford on 9/14/23.
//

import SwiftUI
struct FolderListMainView: View {
    
    @State private var viewModel: FolderListMainViewModel
    
    var body: some View {
        VStack {
            List {
                if viewModel.sortingMode == .league {
                    ForEach(viewModel.folders, id: \.0) { foldersOfLeague in
                        if foldersOfLeague.1.isEmpty != true {
                            Section {
                                ForEach(foldersOfLeague.1) { folder in
                                    Button {
                                        viewModel.navigationModel.currentFolder = folder
                                        viewModel.navigationModel.navigationPath.append(Views.folderView)
                                    } label: {
                                        FolderListCell(folder: folder)
                                    }
                                }.onDelete { indexSet in
                                    viewModel.leagueToDeleteFrom = foldersOfLeague.0
                                    viewModel.deleteFoldersForLeagueSorting(indexSet: indexSet)
                                }
                            } header: {
                                Label(foldersOfLeague.0.title, systemImage: foldersOfLeague.0.getImageName())
                            }
                        }
                    }
                } else {
                    ForEach(folders[0].1) { folder in
                        Button {
                            navigationModel.currentFolder = folder
                            navigationModel.navigationPath.append(Views.folderView)
                        } label: {
                            FolderListCell(folder: folder)
                        }
                    }.onDelete(perform: deleteFoldersNonLeagueSorting)
                }
            }
            .toolbar {
                ToolbarItem {
                    EditButton()
                }
                ToolbarItem(placement: .principal) {
                    Menu {
                        ForEach(SortingMode.allCases, id: \.rawValue) { mode in
                            Button(mode.menuTitle, action: { sortingMode = mode })
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
