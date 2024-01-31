//
//  Character.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 29/01/2024.
//

import UIKit


enum StatusType: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var outputName: String {
        switch self {
        case .alive:
            return "Alive"
        case .dead:
            return "Dead"
        case .unknown:
            return "Unknown"
        }
    }
    
    var statusColor: UIColor {
        switch self {
        case .alive:
            return ColorsPalette.statusGreen
        case .dead:
            return ColorsPalette.statusRed
        case .unknown:
            return ColorsPalette.statusGray
        }
    }
}

extension StatusType {
    public init(fromString string: String) {
        // TODO: Jesus (29/01/2024) - We are defaulting it to .unknown, but this is something that we'd need to change.
        self = StatusType(rawValue: string) ?? .unknown
    }
}


struct Character {
    let id: Int
    let name: String
    let status: StatusType
    let specie: String      // Combination between specie & type
    let origin: Origin
    let lastLocation: Location
    let imageUrl: String
    let episodesList: [String]
    
    // We'll calculate the character's popularity based on the number of episodes that he/she has been seen in.
    var popularity: Int {
        return episodesList.count
    }
    
    // We wanna extract each episode number that this character appears in.
    var episodeNumbers: [Int] {
        let episodeNumbers = episodesList.compactMap { episodeUrl -> Int? in
            // Intentar extraer el número de la URL
            if let episodeNumberString = episodeUrl.split(separator: "/").last,
               let episodeNumber = Int(episodeNumberString) {
                return episodeNumber
            } else {
                return nil
            }
        }
        return episodeNumbers
    }
}
