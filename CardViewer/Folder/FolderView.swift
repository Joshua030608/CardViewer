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
    
    @AppStorage("hasAddedACard") var hasAddedACard: Bool = false
    
    @State private var folderAddEditIsShowing = false
    @State private var isShowingCardAddOptions = false
    @State private var newFolderName = ""
    @State private var newFolderLeague: League = .NFL
    @State private var newFolderCards: [Card] = []
    @State private var searchString = ""
    @State private var searchMode = SearchTypes.name
    
    private let buttonHeight: CGFloat = 65
    
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
            switch searchMode {
            case .name:
                return card.playerName.lowercased().contains(searchString.lowercased())
            case .position:
                return card.position.lowercased().contains(searchString.lowercased())
            case .team:
                return card.team.lowercased().contains(searchString.lowercased())
            }
        }
    }
    
    init(folderStore: FolderStore, folder: Folder) {
        self.folderStore = folderStore
        self.folder = folder
    }
    
    var body: some View {
        ZStack {
            if hasAddedACard == false {
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .padding(.bottom, buttonHeight + 5)
                VStack {
                    Spacer()
                    Text("Tap Here To Add A Card!")
                        .font(.title)
                        .bold()
                        .foregroundColor(.red)
                    Image(systemName: "arrow.down")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 100, height: 125)
                }.padding(.bottom, buttonHeight + 5)
            }
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
                HStack {
                    Button {
                        isShowingCardAddOptions = true
                    } label: {
                        Text("Add Card")
                            .font(.largeTitle)
                    }
                    if folder.cards.isEmpty == false {
                        Divider()
                        Button {
                            navigationModel.currentCard = folder.cards.randomElement()
                            navigationModel.navigationPath.append(Views.cardInfoView)
                        } label: {
                            Label("Random", systemImage: "gift.fill")
                                .font(.largeTitle)
                        }
                    }
                }.frame(height: buttonHeight)
                    .confirmationDialog("Card", isPresented: $isShowingCardAddOptions, titleVisibility: .hidden) {
                        Button("Scan Card") {
                            navigationModel.currentFolder = folder
                            navigationModel.currentCard = nil
                            navigationModel.scannerViewIsIn = true
                            navigationModel.navigationPath.append(Views.scannerView)
                        }
                        Button("Manually Add Card") {
                            navigationModel.currentFolder = folder
                            navigationModel.currentCard = nil
                            navigationModel.navigationPath.append(Views.cardAddEditView)
                        }
                    }
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
        }.onChange(of: folder.cards.count) { _ in
            hasAddedACard = true
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
