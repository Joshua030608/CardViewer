//
//  CardAddEditView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/31/23.
//

import SwiftUI
import PhotosUI

class CardAddEditViewModel: ObservableObject {
    @Published var nameString: String = ""
    @Published var posititionString: String = ""
    @Published var teamString: String = ""
    @Published var grade: Int = 0
    @Published var selectedPhotos: [PhotosPickerItem] = []
    @Published var data: Data?
}

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
            Spacer()
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
                    label: Text("1")) {
                        ForEach(0..<11) { number in
                            Text("\(number)")
                                .tag(number)
                        }
                    }
            }
            Text("\(model.grade)")
            .padding(100)
        }.onChange(of: model.selectedPhotos) { newValue in
            guard let item = model.selectedPhotos.first else {
                return
            }
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data {
                        self.model.data = data
                    } else {
                        print("failed to load")
                    }
                case .failure(let failure):
                    fatalError("\(failure)")
                }
            }
        }
    }
}

struct CardAddEditView_Previews: PreviewProvider {
    static var previews: some View {
        CardAddEditView()
    }
}
