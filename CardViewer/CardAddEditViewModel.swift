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
    @Published var data: Data?
    
    func change(newValue: [PhotosPickerItem]) {
        guard let item = self.selectedPhotos.first else {
            return
        }
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    DispatchQueue.main.async {
                        self.data = data
                    }
                } else {
                    print("failed to load")
                }
            case .failure(let failure):
                fatalError("\(failure)")
            }
        }
    }
    
    func changeForUIImage(newValue: UIImage) {
        if let data = newValue.pngData() {
            self.data = data
        }
    }
}
