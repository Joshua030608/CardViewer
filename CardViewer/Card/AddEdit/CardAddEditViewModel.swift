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
    let folderStore: FolderStore
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
                DispatchQueue.main.sync {
                    print("setting front")
                    self.card.frontImageData = result
                }
            }
            
            guard self.selectedPhotos.count >= 2 else { return }
            self.getDataFromSelectedPhoto(item: self.selectedPhotos[1]) { result in
                DispatchQueue.main.sync {
                    print("setting back")
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
    
    func saveCardToFolder(completion: @escaping (Card) -> Void) {
        
        if let index = folder.cards.firstIndex(where: { card.id == $0.id }) {
            folder.cards[index] = card
            completion(card)
        } else {
            folder.cards.append(self.card)
            print(card.frontImageData)
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
            self.card = Card(playerName: nil, team: nil, frontImageData: nil, backImageData: nil, position: nil, grade: nil)
        }
    }
}
