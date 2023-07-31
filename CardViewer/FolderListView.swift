//
//  FolderListView.swift
//  CardViewer
//
//  Created by Joshua Ford on 5/23/23.
//

import SwiftUI

struct FolderListView: View {
    @ObservedObject var folderStore: FolderStore
    @State private var folderAddEditIsShowing = false
    @State private var newFolderName = ""
    @State private var newFolderLeague: League = .NFL
    @State private var newFolderCards: [Card] = []
    @State private var refresh = false
    
    
    init(folderStore: FolderStore) {
        self.folderStore = folderStore
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                List {
                    ForEach(folderStore.folders) { folder in
                        /*
                        NavigationLink(value: folder) {
                            HStack {
                                Text("Name: " + folder.name)
                                    .font(.largeTitle)
                                Text("League: " + folder.league.rawValue)
                                    .font(.title)
                                Text("# of Cards: " + String(folder.cards.count))
                                    .font(.title)
                            }
                        } */
                        NavigationLink(destination: FolderView(folderStore: folderStore, folder: folder)) {
                            HStack {
                                Text("Name: " + folder.name)
                                    .font(.largeTitle)
                                Text("League: " + folder.league.rawValue)
                                    .font(.title)
                                Text("# of Cards: " + String(folder.cards.count))
                                    .font(.title)
                            }
                        }
                    }
                    .onDelete(perform: folderStore.deleteFolder)
                    /*.navigationDestination(for: Folder.self) { folder in
                        FolderView(folderStore: folderStore)
                    } */
                }
                .toolbar {
                    EditButton()
                }
                Button {
                    folderAddEditIsShowing = true
                } label: {
                    Text("Add Folder")
                        .font(.largeTitle)
                }
            }
        }
        .onAppear(perform: {
            refresh.toggle()
            print("refresh toggled")
        })
        .sheet(isPresented: $folderAddEditIsShowing, content: {
            VStack {
                TextField("Name", text: $newFolderName)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .padding(50)
                Picker(selection: $newFolderLeague, label: Text("")) {
                    ForEach(League.allCases) { case1 in
                        Text(case1.rawValue)
                            .tag(case1)
                    }
                }
                Button {
                    print("Save button about to save, currently " + String(folderStore.folders.count) + " folders. New folder's name is " + newFolderName + " and its league is " + newFolderLeague.rawValue + ".")
                    //Save Folder with the old folder's id IF EDITING
                    folderStore.save(folder: Folder(name: newFolderName, cards: [], league: newFolderLeague))
                    print("Save Folder Button Pressed, there are now " + String(folderStore.folders.count) + " folders.")
                    folderAddEditIsShowing = false
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
        })
    }
}
