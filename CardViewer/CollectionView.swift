//
//  CollectionView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/23/23.
//

import SwiftUI


struct CardView: View {
    var card: Card
    
    var body: some View {
        HStack {
            VStack {
                Text(card.playerName)
                Text(card.team)
            }
            Spacer()
            Text(card.position)
            Spacer()
            Image(card.imageName)
                .resizable()
                .frame(width: 150, height: 200)
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct CollectionView: View {
    
    let cards = [
        Card(playerName: "Jalen Hurts", team: "Eagles", imageName: "jalenHurts", position: "QB"),
    Card(playerName: "A.J. Brown", team: "Eagles", imageName: "ajBrown", position: "WR"),
        Card(playerName: "Boston Scott", team: "Eagles", imageName: "bostonScott", position: "RB")
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(cards) { card in
                        CardView(card: card)
                    }
                }
                NavigationLink("Go", destination: CardAddEditView())
            }
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
