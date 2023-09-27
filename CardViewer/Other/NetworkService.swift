//
//  NetworkService.swift
//  CardViewer
//
//  Created by Joshua Ford on 9/26/23.
//

import Foundation
import SwiftyJSON

class NetworkService {
    
    static func getProjectedFantasyPointsFor(player: String, completion: @escaping (String) -> Void) {
        let headers = [
            "X-RapidAPI-Key": "[REDACTED]",
            "X-RapidAPI-Host": "tank01-nfl-live-in-game-real-time-statistics-nfl.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://tank01-nfl-live-in-game-real-time-statistics-nfl.p.rapidapi.com/getNFLProjections?week=4&twoPointConversions=2&passYards=.04&passAttempts=-.5&passTD=4&passCompletions=1&passInterceptions=-2&pointsPerReception=1&carries=.2&rushYards=.1&rushTD=6&fumbles=-2&receivingYards=.1&receivingTD=6&targets=.1")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        var id = ""
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                //print(String(data: data!, encoding: .utf8))
                //print(response as? HTTPURLResponse)
                let myJson = try! JSON(data: data!)
                myJson["body"]["playerProjections"].forEach { (playerID, json) in
                    if json["longName"].stringValue == player {
                        id = playerID
                        print("found player")
                    } else {
                        print("failed to find player")
                    }
                }
                if id == "" {
                    print("invalid player name")
                } else {
                    let points = myJson["body"]["playerProjections"][id]["fantasyPointsDefault"]["PPR"].stringValue
                    print(points)
                    completion(points)
                }
            }
        })
        dataTask.resume()
    }
}
