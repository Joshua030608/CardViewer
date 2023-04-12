//
//  FolderStore.swift
//  CardViewer
//
//  Created by Joshua Ford on 4/11/23.
//

import Foundation

struct FolderStore {
    var folders: [Folder]
    
    func saveFolders() {
        
    }
    
    private static func loadFolders() -> [Folder] {
        return [
            Folder(
                name: "Dummy",
                cards: [
                    Card(playerName: "Jalen Hurts", team: "Eagles", imageName: "jalenHurts", position: "QB"),
                    Card(playerName: "A.J. Brown", team: "Eagles", imageName: "ajBrown", position: "WR"),
                    Card(playerName: "Boston Scott", team: "Eagles", imageName: "bostonScott", position: "RB")
                ],
                league: .NFL
            )
        ]
    }
    
    init() {
        self.folders = FolderStore.loadFolders()
    }
}
