//
//  CardAddEditView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/31/23.
//

import SwiftUI
import PhotosUI

struct CardAddEditView: View {
    @EnvironmentObject var navigationModel: NavigationModel
    @StateObject private var model: CardAddEditViewModel
    
    @ObservedObject private var autocompleteObject = AutocompleteObject()
    
    @FocusState private var isNameFocused: Bool
    
    private var suggestions: [String] {
        let suggestions = autocompleteObject.suggestions
        if suggestions.isEmpty {
            return ["No Players Found"]
        } else {
            return suggestions
        }
    }
    
    init(folderStore: FolderStore, folder: Folder, card: Card?) {
        let viewModel = CardAddEditViewModel(folderStore: folderStore, folder: folder, card: card)
        self._model = StateObject(wrappedValue: viewModel)
    }
    
    func moveBackToFolderView() {
        navigationModel.currentFolder = model.folder
        navigationModel.navigationPath.removeLast()
        if navigationModel.scannerViewIsIn {
            navigationModel.navigationPath.removeLast()
            navigationModel.scannerViewIsIn = false
        }
    }
    
    var body: some View {
        let _ = Self._printChanges()
        Form {
            if let frontData = model.card.frontImageData, let backData = model.card.backImageData {
                CardAddEditImageView(frontData: frontData, backData: backData)
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
                .focused($isNameFocused)
                .id(1)
                .onChange(of: model.card.playerName) {
                    autocompleteObject.autocomplete(model.card.playerName)
                    isNameFocused = true
                }
                .onChange(of: isNameFocused) { old, new in
                    print(old, new)
                }
                .onChange(of: suggestions.count) {
                    isNameFocused = true
                }
            
            List(autocompleteObject.suggestions, id: \.self) { suggestion in
                Text(suggestion)
                    .onTapGesture {
                        model.card.playerName = suggestion
                    }
            }
            .onAppear {
                isNameFocused = true
            }
            .onDisappear {
                print("on Dissapear")
                isNameFocused = true
            }
            
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
        .onChange(of: model.selectedPhotos) { _, newValue in
            model.change(newValue: newValue)
            model.isShowingPhotoOptions = false
            model.isShowingCamera = false
        }

        .onChange(of: model.image1) { _, newValue in
            if let _ = model.image1 {
                model.changeForUIImage(newValue: newValue, sideOfCard: .front)
            }
        }
        .onChange(of: model.image2) { _, newValue in
            if let _ = model.image1 {
                model.changeForUIImage(newValue: newValue, sideOfCard: .back)
                model.isShowingPhotoOptions = false
                model.isShowingCamera = false
                model.isShowingPreviewView = true
            }
        }
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
                        model.saveCardToFolder { card in
                            navigationModel.currentCard = card
                        }
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

