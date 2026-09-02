//
//  NetworkService.swift
//  CardViewer
//
//  Created by Joshua Ford on 9/26/23.
//

import Foundation
import SwiftyJSON

class NetworkService {

    static let shared = NetworkService()
    
    private let host = "tank01-nfl-live-in-game-real-time-statistics-nfl.p.rapidapi.com"

    /// Supply this value through the Xcode scheme's `RAPIDAPI_KEY` environment
    /// variable when running the app locally. It is intentionally not stored in
    /// the repository or the app bundle.
    private var headers: [String: String]? {
        guard let apiKey = ProcessInfo.processInfo.environment["RAPIDAPI_KEY"],
              !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }

        return [
            "X-RapidAPI-Key": apiKey,
            "X-RapidAPI-Host": host
        ]
    }
    
    private init() {  }
    
    func getPlayerNames(completion: @escaping ([String]) -> Void) {
        guard let headers else {
            completion([])
            return
        }

        var request = URLRequest(
            url: URL(string: "https://\(host)/getNFLPlayerList")!,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                completion([])
                return
            }

            guard let data = data, let myJson = try? JSON(data: data) else {
                completion([])
                return
            }
            
            let names = myJson["body"]
            let playerNames = names.arrayValue.map {
                $0["longName"].stringValue
            }

            completion(playerNames)
        }
        dataTask.resume()
    }
    
    func getProjectedFantasyPointsFor(player: String, completion: @escaping (String) -> Void) {
        guard let headers else {
            completion("")
            return
        }

        var request = URLRequest(
            url: URL(string: "https://\(host)/getNFLProjections?week=5&twoPointConversions=2&passYards=.04&passAttempts=-.5&passTD=4&passCompletions=1&passInterceptions=-2&pointsPerReception=1&carries=.2&rushYards=.1&rushTD=6&fumbles=-2&receivingYards=.1&receivingTD=6&targets=.1")!,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                completion("")
                return
            }

            guard let data = data, let myJson = try? JSON(data: data) else {
                completion("")
                return
            }

            let playerProjections = myJson["body"]["playerProjections"]
            for (playerID, json) in playerProjections {
                if json["longName"].stringValue == player {
                    let points = myJson["body"]["playerProjections"][playerID]["fantasyPointsDefault"]["PPR"].stringValue
                    completion(points)
                    return
                }
            }

            completion("")
        }
        dataTask.resume()
    }
}
