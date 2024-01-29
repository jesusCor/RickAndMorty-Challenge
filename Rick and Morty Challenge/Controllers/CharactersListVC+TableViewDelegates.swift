//
//  CharactersListVC+TableViewDelegates.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 29/01/2024.
//

import UIKit
import Kingfisher


extension CharactersListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = sortedCharacters[indexPath.section]
        
        let vc = StoryboardUtils.getCharacterDetailsVC() as! CharacterDetailsVC
        vc.character = character
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension CharactersListVC: UITableViewDataSource {
    
    /**
     We'll have one character per section to allow us to have some empty spacing between cells.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedCharacters.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /**
     We'll use these delegate's functions to add some spacing between cells.
     */
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // Create an empty footer view with the desired height
        let spacerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SpacerFooterView") ?? UITableViewHeaderFooterView()
        spacerFooterView.contentView.backgroundColor = .clear
        spacerFooterView.contentView.frame.size.height = CharactersListVC.spacingBetweenCells
        return spacerFooterView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CharactersListVC.spacingBetweenCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "CharactersTableViewCellIdentifier", for: indexPath ) as! CharactersTableViewCell
        
        // Set rounded corners for the cell's content view
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
        
        // Populate cell from character.
        if (sortedCharacters.count > indexPath.section) {
            let character = sortedCharacters[indexPath.section]
            
            // We use Kingfisher to load and set the character's image.
            if let imageUrl = URL(string: character.imageUrl) {
                cell.characterPhotoImageView.kf.setImage(with: imageUrl)
            }
            
            cell.characterNameLabel.text = character.name
            cell.characterStatusLabel.text = character.status.outputName
        }
        
        return cell
    }
    
    // TODO: Jesus (29/01/2024) - Only if we add support for pagination.
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !sortedCharacters.isEmpty else { return }

        // To keep fetching characters (in a paginated way) whenever we keep scrolling down.
        if (indexPath.section == sortedCharacters.count - 1 && !lastPageReached) {
            fetchCharacters()
        }
    }
}
