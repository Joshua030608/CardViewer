//
//  CardAddEditView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/31/23.
//

import SwiftUI
import PhotosUI

struct CardAddEditView: View {
    @State private var nameString: String = ""
    @State private var posititionString: String = ""
    @State private var teamString: String = ""
    @State private var grade: String = ""
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var data: Data?
    
    
    var body: some View {
        VStack {
            PhotosPicker(
                selection: $selectedPhotos,
                maxSelectionCount: 5,
                matching: .images) {
                    VStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                        Text("Add Image(s)")
                            .font(.largeTitle)
                    }
                }.padding(100)
                .onChange(of: selectedPhotos) { newValue in
                    guard let item = selectedPhotos.first else {
                        return
                    }
                    item.loadTransferable(type: Data.self) { result in
                        switch result {
                        case .success(let data):
                            if let data = data {
                                self.data = data
                            } else {
                                print("failed to load")
                            }
                        case .failure(let failure):
                            fatalError("\(failure)")
                        }
                    }
                }
            if let data = data, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            Spacer()
            TextField("Name", text: $nameString)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .textFieldStyle(.roundedBorder)
            TextField("Team", text: $teamString)
                .multilineTextAlignment(.center)
                .font(.title2)
                .textFieldStyle(.roundedBorder)
            TextField("Position", text: $posititionString)
                .multilineTextAlignment(.center)
                .font(.title2)
                .textFieldStyle(.roundedBorder)
            HStack {
                Text("Grade:")
                    .font(.title2)
                Picker(
                    selection: $grade,
                    label: Text("1")) {
                        ForEach(0..<11) { number in
                            Text("\(number)")
                                .tag("\(number)")
                        }
                }
            }
            Text(grade)
                .padding(100)
        }
    }
}

struct CardAddEditView_Previews: PreviewProvider {
    static var previews: some View {
        CardAddEditView()
    }
}
