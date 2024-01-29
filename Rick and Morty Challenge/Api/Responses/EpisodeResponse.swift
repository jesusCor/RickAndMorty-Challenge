//
//  EpisodeResponse.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 29/01/2024.
//

import Foundation


struct EpisodeResponse: Codable {
    let id: Int
    let name: String
    let episode: String
    
    func toModel() -> Episode {
        return Episode(id: self.id, name: self.name, episode: self.episode)
    }
}
