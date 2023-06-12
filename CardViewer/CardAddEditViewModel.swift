//
//  CardAddEditViewModel.swift
//  CardViewer
//
//  Created by Joshua Ford on 4/11/23.
//

import SwiftUI
import PhotosUI


class CardAddEditViewModel: ObservableObject {
    @Published var selectedPhotos: [PhotosPickerItem] = []
    @Published var isShowingPhotoOptions = false
    @Published var isShowingCamera = false
    @Published var image = UIImage()
    var folderStore: FolderStore
    let folder: Folder
    @Published var card: Card
    let isEditing: Bool
    
    fileprivate func getDataFromSelectedPhoto(item: PhotosPickerItem) -> Data {
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    return data
                } else {
                    print("failed to load")
                }
            case .failure(let failure):
                print("failure \(failure)")
            }
        }
    }
    
    func change(newValue: [PhotosPickerItem]) {
        DispatchQueue.main.async {
            guard let item1 = self.selectedPhotos.first else { return }
            self.card.frontImageData = getDataFromSelectedPhoto(item: item1)
            
            guard self.selectedPhotos.count >= 2 else { return }
            self.card.backImageData = getDataFromSelectedPhoto(item: self.selectedPhotos[1])
        }
    }
    
    func changeForUIImage(newValue: UIImage) {
        if let data = newValue.pngData() {
            DispatchQueue.main.async {
                self.card.frontImageData = data
                self.card.backImageData
            }
        }
    }
    
    func saveCardToFolder() {
        // if id == id of another card, then edit existing card and don't add a new card. Can't do this yet because editing feature is not out.
        
        if let index = folder.cards.firstIndex(where: { card.id == $0.id }) {
            folder.cards[index] = card
        } else {
            #warning("need to update change funcs to use back data")
            folder.cards.append(self.card)
        }
            folderStore.saveFolders()
    }
    
    init(folderStore: FolderStore, folder: Folder, card: Card?) {
        self.folderStore = folderStore
        self.folder = folder
        
        if let card = card {
            self.isEditing = true
            self.card = card
        } else {
            self.isEditing = false
            self.card = Card(playerName: "Name", team: "Team", frontImageData: nil, backImageData: nil, position: "Position", grade: 0)
        }
    }
}
