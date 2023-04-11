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
    
    var body: some View {
        VStack {
                if let data = model.data, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 100, height: 100)
                } else {
                    PhotosPicker(
                        selection: $model.selectedPhotos,
                        maxSelectionCount: 5,
                        matching: .images) {
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
            Form { //: Tried using form with image inside but didn't look correct
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
        }.onChange(of: model.selectedPhotos) { newValue in
            model.change()
        }
    }
}

struct CardAddEditView_Previews: PreviewProvider {
    static var previews: some View {
        CardAddEditView()
    }
}
