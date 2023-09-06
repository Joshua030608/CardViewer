//
//  FolderListView.swift
//  CardViewer
//
//  Created by Joshua Ford on 5/23/23.
//

import SwiftUI


struct FolderListView: View {
    
    private enum SortingMode: Int, CaseIterable {
        case league
        case cardsAscending
        case cardsDescending
        case nameAscending
        case nameDescending
        
        var menuTitle: String {
            switch self {
            case .league:
                return "Sort By League"
            case .cardsAscending:
                return "Sort By # Of Cards (Ascending)"
            case .cardsDescending:
                return "Sort By # Of Cards (Descending)"
            case .nameAscending:
                return "Sort By Name (Z-A)"
            case .nameDescending:
                return "Sort By Name (A-Z)"
            }
        }
    }
    
    @EnvironmentObject var navigationModel: NavigationModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ObservedObject var folderStore: FolderStore
    @State private var folderAddEditIsShowing = false
    @State private var newFolderName = ""
    @State private var newFolderLeague: League = .NFL
    @State private var sortingMode: SortingMode = .nameDescending
    @State private var leagueToDeleteFrom: League?
    
    private var folders: [(League, [Folder])] {
        
        var finalArray: [(League, [Folder])] = []
        
        for league in League.allCases {
            finalArray.append((league, []))
        }
        
        print("\(finalArray.count)")
        
        switch sortingMode {
            
        case .league:
            for folder in folderStore.folders {
                finalArray[folder.league.rawValue].1.append(folder)
            }
        case .nameAscending:
            finalArray[0].1 = folderStore.folders.sorted(by: { folder1, folder2 in
                folder1.name.localizedCaseInsensitiveCompare(folder2.name) == .orderedDescending
            })
        case .nameDescending:
            finalArray[0].1 = folderStore.folders.sorted(by: { folder1, folder2 in
                folder1.name.localizedCaseInsensitiveCompare(folder2.name) == .orderedAscending
            })
        case .cardsAscending:
            finalArray[0].1 = folderStore.folders.sorted(by: { folder1, folder2 in
                folder1.cards.count < folder2.cards.count
            })
        case .cardsDescending:
            finalArray[0].1 = folderStore.folders.sorted(by: { folder1, folder2 in
                folder1.cards.count > folder2.cards.count
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
                    ForEach(folders, id: \.0) { foldersOfLeague in
                        if foldersOfLeague.1.isEmpty != true {
                            Section {
                                ForEach(foldersOfLeague.1) { folder in
                                    Button {
                                        navigationModel.currentFolder = folder
                                        navigationModel.navigationPath.append(Views.folderView)
                                    } label: {
                                        FolderListCell(folder: folder)
                                    }
                                }.onDelete { indexSet in
                                    leagueToDeleteFrom = foldersOfLeague.0
                                    deleteFoldersForLeagueSorting(indexSet: indexSet)
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
    
    func deleteFoldersNonLeagueSorting(indexSet: IndexSet) {
        let folders = folders[0].1
        let finalIds = indexSet.map { folders[$0].id }
        folderStore.deleteFolders(for: finalIds)
    }
    
    func deleteFoldersForLeagueSorting(indexSet: IndexSet) {
        let folders = folders
        
        for foldersOfLeague in folders {
            if foldersOfLeague.0 == leagueToDeleteFrom {
                let finalIds = indexSet.map{ foldersOfLeague.1[$0].id }
                folderStore.deleteFolders(for: finalIds)
                return
            }
        }
    }
}
