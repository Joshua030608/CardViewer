//
//  CustomCameraView.swift
//  CardViewer
//
//  Created by Joshua Ford on 6/20/23.
//

import SwiftUI

struct CustomCameraView: View {
    
    @StateObject var cameraService = CameraService()
    @Binding var capturedImage1: UIImage?
    @Binding var capturedImage2: UIImage?

    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ZStack {
            CameraView(cameraService: cameraService) { result in
                switch result {
                case .success(let photo):
                    if let data = photo.fileDataRepresentation() {
                        if capturedImage1 == nil {
                            capturedImage1 = UIImage(data: data) ?? UIImage()
                        } else {
                            capturedImage2 = UIImage(data: data) ?? UIImage()
                        }
                    } else {
                        print("Error: no image data found")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            VStack {
                Spacer()
                HStack {
                    if let image = capturedImage1 {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(15)
                    }
                    Spacer()
                    Button {
                        cameraService.capturePhoto()
                        //presentationMode
                    } label: {
                        Image(systemName: "circle")
                            .font(.system(size: 72))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    if let _ = capturedImage1 {
                        Color.clear
                            .frame(width: 50, height: 50)
                            .padding(15)
                    }
                }
                .padding(.bottom)
            }
        }
    }
}
