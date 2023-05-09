//
//  CardAddEditViewModel.swift
//  CardViewer
//
//  Created by Joshua Ford on 4/11/23.
//

import SwiftUI
import PhotosUI


class CardAddEditViewModel: ObservableObject {
    @Published var nameString: String = ""
    @Published var posititionString: String = ""
    @Published var teamString: String = ""
    @Published var grade: Int = 0
    @Published var selectedPhotos: [PhotosPickerItem] = []
    @Published var frontData: Data?
    @Published var backData: Data?
    @Published var isShowingPhotoOptions = false
    @Published var isShowingCamera = false
    @Published var image = UIImage()
    var folderStore: FolderStore
    let folder: Folder
    
    func change(newValue: [PhotosPickerItem]) {
        guard let item = self.selectedPhotos.first else {
            return
        }
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    DispatchQueue.main.async {
                        self.frontData = data
                    }
                } else {
                    print("failed to load")
                }
            case .failure(let failure):
                print("failure \(failure)")
            }
        }
    }
    
    func changeForUIImage(newValue: UIImage) {
        if let data = newValue.pngData() {
            DispatchQueue.main.async {
                self.frontData = data
            }
        }
    }
    
    func saveCardToFolder() {
        // if id == id of another card, then edit existing card and don't add a new card. Can't do this yet because editing feature is not out.
        let card = Card(playerName: nameString, team: teamString, frontImageName: frontData, backImageName: backData, position: posititionString)
        #warning("need to update change funcs to use back data, also add ability to pick folder.")
        print(card.frontImageName != nil ? "data exists" : "data is nil")
        folder.cards.append(card)
        folderStore.saveFolders()
    }
    
    init(folderStore: FolderStore, folder: Folder) {
        self.folderStore = folderStore
        self.folder = folder
    }
}
