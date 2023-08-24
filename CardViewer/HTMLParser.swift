//
//  HTMLParser.swift
//  ScannerTest
//
//  Created by Joshua Ford on 4/12/23.
//

import SwiftSoup
import Foundation

extension Int {
    static func parse(from string: String) -> Int {
        return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) ?? 0
    }
}

final class HTMLParser {
    
    func parseHtmlAsURLString(_ urlString: String) -> (String, Int)? {
        
        var html = ""
        
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let html2 = try String(contentsOf: url)
            html = html2
        } catch {
            return nil
        }
        
        do {
            
            let document = try SwiftSoup.parse(html)
            guard let body = document.body() else {
                return nil
            }
            
            let tableDs: Elements = try body.getElementsByTag("td")
            let stringArray = try tableDs.eachText()
            
            print("Player Name: \(stringArray[7])")
            print("Player Grade: \(Int.parse(from: stringArray[9]))")
            
            //return String("Player Name: \(stringArray[7])" + "Player Grade: \(Int.parse(from: stringArray[9]))" + "Year: \(Int.parse(from: stringArray[3]))")
            return (stringArray[7], Int.parse(from: stringArray[9]))

        }
        catch {
            return nil
        }
    }
}
