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
    let navigationModel: NavigationModel
    
    init(card: Card, navigationModel: NavigationModel) {
        self.card = card
        self.navigationModel = navigationModel
    }
    
    func moveToCardAddEditView() {
        navigationModel.currentCard = card
        navigationModel.navigationPath.append(Views.cardAddEditView)
    }
    
    func getFantasyPointsForPlayer(player: String, completion: @escaping (String) -> Void) {
        NetworkService.getProjectedFantasyPointsFor(player: player) { points in
            completion(points)
        }
    }
    
}

struct CardInfoView: View {
    
    @State private var model: CardInfoViewModel
    @State private var points = ""
    
    init(card: Card, navigationModel: NavigationModel) {
        self._model = State(wrappedValue: CardInfoViewModel(card: card, navigationModel: navigationModel))
        print(card.playerName)
    }
    
    var body: some View {
        VStack {
            HStack {
                if let frontData = model.card.frontImageData {
                    Image(uiImage: UIImage(data: frontData)!)
                        .resizable()
                        .frame(width: 150, height: 300)
                        .aspectRatio(contentMode: .fit)
                }
                if let backData = model.card.backImageData {
                    Image(uiImage: UIImage(data: backData)!)
                        .resizable()
                        .frame(width: 150, height: 300)
                        .aspectRatio(contentMode: .fit)
                }
            }
            Text(model.card.playerName)
                    .font(Font(CTFont(.system, size: 30)))
            Text(model.card.position)
                .font(.title2)
            Text(model.card.team)
                .font(.title2)
                Text("Projected Fantasy Points (PPR): \(points)")
                    .font(.title2)
            
            if model.card.playerName == "" {
                Text("No player name given")
                    .font(Font(CTFont(.system, size: 30)))
            }
            Spacer()
        }
        .task {
            model.getFantasyPointsForPlayer(player: model.card.playerName) { points2 in
                points = points2
                print(points)
            }
        }
        .padding(.top, 25)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    print("Edit Button Pressed for Player: " + model.card.playerName)
                    model.moveToCardAddEditView()
                } label: {
                    Text("Edit")
                }
            }
        }
    }
}
