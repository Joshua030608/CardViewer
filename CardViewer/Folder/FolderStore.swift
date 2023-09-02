//
//  FolderStore.swift
//  CardViewer
//
//  Created by Joshua Ford on 4/11/23.
//

import Foundation

class FolderStore: ObservableObject {
    @Published var folders: Array<Folder>
    private static let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(component: "folders.txt")
    
    func deleteFoldersOld(indices: IndexSet) {
        Array<Int>(indices).reversed().forEach { folders.remove(at: $0) }
        self.saveFolders()
    }
    
    func deleteFolders(for ids: [Folder.ID]) {
        
    }
    
    func save(folder: Folder) {
        for (index, folder1) in folders.enumerated() {
            if folder1.id == folder.id {
                //overwrite previous folder
                folders[index] = folder
                self.saveFolders()
                return
            }
        }
        folders.append(folder)
        self.saveFolders()
    }
    
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
