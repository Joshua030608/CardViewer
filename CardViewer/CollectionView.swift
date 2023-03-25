//
//  CollectionView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/23/23.
//

import SwiftUI

struct CollectionView: View {
    var body: some View {
//        List {
//            Text("hi")
//            Image(systemName: "xbox.logo")
//        }
        ScrollView(.horizontal) {
            HStack {
                ForEach(1..<101) { index in
                    Text("\(index)")
                }
            }
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
