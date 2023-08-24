//
//  FolderListView.swift
//  CardViewer
//
//  Created by Joshua Ford on 5/23/23.
//

import SwiftUI


struct FolderListView: View {
    
    private enum sortingModes: CaseIterable {
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
        
        var finalArray: [[Folder]] = []
        for _ in League.allCases {
            finalArray.append([])
        }
        print("\(finalArray.count)")
        
        switch sortingMode {
            
        case .league:
            for folder in folderStore.folders {
                switch folder.league {
                case .NFL:
                    finalArray[0].append(folder)
                case .NBA:
                    finalArray[1].append(folder)
                case .MLB:
                    finalArray[2].append(folder)
                case .NHL:
                    finalArray[3].append(folder)
                }
            }
        case .nameAscending:
            finalArray[0] = folderStore.folders.sorted(by: { folder1, folder2 in
                return folder1.name.localizedCaseInsensitiveCompare(folder2.name) == .orderedAscending
            })
            print(finalArray[0].count)
        case .nameDescending:
            finalArray[0] = folderStore.folders.sorted(by: { folder1, folder2 in
                return folder1.name.localizedCaseInsensitiveCompare(folder2.name) == .orderedDescending
            })
        case .cardsAscending:
            finalArray[0] = folderStore.folders.sorted(by: { folder1, folder2 in
                return folder1.cards.count < folder2.cards.count
            })
        case .cardsDescending:
            finalArray[0] = folderStore.folders.sorted(by: { folder1, folder2 in
                return folder1.cards.count > folder2.cards.count
            })
        }
        
        return finalArray
    }
    
    init(folderStore: FolderStore) {
        self.folderStore = folderStore
    }
    
    var body: some View {
        VStack {
            List {
                if sortingMode == .league {
                    ForEach(folders) { foldersOfLeague in
                        if foldersOfLeague.isEmpty != true {
                            Section {
                                Label(foldersOfLeague[0].league.rawValue, systemImage: foldersOfLeague[0].league.getImageName())
                            }
                            ForEach(foldersOfLeague) { folder in
                                Button {
                                    navigationModel.currentFolder = folder
                                    navigationModel.navigationPath.append(Views.folderView)
                                } label: {
                                    FolderListCell(folder: folder)
                                }
                            }.onDelete(perform: folderStore.deleteFolder)
                        }
                    }
                } else {
                    ForEach(folders[0]) { folder in
                        Button {
                            navigationModel.currentFolder = folder
                            navigationModel.navigationPath.append(Views.folderView)
                        } label: {
                            FolderListCell(folder: folder)
                        }
                    }.onDelete(perform: folderStore.deleteFolder)
                }
            }
            .toolbar {
                ToolbarItem {
                    EditButton()
                }
                ToolbarItem(placement: .principal) {
                    Menu {
                        Button {
                            sortingMode = .league
                        } label: {
                            Text("Sort By League")
                        }
                        Button {
                            sortingMode = .cardsDescending
                        } label: {
                            Text("Sort By # Of Cards (Descending)")
                        }
                        Button {
                            sortingMode = .cardsAscending
                        } label: {
                            Text("Sort By # Of Cards (Ascending)")
                        }
                        Button {
                            sortingMode = .nameDescending
                        } label: {
                            Text("Sort By Name (A-Z)")
                        }
                        Button {
                            sortingMode = .nameAscending
                        } label: {
                            Text("Sort By Name (Z-A)")
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
