//
//  CharactersListVC+TextFieldDelegates.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 29/01/2024.
//

import UIKit


extension CharactersListVC: UITextFieldDelegate {
    
    // Used to hide the keyboard when clicking on DONE.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        searchByNameTextField.resignFirstResponder()
        return true
    }
    
}
