//
//  ScannerView.swift
//  ScannerTest
//
//  Created by Joshua Ford on 4/10/23.
//

import SwiftUI

struct ScannerView: View {
    @State var scanResult = "No QR code detected"
    @State var showWebView = false
    @State var testString: String = ""
    @State var readyToNavigate = false
    @EnvironmentObject var navigationModel: NavigationModel
    @State private var parser = HTMLParser()
    var body: some View {
            ZStack(alignment: .bottom) {
                QRScanner(result: $scanResult)
//                VStack {
//                    Text(scanResult)
//                        .padding()
//                        .background(.black)
//                        .foregroundColor(.white)
//                        .padding(.bottom)
//                }
            .onChange(of: scanResult, perform: { _ in
                if URL(string: scanResult) != nil {
                    //testString = scanResult
                    let parsedData = parser.parseHtmlAsURLString(scanResult)
                    if let parsedData = parsedData {
                        navigationModel.currentCard = Card(playerName: parsedData.0, team: "", frontImageData: nil, backImageData: nil, position: "", grade: parsedData.1)
                    }
                    navigationModel.navigationPath.append(Views.cardAddEditView)
                }
            })
        }
    }
}
