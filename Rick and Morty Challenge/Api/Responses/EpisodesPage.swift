//
//  EpisodesPage.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 29/01/2024.
//

import Foundation


struct EpisodesPage: Decodable {
    let info: PageInfo
    let results: [EpisodeResponse]
}
