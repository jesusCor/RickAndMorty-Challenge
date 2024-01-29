//
//  CharacterDetailsVC.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 29/01/2024.
//

import UIKit

class CharacterDetailsVC: BaseVC {
    
    var character: Character?
    
    
    // MARK: VC lifecycle functions.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateCharacter()
    }
    
    
    // MARK: Initialization functions.
    
    func populateCharacter() {
        guard let character = character else {
            self.displayAlertWithMessage(message: "Error populating!", toShowCancel: true)
            return
        }
        
        // Populate nav bar.
        navigationItem.title = character.name
    }
    
}
