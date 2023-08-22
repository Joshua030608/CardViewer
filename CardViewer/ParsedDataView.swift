//
//  ParsedDataView.swift
//  ScannerTest
//
//  Created by Joshua Ford on 4/12/23.
//

import SwiftUI
import SwiftSoup

struct ParsedDataView: View {
    @State var urlString: String
    private let parser = HTMLParser()
    var body: some View {
        VStack {
            Text(urlString)
                .background(.black)
                .foregroundColor(.white)
            //Text(parser.parseHtmlAsURLString(urlString))
            Button {
                print("hello world")
            } label: {
                Text("Hello World")
            }

        }
            
    }
    
    init(urlString: String) {
        self.urlString = urlString
    }
}

struct ParsedDataView_Previews: PreviewProvider {
    static var previews: some View {
        ParsedDataView(urlString: "https://google.com")
    }
}
