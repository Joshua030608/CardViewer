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
                switch folder.league {
                case .NFL:
                    finalArray[0].1.append(folder)
                case .NBA:
                    finalArray[1].1.append(folder)
                case .MLB:
                    finalArray[2].1.append(folder)
                case .NHL:
                    finalArray[3].1.append(folder)
                }
            }
        case .nameAscending:
            finalArray[0].1 = folderStore.folders.sorted(by: { folder1, folder2 in
                return folder1.name.localizedCaseInsensitiveCompare(folder2.name) == .orderedDescending
            })
        case .nameDescending:
            finalArray[0].1 = folderStore.folders.sorted(by: { folder1, folder2 in
                return folder1.name.localizedCaseInsensitiveCompare(folder2.name) == .orderedAscending
            })
        case .cardsAscending:
            finalArray[0].1 = folderStore.folders.sorted(by: { folder1, folder2 in
                return folder1.cards.count < folder2.cards.count
            })
        case .cardsDescending:
            finalArray[0].1 = folderStore.folders.sorted(by: { folder1, folder2 in
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
                                    deleteFolder(indexSet: indexSet)
                                }
                            } header: {
                                Label(foldersOfLeague.0.rawValue, systemImage: foldersOfLeague.0.getImageName())
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
                    }.onDelete { indexSet in
                        //nothing
                    }
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
    
    func deleteFolder(indexSet: IndexSet) {
        let folders1 = folders
        for folder in folders1 {
            if folder.0 == leagueToDeleteFrom {
                folderStore.deleteFolders(for: [])
            } else {
                break
            }
        }
    }
}
