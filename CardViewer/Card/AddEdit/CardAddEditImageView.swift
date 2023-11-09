//
//  CardAddEditImageView.swift
//  CardViewer
//
//  Created by Joshua Ford on 8/8/23.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct CardAddEditImageView: View {
    
    @StateObject private var model: CardAddEditImageViewModel
    
    init(frontData: Data?, backData: Data?) {
        self._model = StateObject(wrappedValue: CardAddEditImageViewModel(frontData: frontData, backData: backData))
    }
    
    var body: some View {
        List {
            ForEach(model.images) { image in
                Image(uiImage: image.image)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .center)
            }.onMove(perform: { indices, newOffset in
                print(model.images.map(\.id))
                model.images.move(fromOffsets: indices, toOffset: newOffset)
                print(model.images.map(\.id))
            })
        }
//        LazyVStack(spacing: 15) {
//            ForEach(model.images) { image in
//                Image(uiImage: image.image)
//                    .resizable()
//                    .previewInterfaceOrientation(.portrait)
//
//                    .onDrag({
//                        model.draggedItem = image
//                        return NSItemProvider(item: nil, typeIdentifier: UTType.image.description)
//                    })
//                    .frame(width: 150, height: 150)
//                    .onDrop(of: [UTType.image], delegate: MyDropDelegate(item: image, items: $model.images, draggedItem: $model.draggedItem))
//            }
//        }
    }
}
