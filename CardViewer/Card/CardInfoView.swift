//
//  CardInfoView.swift
//  CardViewer
//
//  Created by Joshua Ford on 5/8/23.
//

import SwiftUI
import SwiftyJSON

@Observable class CardInfoViewModel {
    
    let card: Card
    
    init(card: Card) {
        self.card = card
    }
    
    func moveToCardAddEditView() {
        navigationModel.currentCard = card
        navigationModel.navigationPath.append(Views.cardAddEditView)
    }
    
    func getFantasyPointsForPlayer(player: String) {
        
    }
    
}

struct CardInfoView: View {
    
    @EnvironmentObject var folderStore: FolderStore
    @EnvironmentObject var navigationModel: NavigationModel
    
    @State private var viewModel: CardInfoViewModel
    
    init(card: Card) {
        self._viewModel = State(wrappedValue: CardInfoViewModel(card: card))
    }
    
    var body: some View {
        VStack {
            HStack {
                if let frontData = card.frontImageData {
                    Image(uiImage: UIImage(data: frontData)!)
                        .resizable()
                        .frame(width: 150, height: 300)
                        .aspectRatio(contentMode: .fit)
                }
                if let backData = card.backImageData {
                    Image(uiImage: UIImage(data: backData)!)
                        .resizable()
                        .frame(width: 150, height: 300)
                        .aspectRatio(contentMode: .fit)
                }
            }
                Text(card.playerName)
                    .font(Font(CTFont(.system, size: 30)))
            Text(card.position)
                .font(.title2)
            Text(card.team)
                .font(.title2)
            if card.playerName == "" {
                Text("No player name given")
                    .font(Font(CTFont(.system, size: 30)))
            }
            
            Spacer()
        }
        .task {
            model.getFantasyPointsForPlayer(player: model.card.playerName)
        }
        .padding(.top, 25)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    print("Edit Button Pressed for Player: " + card.playerName)
                    moveToCardAddEditView()
                } label: {
                    Text("Edit")
                }
            }
        }
    }
}
