//
//  CardAddEditImageViewModel.swift
//  CardViewer
//
//  Created by Joshua Ford on 11/8/23.
//

import Foundation
import Combine
import UIKit

class CardAddEditImageViewModel: ObservableObject {
    @Published var frontData: Data?
    @Published var backData: Data?
    @Published var draggedItem: IDImage?
    
    @Published var images: [IDImage] = []
    
    init(frontData: Data?, backData: Data?) {
        self.frontData = frontData
        self.backData = backData
        
        var images1: [IDImage] = []
        
        if let data = frontData, let uiImage = UIImage(data: data) {
            let idImage = IDImage(image: uiImage)
            images1.append(idImage)
        }
        
        if let backData = backData, let backuiImage = UIImage(data: backData) {
            let backIDImage = IDImage(image: backuiImage)
            images1.append(backIDImage)
        }
        
        self.images = images1
    }
}
