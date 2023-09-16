//
//  FolderListView.swift
//  CardViewer
//
//  Created by Joshua Ford on 5/23/23.
//

import SwiftUI


struct FolderListView: View {
    
    @StateObject private var viewModel: FolderListMainViewModel
    
    @StateObject private var navigationModel: NavigationModel
    @StateObject private var folderStore: FolderStore
    
    @AppStorage("hasAddedAFolder") var hasAddedAFolder: Bool = false
    
    init(navigationModel: NavigationModel, folderStore: FolderStore) {
        self._navigationModel = StateObject(wrappedValue:navigationModel)
        self._folderStore = StateObject(wrappedValue:folderStore)
        self._viewModel = StateObject(wrappedValue: FolderListMainViewModel(navigationModel: navigationModel, folderStore: folderStore))
    }
    
    var body: some View {
        ZStack {
            FolderListMainView(viewModel: viewModel)
            if hasAddedAFolder == false {
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                VStack {
                    Text("Tap Here To Add A Folder!")
                        .font(.title)
                        .bold()
                        .foregroundColor(.red)
                        .padding(.top, 475) //Better way to do this? because this doesn't work on smaller phones.
                    Image(systemName: "arrow.down")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 100, height: 125)
                }
            }
        }
    }
}
