//
//  MockRepositories.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 30/01/2024.
//

import Foundation


/**
 We'll use this class to have a mock version for each of our repositories for when running tests.
 */

// Mock repository class that subclasses the CharactersRepository.
final class MockCharactersRepository: CharactersRepository {
    
    override func getCharactersPage(page: Int, characterName: String) async throws -> CharactersPage {
        // It returns 15 characters only.
        let mockCharactersPageName = "CharactersPage"
        
        guard let mockPage = JsonUtils.parseJson(jsonName: mockCharactersPageName, model: CharactersPage.self) else {
            throw AppErrorType.unknown("Error deserializing the mock CharactersPage")
        }
        
        return mockPage
    }
    
}

// Mock repository class that subclasses the EpisodesRepository.
final class MockEpisodesRepository: EpisodesRepository {
    
    override func getEpisode(episode: Int) async throws -> EpisodeResponse {
        // It returns the episode 1.
        let mockSingleEpisodeName = "SingleEpisode"
        
        guard let mockEpisode = JsonUtils.parseJson(jsonName: mockSingleEpisodeName, model: EpisodeResponse.self) else {
            throw AppErrorType.unknown("Error deserializing the mock SingleEpisode")
        }
        
        return mockEpisode
    }
    
    override func getMultipleEpisodes(episodes: [Int]) async throws -> [EpisodeResponse] {
        // It returns the episodes 3 & 4.
        let mockMultipleEpisodesName = "MultipleEpisodes"
        
        guard let mockEpisodes = JsonUtils.parseJson(jsonName: mockMultipleEpisodesName, model: [EpisodeResponse].self) else {
            throw AppErrorType.unknown("Error deserializing the mock MultipleEpisodes")
        }
        
        return mockEpisodes
    }
    
}
