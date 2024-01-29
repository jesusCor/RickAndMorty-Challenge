//
//  CharacterResponse.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 28/01/2024.
//

import Foundation


struct Origin: Codable {
    let name: String
    let url: String
}

struct Location: Codable {
    let name: String
    let url: String
}

struct CharacterResponse: Codable {
    let id: Int
    let name: String
    let status: String      // TODO: Convert to Status enum.
    let species: String
    let type: String
    let gender: String
    let origin: Origin
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    func toModel() -> Character {
        return Character(
            id: self.id,
            name: self.name,
            status: StatusType(fromString: self.status),
            specie: "\(self.species) \(self.type)",
            origin: self.origin,
            lastLocation: self.location,
            imageUrl: self.image,
            episodesList: self.episode
        )
    }
}
