//
//  TableViewsCustomCells.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 29/01/2024.
//

import UIKit


/**
 We'll store here every single custom Table View Cell that we use in the project.
 */

class CharactersTableViewCell: UITableViewCell {
    @IBOutlet weak var characterPhotoImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterStatusLabel: UILabel!
}


class EpisodesTableViewCell: UITableViewCell {
    @IBOutlet weak var episodeNameLabel: UILabel!
}
