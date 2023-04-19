//
//  FolderStore.swift
//  CardViewer
//
//  Created by Joshua Ford on 4/11/23.
//

import Foundation

struct FolderStore {
    var folders: [Folder]
    private static let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(component: "folders.txt")
    
    func saveFolders() {
        do {
            let data = try JSONEncoder().encode(folders)
            try data.write(to: Self.fileUrl)
        } catch {
            print(error,error.localizedDescription)
        }
    }
    
    private static func loadFolders() -> [Folder] {
        do {
            let data = try Data(contentsOf: fileUrl)
            return try JSONDecoder().decode([Folder].self, from: data)
        } catch {
            print(error,error.localizedDescription)
            return []
        }
    }
    
    init() {
        self.folders = FolderStore.loadFolders()
    }
}
