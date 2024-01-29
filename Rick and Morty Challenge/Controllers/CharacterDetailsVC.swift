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
        
        setupViews()
        populateCharacter()
    }
    
    // We'll fetch the episodes for this character as soon as we populate the view.
    override func viewWillAppear(_ animated: Bool) {
        Task { @MainActor in
            fetchEpisodes()
        }
    }
    
    
    // MARK: Initialization functions.
    
    func setupViews() {
        // Set navigation bar icons color to black.
        navigationController?.navigationBar.tintColor = ColorsPalette.appBlue
        
        // Character image view.
        characterImageView.layer.cornerRadius = 8
        characterImageView.layer.borderWidth = 2.0
        characterImageView.layer.borderColor = ColorsPalette.appYellow.cgColor
        characterImageView.layer.masksToBounds = true
        
        // Episodes table view.
        episodesTableView.dataSource = self
        episodesTableView.allowsSelection = false
    }
    
    func populateCharacter() {
        guard let character = character else {
            // TODO: Handle error in a more appropiate way.
            self.displayAlertWithMessage(message: "Invalid Character!", toShowCancel: true)
            return
        }
        
        // We use Kingfisher to load and set the character's image.
        if let imageUrl = URL(string: character.imageUrl) {
            characterImageView.kf.setImage(with: imageUrl)
        }
        
        // Setup character name.
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeWidth: -3.0,
            NSAttributedString.Key.strokeColor: ColorsPalette.appYellow
        ]
        let attributedString = NSAttributedString(string: character.name, attributes: attributes)
        characterNameLabel.attributedText = attributedString
        
        // Remaining labels.
        characterStatusLabel.text = "• STATUS: \(character.status.outputName)"
        characterSpecieLabel.text = "• SPECIE: \(character.specie)"
        characterOriginLabel.text = "• ORIGIN: \(character.origin.name)"
        characterLastLocationLabel.text = "• LAST LOCATION: \(character.lastLocation.name)"
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
