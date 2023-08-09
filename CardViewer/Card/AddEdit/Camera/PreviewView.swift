//
//  PreviewView.swift
//  CardViewer
//
//  Created by Joshua Ford on 7/10/23.
//

import SwiftUI

struct PreviewView: View {
    
    private var image1: UIImage
    private var image2: UIImage
    private var retakeHandler: () -> Void
    private var confirmHandler: () -> Void
    
    init(frontImage: UIImage, backImage: UIImage, retakeHandler: @escaping () -> Void, confirmHandler: @escaping () -> Void) {
        self.image1 = frontImage
        self.image2 = backImage
        self.retakeHandler = retakeHandler
        self.confirmHandler = confirmHandler
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(uiImage: image1)
                    .resizable()
                    .frame(width: 150, height: 300)
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                Image(uiImage: image2)
                    .resizable()
                    .frame(width: 150, height: 300)
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
            }
            Button(action: retakeHandler) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.blue)
                        .frame(width: 150, height: 50)
                    Text("Retake")
                        .foregroundColor(.white)
                        .font(.title)
                }
            }.padding(15)
            
            Button(action: confirmHandler) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.blue)
                        .frame(width: 150, height: 50)
                    Text("Confirm")
                        .foregroundColor(.white)
                        .font(.title)
                }
            }.padding(15)
        }
    }
}
