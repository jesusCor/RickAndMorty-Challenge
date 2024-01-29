//
//  CharacterDetailsVC.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 29/01/2024.
//

import UIKit

class CharacterDetailsVC: BaseVC {
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterStatusLabel: UILabel!
    @IBOutlet weak var characterSpecieLabel: UILabel!
    @IBOutlet weak var characterOriginLabel: UILabel!
    @IBOutlet weak var characterLastLocationLabel: UILabel!
    @IBOutlet weak var episodesTableView: UITableView!
    
    var character: Character?
    
    var episodesToDisplay: [Episode] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.episodesTableView.reloadData()
            }
        }
    }
    
    
    // MARK: VC lifecycle functions.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup delegates.
        episodesTableView.dataSource = self
        
        populateCharacter()
    }
    
    // We'll fetch the episodes for this character as soon as we populate the view.
    override func viewWillAppear(_ animated: Bool) {
        Task { @MainActor in
            fetchEpisodes()
        }
    }
    
    
    // MARK: Initialization functions.
    
    func populateCharacter() {
        guard let character = character else {
            self.displayAlertWithMessage(message: "Error populating!", toShowCancel: true)
            return
        }
        
        // Populate nav bar.
        navigationItem.title = character.name
        
        // We use Kingfisher to load and set the character's image.
        if let imageUrl = URL(string: character.imageUrl) {
            characterImageView.kf.setImage(with: imageUrl)
        }
        characterNameLabel.text = character.name
        characterStatusLabel.text = character.status.outputName
        characterOriginLabel.text = character.origin.name
        characterLastLocationLabel.text = character.lastLocation.name
    }
    
    
    // MARK: Episodes functions.
    
    func fetchEpisodes() {
        Task { @MainActor in
            showProgressHUD()
            
            do {
                var parsedEpisodes: [Episode] = []
                
                // We'll exercise the single episode or the multiple episodes endpoint depending on the count.
                if (!character!.episodeNumbers.isEmpty) {
                    if (character!.episodeNumbers.count == 1) {
                        let response = try await EpisodesRepository.shared.getEpisode(episode: character!.episodeNumbers.first!)
                        parsedEpisodes.append(response.toModel())
                    } else {
                        let response = try await EpisodesRepository.shared.getMultipleEpisodes(episodes: character!.episodeNumbers)
                        parsedEpisodes = response.compactMap{ $0.toModel() }
                    }
                    
                    // Refresh table view.
                    self.episodesToDisplay = parsedEpisodes
                }
            }
            catch {
                // TODO: Handle error in a more appropiate way.
                print(error)
                self.displayError(title: "Oops...", message: "Something went wrong when fetching the episodes.")
            }
            
            dismissProgressHUD()
        }
    }
    
}
