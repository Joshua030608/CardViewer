//
//  CardAddEditView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/31/23.
//

import SwiftUI
import PhotosUI

struct CardAddEditView: View {
    let folderStore: FolderStore
    
    @StateObject private var model: CardAddEditViewModel
    @State private var moveBackToCollection = false
    
    init(folderStore: FolderStore, folder: Folder, card: Card?) {
        self.folderStore = folderStore
        let viewModel = CardAddEditViewModel(folderStore: folderStore, folder: folder, card: card)
        self._model = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    if let data = model.frontData, let uiImage = UIImage(data: data) {
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
                            model.isShowingPhotoOptions = true
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
                    TextField("Name", text: $model.card.playerName)
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .textFieldStyle(.roundedBorder)
                    TextField("Team", text: $model.card.team)
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .textFieldStyle(.roundedBorder)
                    TextField("Position", text: $model.card.position)
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .textFieldStyle(.roundedBorder)
                    HStack {
                        Text("Grade:")
                            .font(.title2)
                        Picker(
                            selection: $model.card.grade,
                            label: Text("")) {
                                ForEach(0..<11) { number in
                                    Text("\(number)")
                                        .tag(number)
                                }
                            }
                    }
                    
                }
                NavigationLink(destination: FolderView(folderStore: folderStore), isActive: $moveBackToCollection) {
                    EmptyView()
                }
            }
            .onChange(of: model.image, perform: { newValue in
                model.changeForUIImage(newValue: newValue)
                model.isShowingPhotoOptions = false
                model.isShowingCamera = false
            })
            .onChange(of: model.selectedPhotos, perform: { newValue in
                model.change(newValue: newValue)
                model.isShowingPhotoOptions = false
                model.isShowingCamera = false
            })
            .sheet(isPresented: $model.isShowingPhotoOptions) {
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
                        model.isShowingPhotoOptions = false
                        model.isShowingCamera = true
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("save button pressed")
                        model.saveCardToFolder()
                        moveBackToCollection = true
                    } label: {
                        Text("Save")
                    }
                }
            }
            .sheet(isPresented: $model.isShowingCamera) {
                ImagePicker(selectedImage: $model.image)
            }
        }
    }
}

