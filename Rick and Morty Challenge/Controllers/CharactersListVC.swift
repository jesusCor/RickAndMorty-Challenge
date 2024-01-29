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
    
    // To handle pagination.
    var currentPage: Int = 1
    var lastPageReached: Bool = false
    
    static let spacingBetweenCells = 10.0
    
    var refresher: UIRefreshControl!
    
    var fetchedCharacters: [Character] = [] {
        didSet {
            sortCharacters()
        }
    }
    var sortedCharacters: [Character] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.charactersTableView.reloadData()
                self?.noDataLabel.isHidden = !(self?.sortedCharacters.isEmpty ?? false)
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
        // Sort the list of characters first.
        sortCharacters()
        
        // Scroll the table view to the top.
        charactersTableView.scrollToTop()
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
                let response = try await CharactersRepository.shared.getCharactersPage(page: currentPage)
                let parsedCharacters = response.results.compactMap{ $0.toModel() }
                
                // Refresh table view.
                if (currentPage == 1) {
                    self.fetchedCharacters = parsedCharacters
                } else {
                    self.fetchedCharacters.append(contentsOf: parsedCharacters)
                }
                
                // Update what page we've reached so far to allow us to keep scrolling down to fetch more data.
                if (currentPage == response.info.pages && response.info.next == nil) {
                    lastPageReached = true
                } else {
                    currentPage += 1
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
        // Reset the current page first, as we've scrolled to the top.
        currentPage = 1
        
        fetchCharacters(byPullDownToRefresh: true)
    }
    
    // We'll call this function every time we update the sortBy segmented control.
    func sortCharacters() {
        if (selectedSortBy == .name) {
            // Sort by name.
            self.sortedCharacters = fetchedCharacters.sorted{ $0.name < $1.name }
        } else {
            // Sort by popularity.
            self.sortedCharacters = fetchedCharacters.sorted{ $0.popularity > $1.popularity }
        }
    }

}

