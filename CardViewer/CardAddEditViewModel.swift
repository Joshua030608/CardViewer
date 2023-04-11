//
//  CardAddEditViewModel.swift
//  CardViewer
//
//  Created by Joshua Ford on 4/11/23.
//

import SwiftUI
import PhotosUI

final class CardAddEditViewModel: ObservableObject {
    @Published var nameString: String = ""
    @Published var posititionString: String = ""
    @Published var teamString: String = ""
    @Published var grade: Int = 0
    @Published var selectedPhotos: [PhotosPickerItem] = []
    @Published var data: Data?
    
    func change() {
        guard let item = self.selectedPhotos.first else {
            return
        }
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    self.data = data
                } else {
                    print("failed to load")
                }
            case .failure(let failure):
                fatalError("\(failure)")
            }
        }
    }
}
