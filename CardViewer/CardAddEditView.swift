//
//  CardAddEditView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/31/23.
//

import SwiftUI

struct CardAddEditView: View {
    @State private var nameString: String = ""
    
    
    
    
    var body: some View {
        VStack {
            Image(systemName: "xbox.logo")
                .padding()
            TextField("Name", text: .constant(nameString))
            Text(nameString)
        }
    }
}

struct CardAddEditView_Previews: PreviewProvider {
    static var previews: some View {
        CardAddEditView()
    }
}
