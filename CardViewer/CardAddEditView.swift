//
//  CardAddEditView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/31/23.
//

import SwiftUI
import PhotosUI

struct CardAddEditImageView: View {
    
    let frontData: Data?
    let backData: Data?
    
    init(frontData: Data?, backData: Data?) {
        self.frontData = frontData
        self.backData = backData
    }
    
    var body: some View {
        HStack {
            Spacer()
            if let data = frontData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(10)
                if let backData = backData, let backuiImage = UIImage(data: backData) {
                    Image(uiImage: backuiImage)
                        .resizable()
                        .frame(width: 150, height: 150)
                        .padding(10)
                }
            }
            Spacer()
        }
    }
}

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
                Spacer()
                Form {
                    if let _ = model.card.frontImageData {
                        CardAddEditImageView(frontData: model.card.frontImageData, backData: model.card.backImageData)
                    } else {
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
                NavigationLink(destination: FolderView(folderStore: folderStore, folder: model.folder), isActive: $moveBackToCollection) {
                    EmptyView()
                }.padding(15)
                Spacer()
            }
            .onChange(of: model.selectedPhotos, perform: { newValue in
                model.change(newValue: newValue)
                model.isShowingPhotoOptions = false
                model.isShowingCamera = false
            })
            .onChange(of: model.image1, perform: { newValue in
                model.changeForUIImage(newValue: newValue, sideOfCard: .front)
            })
            .onChange(of: model.image2, perform: { newValue in
                model.changeForUIImage(newValue: newValue, sideOfCard: .back)
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
                        if model.card.playerName != "Name" && model.card.team != "Team" && model.card.position != "Position" {
                            print("save button pressed")
                            model.saveCardToFolder()
                            moveBackToCollection = true
                        } else {
                            print("properties not updated so didn't save")
                        }
                    } label: {
                        Text("Save")
                    }
                }
            }
            .sheet(isPresented: $model.isShowingCamera) {
                //ImagePicker(selectedImage: $model.image)
                CustomCameraView(capturedImage1: $model.image1, capturedImage2: $model.image2)
            }
        }
    }
}

