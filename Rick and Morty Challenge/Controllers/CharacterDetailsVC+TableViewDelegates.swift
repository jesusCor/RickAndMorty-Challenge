//
//  CharacterDetailsVC+TableViewDelegates.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 29/01/2024.
//

import UIKit
import Kingfisher


extension CharacterDetailsVC: UITableViewDataSource {
    
    /**
     We'll have one character per section to allow us to have some empty spacing between cells.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return episodesToDisplay.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "EpisodesTableViewCellIdentifier", for: indexPath ) as! EpisodesTableViewCell
        
        // Set border for the cell.
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.black.cgColor
        
        // Populate cell from character.
        if (episodesToDisplay.count > indexPath.section) {
            let episode = episodesToDisplay[indexPath.section]
            
            cell.episodeNameLabel.text = "• \(episode.episode): \(episode.name)"
        }
        
        return cell
    }
    
    // TODO: Jesus (29/01/2024) - Only if we add support for pagination.
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard !episodesToDisplay.isEmpty else { return }
//
//        // To keep fetching episodes (in a paginated way) whenever we keep scrolling down.
//        if (indexPath.section == episodesToDisplay.count - 1 && !lastPageReached) {
//            fetchEpisodes()
//        }
//    }
}
