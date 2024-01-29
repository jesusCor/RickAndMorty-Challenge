//
//  ViewController.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 26/01/2024.
//

import UIKit


enum SortByStatus {
    case name, popularity
}


class CharactersListVC: BaseVC {
    
    @IBOutlet weak var searchByNameTextField: UITextField!
    @IBOutlet weak var sortBySegmentedControl: UISegmentedControl!
    @IBOutlet weak var charactersTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    static let spacingBetweenCells = 10.0
    
    var refresher: UIRefreshControl!
    
    var charactersToDisplay: [Character] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.charactersTableView.reloadData()
                self?.noDataLabel.isHidden = !(self?.charactersToDisplay.isEmpty ?? false)
            }
        }
    }
    
    var selectedSortBy: SortByStatus {
        return (sortBySegmentedControl.selectedSegmentIndex == 0)
            ? .name
            : .popularity
    }
    
    
    // MARK: VC lifecycle functions.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation title.
        navigationItem.title = "Characters"
        
        // Setup styling & delegates.
        setupStandardsCheckSegmentControl()
        charactersTableView.dataSource = self
        charactersTableView.delegate = self
        
        // Register a placeholder footer view to create some spacing between cells.
        charactersTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "SpacerFooterView")
        
        // Enable pull-to-refresh functionality to the charactersTableView.
        configureRefresher()
    }

    
    // MARK: Initialization functions.
    
    private func setupStandardsCheckSegmentControl() {
        // Set text color.
        sortBySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ColorsPalette.whiteColor], for: .selected)
        sortBySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ColorsPalette.statusGray], for: .normal)
        sortBySegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    
    // MARK: IBActions functions.
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if (selectedSortBy == .name) {
            // TODO: Sort by name & go to the top of the table view.
            charactersTableView.scrollToTop()
        } else {
            // TODO: Sort by popularity & go to the top of the table view.
            charactersTableView.scrollToTop()
        }
    }
    
    // To allow ourselves to do a pull-to-refresh on the charactersTableView.
    func configureRefresher() {
        refresher = UIRefreshControl()
        refresher.addTarget( self, action: #selector(self.refresh(_:)), for: UIControl.Event.valueChanged)
        refresher.tintColor = .white
        charactersTableView.addSubview(refresher)
    }
    
    
    // MARK: Characters functions.
    
    func fetchCharacters(byPullDownToRefresh: Bool = false) {
        
        // TODO: Handle the sort by mechanicsm.
        
        Task { @MainActor in
            showProgressHUD()
            
            do {
                // TODO: Adapt pagination & take into account that pages starts with 1.
                let response = try await CharactersRepository.shared.getCharactersPage(page: 1)
                let parsedCharacters = response.results.compactMap{ $0.toModel() }
                
                // Refresh table view.
                if (!parsedCharacters.isEmpty) {
                    self.charactersToDisplay = parsedCharacters
                }
            }
            catch {
                // TODO: Handle error in a more appropiate way.
                print(error)
                self.displayError(title: "Oops...", message: "Something went wrong when fetching the characters.")
            }
            
            // Make sure that the refresh functionality is finished.
            if (byPullDownToRefresh) {
                self.refresher.endRefreshing()
            }
            
            dismissProgressHUD()
        }
    }
    
    // It'll get called when doing a pull-to-refresh.
    @objc func refresh(_ sender: Any? = nil) {
        fetchCharacters(byPullDownToRefresh: true)
    }

}

