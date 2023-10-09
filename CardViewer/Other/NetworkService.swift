//
//  NetworkService.swift
//  CardViewer
//
//  Created by Joshua Ford on 9/26/23.
//

import Foundation
import SwiftyJSON

protocol PlayerNameSource {
    func loadPlayerNames() -> [String]
}

class NetworkService: PlayerNameSource {
    
    static let shared = NetworkService()
    
    let headers = [
        "X-RapidAPI-Key": "[REDACTED]",
        "X-RapidAPI-Host": "tank01-nfl-live-in-game-real-time-statistics-nfl.p.rapidapi.com"
    ]
    
    var allPlayerNames: [Int: String]
    
    init() {
        
        var playerNames: [Int: String] = [: ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://tank01-nfl-live-in-game-real-time-statistics-nfl.p.rapidapi.com/getNFLPlayerList")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let sesson = URLSession.shared
        let dataTask = sesson.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard error == nil else {
                print(error!.localizedDescription)
                playerNames = [0: "error"]
                return
            }
            
            let myJson = try! JSON(data: data!)
            let names = myJson["body"]
            
            for (_, dictOfPlayer) in names {
                let playerID = Int(dictOfPlayer["espnID"].stringValue)!
                let playerName = dictOfPlayer["longName"].stringValue
                //print(playerName)
                playerNames[playerID] = playerName
            }
        })
        dataTask.resume()
        print(playerNames.values)
        //When printing the playerNames indivdually (line 48), all names were printed. However, self.allPlayerNames is set before allThePlayerNames are had. So, the names are printed but the actuall dictionary is not updated. AllPLayerNames never has the players in it.
        self.allPlayerNames = playerNames
    }
    
    func getProjectedFantasyPointsFor(player: String, completion: @escaping (String) -> Void) {
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://tank01-nfl-live-in-game-real-time-statistics-nfl.p.rapidapi.com/getNFLProjections?week=5&twoPointConversions=2&passYards=.04&passAttempts=-.5&passTD=4&passCompletions=1&passInterceptions=-2&pointsPerReception=1&carries=.2&rushYards=.1&rushTD=6&fumbles=-2&receivingYards=.1&receivingTD=6&targets=.1")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            
            let myJson = try! JSON(data: data!)
            let playerProjections = myJson["body"]["playerProjections"]
            for (playerID, json) in playerProjections {
                if json["longName"].stringValue == player {
                    let points = myJson["body"]["playerProjections"][playerID]["fantasyPointsDefault"]["PPR"].stringValue
                    completion(points)
                }
            }
        })
        dataTask.resume()
    }
    
    func loadPlayerNames() -> [String] {
        return Array(allPlayerNames.values)
    }
}
