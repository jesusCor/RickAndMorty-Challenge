//
//  Rick_and_Morty_Challenge_Tests.swift
//  Rick and Morty Challenge Tests
//
//  Created by Jesus Coronado on 29/01/2024.
//

import XCTest
@testable import Rick_and_Morty_Challenge


class CharactersListVCTests: XCTestCase {

    var sut: CharactersListVC!

    
    override func setUp() {
        super.setUp()
        
        // Populate CharactersListVC.
        let navController = StoryboardUtils.getCharactersListVC() as! UINavigationController
        sut = navController.topViewController as? CharactersListVC
        
        // Flag to indicate that we wanna use the mock repositories when running tests.
        sut.runMockRepositories = true
        
        // Loads the view controller’s view if it’s not loaded yet.
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    
    // MARK: - Test Setup

    func testViewControllerNotNil() {
        XCTAssertNotNil(sut, "CharactersListVC should not be nil")
    }

    func testTableViewNotNil() {
        XCTAssertNotNil(sut.charactersTableView, "charactersTableView should not be nil")
    }


    // MARK: - Test Initial State

    func testInitialPageValues() {
        XCTAssertEqual(sut.currentPage, 1, "Initial currentPage should be 1")
        XCTAssertFalse(sut.lastPageReached, "Initial lastPageReached should be false")
    }

    func testInitialSortBy() {
        XCTAssertEqual(sut.selectedSortBy, .name, "Initial selectedSortBy should be .name")
    }
    

    // MARK: - Test Fetching Characters

    func testFetchCharacters() {
        // Create an expectation.
        let fetchCharactersExpectation = expectation(description: "Fetch characters expectation")
        
        // The closure below is called when the fetchCharacters() operation is completed
        sut.fetchCharacters {
            // Fulfill the expectation.
            fetchCharactersExpectation.fulfill()
        }

        // Wait for a reasonable amount of time for the expectation to be fulfilled.
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("Error: \(error)")
            }

            // Check that our tableView contains exactly 15 characters (same as the CharactersPage.json)
            XCTAssertTrue(self.sut.charactersTableView.numberOfSections == 15, "Expected 15 sections in the table view.")
        }
    }
    

    // MARK: - Test Sorting

    func testSortCharactersByName() {
        // Create an expectation.
        let fetchCharactersExpectation = expectation(description: "Fetch characters expectation")
        
        // The closure below is called when the fetchCharacters() operation is completed
        sut.fetchCharacters {
            // Fulfill the expectation.
            fetchCharactersExpectation.fulfill()
        }
        
        // Wait for a reasonable amount of time for the expectation to be fulfilled.
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("Error: \(error)")
            }

            // Check that the characters are sorted by name.
            XCTAssertEqual(self.sut.sortedCharacters.first?.name, "Abadango Cluster Princess", "Characters should be sorted by name")
        }
    }

    func testSortCharactersByPopularity() {
        // Create an expectation.
        let fetchCharactersExpectation = expectation(description: "Fetch characters expectation")
        
        // Change the index of the segmented control to be set to POPULARITY.
        sut.sortBySegmentedControl.selectedSegmentIndex = 1
        
        // The closure below is called when the fetchCharacters() operation is completed
        sut.fetchCharacters {
            // Fulfill the expectation.
            fetchCharactersExpectation.fulfill()
        }
        
        // Wait for a reasonable amount of time for the expectation to be fulfilled.
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("Error: \(error)")
            }

            // Check that the characters are sorted by popularity.
            // In this case, "Rick Sanchez" is the most popular character and it should be the first one on the list.
            XCTAssertEqual(self.sut.sortedCharacters.first?.name, "Rick Sanchez", "Characters should be sorted by name")
        }
    }

}
