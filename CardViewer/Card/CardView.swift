//
//  CardView.swift
//  CardViewer
//
//  Created by Joshua Ford on 8/8/23.
//

import SwiftUI

struct CardView: View {
    
    @EnvironmentObject var navigationModel: NavigationModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var card: Card
    @State private var isShowingFront = true
    @State private var flipped = false
    @State private var animate3d = false
    
    var body: some View {
        Button {
            navigationModel.currentCard = card
            navigationModel.navigationPath.append(Views.cardInfoView)
        } label: {
            HStack {
                VStack {
                    Text(card.playerName)
                        .foregroundColor(colorScheme == .light ? .black : .white)
                    Text(card.team)
                        .foregroundColor(colorScheme == .light ? .black : .white)
                    if card.playerName == "" {
                        Text("No name")
                            .font(.title2)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                    }
                }
                Spacer()
                Text(card.position)
                    .foregroundColor(colorScheme == .light ? .black : .white)
                Spacer()
                /*if let _ = card.frontImageData {
                    Image(uiImage: isShowingFront ? UIImage(data: card.frontImageData!)! : UIImage(data: card.backImageData!)!)
                        .resizable()
                        .frame(width: 150, height: 200)
                        .aspectRatio(contentMode: .fit)
                        .onTapGesture {
                            withAnimation {
                                isShowingFront.toggle()
                            }
                        }
                        .rotation3DEffect(.degrees(isShowingFront ? 0.0 : 180.0), axis: (x: 0, y: 1, z: 0))
                } else {
                    Text("No images found!")
                        .font(.title3)
                } */
                
                if card.frontImageData != nil && card.backImageData != nil {
                    ZStack {
                        Image(uiImage: UIImage(data: card.frontImageData!)!)
                            .resizable()
                            .frame(width: 150, height: 200)
                            .aspectRatio(contentMode: .fit)
                            .opacity(flipped ? 0.0 : 1.0)
                        
                        Image(uiImage: UIImage(data: card.backImageData!)!)
                            .resizable()
                            .frame(width: 150, height: 200)
                            .aspectRatio(contentMode: .fit)
                            .opacity(flipped ? 1.0 : 0.0)
                        
                    }.modifier(FlipEffect(flipped: $flipped, angle: animate3d ? 180 : 0, axis: (x: 0, y: 1)))
                        .onTapGesture {
                            withAnimation(Animation.linear(duration: 0.3)) {
                                self.animate3d.toggle()
                            }
                        }
                    
                } else if card.frontImageData != nil {
                    Image(uiImage: UIImage(data: card.frontImageData!)!)
                        .resizable()
                        .frame(width: 150, height: 200)
                        .aspectRatio(contentMode: .fit)
                } else {
                    Text("No Images Found!")
                        .font(.title3)
                        .foregroundColor(.black)
                }
            }
        }
    }
}
