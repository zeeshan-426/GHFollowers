//
//  FavoritesListViewController.swift
//  GHFollowers
//
//  Created by user on 30/06/2026.
//

import UIKit

class FavoritesListViewController: UIViewController {
    
    // ---------------------------------------------------------
    // MARK: - Concept: UITableView vs UICollectionView
    // ---------------------------------------------------------
    // A UITableView is just a single column list. It's much simpler than a CollectionView.
    // Instead of a DiffableDataSource, we will use the "Old School" delegate and datasource approach
    // because it is still heavily used in the industry for TableViews.
    let tableView = UITableView()
    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    // We use viewWillAppear instead of viewDidLoad for retrieving favorites.
    // Why? Because if the user adds a favorite on the search screen, and then taps the Favorites tab,
    // we need the screen to refresh EVERY TIME it appears, not just the first time it loads!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    // ---------------------------------------------------------
    // MARK: - Configuration
    // ---------------------------------------------------------
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        // The tableview should take up the whole screen
        tableView.frame = view.bounds
        tableView.rowHeight = 80 // Same as our CollectionView cells!
        
        // WE ARE THE BOSS: We promise to provide the data and handle taps
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register our new cell so the tableview knows what UI to draw
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
        
        // Remove empty cells below our list
        tableView.tableFooterView = UIView()
    }
    
    // ---------------------------------------------------------
    // MARK: - Data Retrieval
    // ---------------------------------------------------------
    func getFavorites() {
        PersistanceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorites):
                // If they have no favorites, show our beautiful empty state view
                if favorites.isEmpty {
                    self.showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen.", in: self.view)
                } else {
                    // Otherwise, save the favorites to our array and reload the table
                    self.favorites = favorites
                    
                    // Always reload UI on the Main Thread!
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        // Ensure the table view is brought to the front over the empty state view if it exists
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

// ---------------------------------------------------------
// MARK: - UITableViewDataSource & Delegate Protocols
// ---------------------------------------------------------
extension FavoritesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // The TableView asks: "How many rows should I draw?"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    // The TableView asks: "What should each cell look like?"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue means "reuse a cell that scrolled off the screen" to save memory!
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    // The TableView asks: "What should happen when they tap a cell?"
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        
        // Re-use our FollowersListViewController and pass it the favorite's username!
        let destVC = FollowersListViewController()
        destVC.username = favorite.login
        destVC.title = favorite.login
        
        // Push the new screen onto the stack
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    // ---------------------------------------------------------
    // MARK: - Swipe to Delete
    // ---------------------------------------------------------
    // By adding this single function, Apple magically adds the "Swipe Left to Delete" animation!
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Make sure the user actually performed a delete swipe
        guard editingStyle == .delete else { return }
        
        // Grab the favorite they swiped on
        let favorite = favorites[indexPath.row]
        
        // 1. Delete it from our array FIRST (Always update the data model before the UI)
        favorites.remove(at: indexPath.row)
        
        // 2. Delete the row visually from the TableView with a nice animation
        tableView.deleteRows(at: [indexPath], with: .left)
        
        // 3. Permanently remove it from UserDefaults!
        PersistanceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            
            // If deleting from UserDefaults fails, tell the user
            guard let error = error else { return }
            self.presentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}
