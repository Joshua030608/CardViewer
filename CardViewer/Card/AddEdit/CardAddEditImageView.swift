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
    
    @State private var frontData: Data?
    @State private var backData: Data?
    //@StateObject var draggedItem: IDImage?
    
    @State var images: [IDImage] = []
    
    init(frontData: Data?, backData: Data?) {
        self._frontData = State(initialValue: frontData)
        self._backData = State(initialValue: backData)
        
        var images1: [IDImage] = []
        
        if let data = frontData, let uiImage = UIImage(data: data) {
            let idImage = IDImage(image: uiImage)
            images1.append(idImage)
        }
        
        if let backData = backData, let backuiImage = UIImage(data: backData) {
            let backIDImage = IDImage(image: backuiImage)
            images1.append(backIDImage)
        }
        
        self._images = State(initialValue: images1)
//        print(#function + "\(images1.count) images")
//        print(#function + "\(self.images.count) images")
        print(#function + "front: \((frontData?.count ?? 0)/1_000_000) back: \((backData?.count ?? 0)/1_000_000)")
    }
    
    var body: some View {
        /*List {
            ForEach(0..<images.count, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(10)
            }.onMove(perform: move)
        }*/
        LazyVStack(spacing: 15) {
            ForEach(images) { image in
                Image(uiImage: image.image)
                    .resizable()
                    /*.onDrag({
                        self.draggedItem = image
                        return NSItemProvider(item: nil, typeIdentifier: UTType.image.description)
                    })*/
                    .frame(width: 150, height: 150)
                    //.onDrop(of: [UTType.image], delegate: MyDropDelegate(item: image, items: $images, draggedItem: $draggedItem))
            }
        }
    }
}
