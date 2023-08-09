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
    @EnvironmentObject var navigationModel: NavigationModel
    @StateObject private var model: CardAddEditViewModel
    
    init(folderStore: FolderStore, folder: Folder, card: Card?) {
        self.folderStore = folderStore
        let viewModel = CardAddEditViewModel(folderStore: folderStore, folder: folder, card: card)
        self._model = StateObject(wrappedValue: viewModel)
    }
    
    func moveBackToFolderView() {
        navigationModel.currentFolder = model.folder
        navigationModel.navigationPath.removeLast()
    }
    
    var body: some View {
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
            Spacer()
        }
        .onChange(of: model.selectedPhotos, perform: { newValue in
            model.change(newValue: newValue)
            model.isShowingPhotoOptions = false
            model.isShowingCamera = false
        })
        .onChange(of: model.image1, perform: { newValue in
            if let _ = model.image1 {
                model.changeForUIImage(newValue: newValue, sideOfCard: .front)
            }
        })
        .onChange(of: model.image2, perform: { newValue in
            if let _ = model.image1 {
                model.changeForUIImage(newValue: newValue, sideOfCard: .back)
                model.isShowingPhotoOptions = false
                model.isShowingCamera = false
                model.isShowingPreviewView = true
            }
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
                        moveBackToFolderView()
                    } else {
                        model.isShowingAlert = true
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
        .alert("Make Sure To Include A Name, Team, And Position Before Saving!", isPresented: $model.isShowingAlert) {
            Button("Ok", role: .cancel) { }
        }
        .sheet(isPresented: $model.isShowingPreviewView) {
            PreviewView(
                frontImage: model.image1!,
                backImage: model.image2!,
                retakeHandler: model.retakeHandler,
                confirmHandler: model.confirmHandler
            )
        }
    }
}

