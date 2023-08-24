//
//  CardAddEditViewModel.swift
//  CardViewer
//
//  Created by Joshua Ford on 4/11/23.
//

import SwiftUI
import PhotosUI

enum CardSide {
    case front
    case back
}


class CardAddEditViewModel: ObservableObject {
    @Published var selectedPhotos: [PhotosPickerItem] = []
    @Published var isShowingPhotoOptions = false
    @Published var isShowingCamera = false
    @Published var isShowingPreviewView = false
    @Published var isShowingAlert = false
    @Published var image1: UIImage?
    @Published var image2: UIImage?
    var folderStore: FolderStore
    let folder: Folder
    @Published var card: Card
    let isEditing: Bool
    
    func retakeHandler() {
        image1 = nil
        image2 = nil
        isShowingCamera = true
        isShowingPreviewView = false
    }
    
    func confirmHandler() {
        isShowingPreviewView = false
    }
    
    fileprivate func getDataFromSelectedPhoto(item: PhotosPickerItem, completion: @escaping (Data) -> ()) {
        
         item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    completion(data)
                } else {
                    print("failed to load")
                }
            case .failure(let failure):
                print("failure \(failure)")
            }
        }
        
    }
    
    func change(newValue: [PhotosPickerItem]) {
            guard let item1 = self.selectedPhotos.first else { return }
            
            self.getDataFromSelectedPhoto(item: item1) { result in
                DispatchQueue.main.async {
                    self.card.frontImageData = result
                }
            }
            
            guard self.selectedPhotos.count >= 2 else { return }
            self.getDataFromSelectedPhoto(item: self.selectedPhotos[1]) { result in
                DispatchQueue.main.async {
                    self.card.backImageData = result
                }
            }
    }
    
    func changeForUIImage(newValue: UIImage?, sideOfCard: CardSide) {
        if let data = newValue?.pngData() {
            DispatchQueue.main.async {
                switch sideOfCard {
                case .front:
                    self.card.frontImageData = data
                case .back:
                    self.card.backImageData = data
                }
            }
        }
    }
    
    func saveCardToFolder() {
        // if id == id of another card, then edit existing card and don't add a new card. Can't do this yet because editing feature is not out.
        
        if let index = folder.cards.firstIndex(where: { card.id == $0.id }) {
            folder.cards[index] = card
        } else {
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
