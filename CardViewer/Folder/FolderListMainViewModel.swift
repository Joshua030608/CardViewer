//
//  FolderListMainViewModel.swift
//  CardViewer
//
//  Created by Joshua Ford on 9/14/23.
//

import Foundation

@Observable class FolderListMainViewModel {
    
    internal init(navigationModel: NavigationModel, folderStore: FolderStore) {
        self.navigationModel = navigationModel
        self.folderStore = folderStore
    }
    
    let navigationModel: NavigationModel
    let folderStore: FolderStore
    
    enum SortingMode: Int, CaseIterable {
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
    
    private var newFolderName = ""
    private var newFolderLeague: League = .NFL
    var folderAddEditIsShowing = false
    var sortingMode: SortingMode = .nameDescending
    var leagueToDeleteFrom: League?
    
    var folders: [(League, [Folder])] {
        
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
