//
//  FavoriteCell.swift
//  GHFollowers
//
//  Created by user on 22/07/2026.
//

import UIKit

// ---------------------------------------------------------
// MARK: - Concept: UITableViewCell
// ---------------------------------------------------------
// This is very similar to the FollowerCell we made for UICollectionView!
// The only difference is it inherits from UITableViewCell so it works with TableViews.
class FavoriteCell: UITableViewCell {

    // A static string to identify this cell type when scrolling
    static let reuseID = "FavoriteCell"
    
    // The UI components for our cell
    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 26)
    
    // ---------------------------------------------------------
    // MARK: - Initialization
    // ---------------------------------------------------------
    // TableViewCells are initialized with a style and a reuseIdentifier
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------
    // MARK: - Set Data
    // ---------------------------------------------------------
    // The TableView will call this function to feed a Follower into the cell
    func set(favorite: Follower) {
        usernameLabel.text = favorite.login
        avatarImageView.downloadImage(from: favorite.avatarUrl)
    }
    
    // ---------------------------------------------------------
    // MARK: - Auto Layout Configuration
    // ---------------------------------------------------------
    private func configure() {
        // Add components to the cell's "contentView" (NOT just 'view' like in a ViewController)
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        
        // Let's add a neat little chevron on the right side of the cell so the user knows it's tappable!
        accessoryType = .disclosureIndicator
        
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            // Pin Avatar to the left
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            // Pin Username Label next to Avatar
            usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
