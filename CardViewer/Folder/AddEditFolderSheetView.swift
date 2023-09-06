//
//  AddEditFolderSheetView.swift
//  CardViewer
//
//  Created by Joshua Ford on 8/22/23.
//

import SwiftUI

struct AddEditFolderSheetView: View {
    let folderStore: FolderStore
    
    @Environment (\.dismiss) var dismiss
    @State private var newFolderName = ""
    @State private var newFolderLeague = League.NFL
    
    var body: some View {
        VStack {
            TextField("Name", text: $newFolderName)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .padding(50)
            Picker(selection: $newFolderLeague, label: Text("")) {
                ForEach(League.allCases) { case1 in
                    Text(case1.title)
                        .tag(case1)
                }
            }
            Button {
                folderStore.save(folder: Folder(name: newFolderName, cards: [], league: newFolderLeague))
                dismiss()
                newFolderName = ""
                newFolderLeague = .NFL
            } label: {
                Text("Save Folder")
                    .cornerRadius(10)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .background(.blue)
            }
            
        }
    }
}
