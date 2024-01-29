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
        
        // Setup views.
        setupSearchTextField()
        setupSortBySegmentControl()
        setupCharactersTableView()
        
        // Enable pull-to-refresh functionality to the charactersTableView.
        configureRefresher()
    }
    
    // We'll fetch the first page of characters as soon as we populate the view.
    override func viewWillAppear(_ animated: Bool) {
        Task { @MainActor in
            fetchCharacters()
        }
    }

    
    // MARK: Initialization functions.
    
    private func setupSearchTextField() {
        // Styling.
        searchByNameTextField.layer.cornerRadius = 8
        searchByNameTextField.layer.masksToBounds = true
        
        // Delegate.
        searchByNameTextField.delegate = self
        
        // Add listener to update the characters list when entering a new value.
        searchByNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupSortBySegmentControl() {
        // Set text color.
        sortBySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ColorsPalette.whiteColor], for: .selected)
        sortBySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ColorsPalette.statusGray], for: .normal)
        sortBySegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    private func setupCharactersTableView() {
        charactersTableView.dataSource = self
        charactersTableView.delegate = self
        
        // Register a placeholder footer view to create some spacing between cells.
        charactersTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "SpacerFooterView")
    }
    
    
    // MARK: IBActions functions.
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Set a 1 second delay before searching again.
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchCharactersByName), object: nil)
        perform(#selector(searchCharactersByName), with: nil, afterDelay: 1)
    }
    
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
        Task { @MainActor in
            showProgressHUD()
            
            do {
                // We read the filter text field first.
                let filterByNameString = searchByNameTextField.text ?? ""
                
                let response = try await CharactersRepository.shared.getCharactersPage(
                    page: currentPage,
                    characterName: filterByNameString
                )
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
    
    @objc func searchCharactersByName() {
        // We wanna do a search only if we've entered at least two characters.
        if (searchByNameTextField.text?.count != 1) {
            // Reset the current page first.
            currentPage = 1
            
            fetchCharacters()
        }
    }

}

