//
//  IDImage.swift
//  CardViewer
//
//  Created by Joshua Ford on 8/8/23.
//

import Foundation
import SwiftUI

class IDImage: Identifiable, Equatable, ObservableObject {
    static func == (lhs: IDImage, rhs: IDImage) -> Bool {
        return lhs.image == rhs.image && lhs.id == rhs.id
    }
    
    @Published var image: UIImage
    @Published var id: UUID
    
    init(image: UIImage, id: UUID = UUID()) {
        self.image = image
        self.id = id
    }
}
