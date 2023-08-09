//
//  CardImageDragDropDelegate.swift
//  CardViewer
//
//  Created by Joshua Ford on 8/8/23.
//

import Foundation
import SwiftUI

struct MyDropDelegate: DropDelegate {
    let item: IDImage
    @Binding var items: [IDImage]
    @Binding var draggedItem: IDImage?
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem = self.draggedItem else {
            return
        }
        
        if draggedItem != item {
            let from = items.firstIndex(of: draggedItem)!
            let to = items.firstIndex(of: item)!
            withAnimation(.default) {
                self.items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
            }
        }
    }
}
