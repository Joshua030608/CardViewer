//
//  CollectionView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/23/23.
//

import SwiftUI

struct Card: Identifiable {
    var id = UUID()
    var playerName: String
    var team: String
    var image: Image
    var position: String
}

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
            card.image
                .resizable()
                .frame(width: 150, height: 200)
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct CollectionView: View {
    
    let cards = [
        Card(playerName: "Jalen Hurts", team: "Eagles", image: Image("jalenHurts"), position: "QB"),
    Card(playerName: "A.J. Brown", team: "Eagles", image: Image("ajBrown"), position: "WR"),
        Card(playerName: "Boston Scott", team: "Eagles", image: Image("bostonScott"), position: "RB")
    ]
    
    var body: some View {
//        List {
//            Text("hi")
//            Image(systemName: "xbox.logo")
//        }
//        ScrollView(.vertical) {
//            VStack {
//                ForEach(1..<101) { index in
//                    Text("\(index)")
//                }
//            }
//        }
        List {
            ForEach(cards) { card in
                CardView(card: card)
            }
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
