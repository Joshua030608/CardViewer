//
//  CollectionView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/23/23.
//

import SwiftUI

struct FolderView: View {
    
    private enum SearchTypes: String, CaseIterable, Identifiable {
        var id: String { rawValue }

        case name = "Name"
        case position = "Position"
        case team = "Team"
    }
    
    @EnvironmentObject var navigationModel: NavigationModel
    @ObservedObject var folderStore: FolderStore
    @ObservedObject var folder: Folder
    
    @State private var folderAddEditIsShowing = false
    @State private var newFolderName = ""
    @State private var newFolderLeague: League = .NFL
    @State private var newFolderCards: [Card] = []
    @State private var searchString = ""
    @State private var searchMode = SearchTypes.name
    
    private var searchPromptString: String {
        switch searchMode {
        case .name:
            return "Search By Name"
        case .position:
            return "Search By Position"
        case .team:
            return "Search By Team"
        }
    }
    
    private var cards: [Card] {
        guard folder.cards.isEmpty == false else { return [] }

        guard searchString != "" else { return folder.cards }

        return folder.cards.filter { card in
            card.playerName.lowercased().contains(searchString.lowercased()) ||
            card.team.lowercased().contains(searchString.lowercased()) ||
            card.position.lowercased().contains(searchString.lowercased())
        }
    }
    
    init(folderStore: FolderStore, folder: Folder) {
        self.folderStore = folderStore
        self.folder = folder
    }
    
    var body: some View {
        VStack {
            ZStack {
                List {
                    ForEach(cards) { card in
                        CardView(card: card)
                    }.onDelete { indexSet in
                        folder.deleteCard(indices: indexSet, folderStore: folderStore)
                    }
                }
                .searchable(text: $searchString, placement: .navigationBarDrawer, prompt: searchPromptString)
                .toolbar {
                    EditButton()
                }
                .opacity(cards.isEmpty ? 0.0 : 1.0)
                Text("No Cards Have Been Added!")
                    .padding(125)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                    .opacity(cards.isEmpty ? 1.0 : 0.0)
            }
            Button {
                navigationModel.currentFolder = folder
                navigationModel.currentCard = nil
                navigationModel.navigationPath.append(Views.cardAddEditView)
            } label: {
                Text("Add Card")
                    .font(.largeTitle)
            }
        }.toolbar {
            ToolbarItem(placement: .principal) {
                Picker("SearchCategory", selection: $searchMode) {
                    ForEach(SearchTypes.allCases) { searchType in
                        Text(searchType.rawValue).tag(searchType)
                    }
                }
                .labelsHidden()
                .pickerStyle(.segmented)
            }
        }
    }
        /*.sheet(isPresented: $folderAddEditIsShowing, content: {
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
        }) */
}

//struct CollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        CollectionView()
//    }
//}
