//
//  CharactersPage.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 28/01/2024.
//

import Foundation


struct CharactersPage: Decodable {
    let info: PageInfo
    let results: [CharacterResponse]
}

struct PageInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
