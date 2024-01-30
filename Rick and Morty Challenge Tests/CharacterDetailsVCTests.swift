//
//  CharacterDetailsVCTests.swift
//  Rick and Morty Challenge Tests
//
//  Created by Jesus Coronado on 29/01/2024.
//

import XCTest
@testable import Rick_and_Morty_Challenge


final class CharacterDetailsVCTests: XCTestCase {

    var sut: CharacterDetailsVC!
    
    var character: Character!

    
    override func setUp() {
        super.setUp()
        
        // Populate CharacterDetailsVC.
        sut = StoryboardUtils.getCharacterDetailsVC() as? CharacterDetailsVC
        
        // Flag to indicate that we wanna use the mock repositories when running tests.
        sut.runMockRepositories = true
        
        // Populate mock character (Rick Sanchez, appearing in episodes 3 & 4)..
        character = Character(id: 1, name: "Rick Sanchez", status: .alive, specie: "Human", origin: Origin(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"), lastLocation: Location(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"), imageUrl: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodesList: [ "https://rickandmortyapi.com/api/episode/3","https://rickandmortyapi.com/api/episode/4"])
        sut.character = character
        
        // Loads the view controller’s view if it’s not loaded yet.
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        character = nil
        super.tearDown()
    }
    
    
    // MARK: - Test Setup

    func testViewControllerNotNil() {
        XCTAssertNotNil(sut, "CharacterDetailsVC should not be nil")
    }
    
    
    // MARK: - Test Initial State
    

    func testSettingCharacter() {
        sut.populateCharacter()
        
        // Add assertions to check if the UI elements are updated based on the character
        XCTAssertEqual(sut.characterNameLabel.text, "Rick Sanchez")
        XCTAssertEqual(sut.characterStatusLabel.text, "• STATUS: Alive")
        XCTAssertEqual(sut.characterSpecieLabel.text, "• SPECIE: Human")
        XCTAssertEqual(sut.characterOriginLabel.text, "• ORIGIN: Earth (C-137)")
        XCTAssertEqual(sut.characterLastLocationLabel.text, "• LAST LOCATION: Citadel of Ricks")
    }
    
    
    // MARK: - Test Fetching Episodes

    func testFetchEpisodes() {
        // Create an expectation.
        let fetchEpisodesExpectation = expectation(description: "Fetch episodes expectation")
        
        // The closure below is called when the fetchCharacters() operation is completed
        sut.fetchEpisodes() {
            // Fulfill the expectation.
            fetchEpisodesExpectation.fulfill()
        }

        // Wait for a reasonable amount of time for the expectation to be fulfilled.
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("Error: \(error)")
            }

            // Check that our tableView contains exactly 2 episodes (same as the MultipleEpisodes.json)
            XCTAssertTrue(self.sut.episodesTableView.numberOfSections == 2, "Expected 2 sections in the table view.")
            
            // Make sure that our tableViewCells are showing.
            let firstEpisodeIndexPath = IndexPath(row: 0, section: 0)
            let secondEpisodeIndexPath = IndexPath(row: 0, section: 1)
            let firstEpisodeCell = self.sut.episodesTableView.cellForRow(at: firstEpisodeIndexPath) as? EpisodesTableViewCell
            let secondEpisodeCell = self.sut.episodesTableView.cellForRow(at: secondEpisodeIndexPath) as? EpisodesTableViewCell
            XCTAssertNotNil(firstEpisodeCell)
            XCTAssertNotNil(secondEpisodeCell)
            
            // Check the episodes' names.
            XCTAssertTrue((firstEpisodeCell?.episodeNameLabel.text != nil), "• S01E3: Anatomy Park")
            XCTAssertTrue((secondEpisodeCell?.episodeNameLabel.text != nil), "• S01E4: M. Night Shaym-Aliens!")
        }
    }
    
    func testFetchSingleEpisode() {
        // We'll assign a single episode to the character (episode 1).
        let newEpisodesList = ["https://rickandmortyapi.com/api/episode/1"]
        // Populate mock character (Rick Sanchez, appearing in episodes 3 & 4)..
        let newCharacter = Character(id: 1, name: "Rick Sanchez", status: .alive, specie: "Human", origin: Origin(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"), lastLocation: Location(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"), imageUrl: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodesList: newEpisodesList)
        sut.character = newCharacter
        
        // Create an expectation.
        let fetchEpisodeExpectation = expectation(description: "Fetch episode expectation")
        
        // The closure below is called when the fetchCharacters() operation is completed
        sut.fetchEpisodes() {
            // Fulfill the expectation.
            fetchEpisodeExpectation.fulfill()
        }

        // Wait for a reasonable amount of time for the expectation to be fulfilled.
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("Error: \(error)")
            }
            
            // Check that our tableView contains exactly 1 episode (same as the SingleEpisode.json)
            XCTAssertTrue(self.sut.episodesTableView.numberOfSections == 1, "Expected 1 section in the table view.")
            
            // Make sure that our tableViewCell is showing.
            let singleEpisodeIndexPath = IndexPath(row: 0, section: 0)
            let singleEpisodeCell = self.sut.episodesTableView.cellForRow(at: singleEpisodeIndexPath) as? EpisodesTableViewCell
            XCTAssertNotNil(singleEpisodeCell)
            
            // Check the episode's name.
            XCTAssertTrue((singleEpisodeCell?.episodeNameLabel.text != nil), "• S01E1: Pilot")
            
        }
    }

}
