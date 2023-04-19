//
//  CardAddEditView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/31/23.
//

import SwiftUI
import PhotosUI

struct CardAddEditView: View {
    @StateObject private var model = CardAddEditViewModel()
    @State private var showSheet1 = false
    @State private var showSheet2 = false
    @State private var image = UIImage()
    
    var body: some View {
        VStack {
            Form {
                if let data = model.data, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 100, height: 100)
                } else {
                    //                    PhotosPicker(
                    //                        selection: $model.selectedPhotos,
                    //                        maxSelectionCount: 5,
                    //                        matching: .images) {
                    //                            VStack {
                    //                                Image(systemName: "plus.circle.fill")
                    //                                    .resizable()
                    //                                    .frame(width: 100, height: 100)
                    //                                Text("Add Image(s)")
                    //                                    .font(.largeTitle)
                    //                                    .frame(width: 197)
                    //                            }
                    //                        }.padding(100)
                    Button {
                        showSheet1 = true
                    } label: {
                        VStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("Add Image(s)")
                                .font(.largeTitle)
                                .frame(width: 197)
                        }
                    }.padding(100)
                }
                //Spacer(): doesn't do anything cuz of form
                //: Tried using form with image inside but didn't look correct
                TextField("Name", text: $model.nameString)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .textFieldStyle(.roundedBorder)
                TextField("Team", text: $model.teamString)
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .textFieldStyle(.roundedBorder)
                TextField("Position", text: $model.posititionString)
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .textFieldStyle(.roundedBorder)
                HStack {
                    Text("Grade:")
                        .font(.title2)
                    Picker(
                        selection: $model.grade,
                        label: Text("")) {
                            ForEach(0..<11) { number in
                                Text("\(number)")
                                    .tag(number)
                            }
                        }
                }
            }
        }
        .onChange(of: image, perform: { newValue in
            model.changeForUIImage(newValue: newValue)
            showSheet1 = false
            showSheet2 = false
        })
        .onChange(of: model.selectedPhotos, perform: { newValue in
            model.change(newValue: newValue)
            showSheet1 = false
            showSheet2 = false
        })
        .sheet(isPresented: $showSheet1) {
            VStack {
                PhotosPicker(
                    selection: $model.selectedPhotos,
                    maxSelectionCount: 5,
                    matching: .images) {
                        VStack {
                            Image(systemName: "photo.fill.on.rectangle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("Select Image(s)")
                                .font(.largeTitle)
                                .frame(width: 197)
                        }
                    }.padding(75)
                Button {
                    //go to camera
                    print("camera button pressed")
                    showSheet1 = false
                    showSheet2 = true
                } label: {
                        VStack {
                            Image(systemName: "camera.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.blue)
                                .aspectRatio(contentMode: .fit)
                            Text("Take Photo(s)")
                                .foregroundColor(.blue)
                                .font(.largeTitle)
                                .frame(width: 197)
                        }
                }
            }
        }
        .sheet(isPresented: $showSheet2) {
            ImagePicker(selectedImage: self.$image)
        }
    }
}

struct CardAddEditView_Previews: PreviewProvider {
    static var previews: some View {
        CardAddEditView()
    }
}
