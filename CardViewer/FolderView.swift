//
//  CollectionView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/23/23.
//

import SwiftUI


struct CardView: View {
    var card: Card
    @State private var isShowingFront = true
    @State private var flipped = false
    @State private var animate3d = false
    
    var body: some View {
        NavigationStack {
            NavigationLink {
                CardInfoView(card: card)
            } label: {
                HStack {
                    VStack {
                        Text(card.playerName)
                        Text(card.team)
                        if card.playerName == "" {
                            Text("No name")
                                .font(.title2)
                        }
                    }
                    Spacer()
                    Text(card.position)
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
                    }
                }
            }
        }
    }
}

struct FlipEffect: GeometryEffect {
    
    var animatableData: Double {
        get {
            print("got animatableData")
            return angle
        }
        set { angle = newValue
            print(newValue)
        }
    }
    
    @Binding var flipped: Bool
    var angle: Double
    let axis: (x: CGFloat, y: CGFloat)

    func effectValue(size: CGSize) -> ProjectionTransform {

        print(#function)
        
        DispatchQueue.main.async {
                self.flipped = self.angle >= 90 && self.angle < 270
        }

        let tweakedAngle = flipped ? -180 + angle : angle
        let a = CGFloat(Angle(degrees: tweakedAngle).radians)

        var transform3d = CATransform3DIdentity;
        transform3d.m34 = -1/max(size.width, size.height)

        transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)

        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))

        return ProjectionTransform(transform3d).concatenating(affineTransform)
    }
}

struct FolderView: View {
    
    @ObservedObject var folderStore: FolderStore
    @ObservedObject var folder: Folder
    
    @State private var folderAddEditIsShowing = false
    @State private var newFolderName = ""
    @State private var newFolderLeague: League = .NFL
    @State private var newFolderCards: [Card] = []
    
    private var cards: [Card] {
        if folderStore.folders.isEmpty {
            return []
        } else {
            return folderStore.folders.first!.cards
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    List {
                        ForEach(cards) { card in
                            CardView(card: card)
                        }.onDelete { indexSet in
                            folder.deleteCard(indices: indexSet, folderStore: folderStore)
                        }
                    }
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
                
                NavigationLink(destination: CardAddEditView(folderStore: folderStore, folder: folder, card: nil)) {
                    Text("Add Card")
                        .font(.largeTitle)
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
}

//struct CollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        CollectionView()
//    }
//}
