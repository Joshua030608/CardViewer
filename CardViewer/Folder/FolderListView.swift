//
//  FolderListView.swift
//  CardViewer
//
//  Created by Joshua Ford on 5/23/23.
//

import SwiftUI


struct FolderListView: View {
    
    @State private var viewModel: FolderListMainViewModel
    
    @AppStorage("hasAddedAFolder") var hasAddedAFolder: Bool = false
    
    init(navigationModel: NavigationModel, folderStore: FolderStore) {
        self._viewModel = State(wrappedValue: FolderListMainViewModel(navigationModel: navigationModel, folderStore: folderStore))
    }
    
    var body: some View {
        ZStack {
            FolderListMainView(viewModel: viewModel)
            if hasAddedAFolder == false {
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .padding(.bottom, FolderListMainView.buttonHeight + 5)
                VStack {
                    Spacer()
                    Text("Tap Here To Add A Folder!")
                        .font(.title)
                        .bold()
                        .foregroundColor(.red)
                    Image(systemName: "arrow.down")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 100, height: 125)
                }.padding(.bottom, FolderListMainView.buttonHeight + 5)
            }
        }.onChange(of: viewModel.folderStore.folders.count) { _ in
            hasAddedAFolder = true
        }
    }
}
