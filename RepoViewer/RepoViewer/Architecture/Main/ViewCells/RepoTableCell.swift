//
//  RepoTableCell.swift
//  RepoViewer
//
//  Created by Victor Mihaita on 04/11/2018.
//  Copyright © 2018 Victor Mihaita. All rights reserved.
//

import UIKit

class RepoTableCell: UITableViewCell, Reusable, NibLoadable {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var isPrivateBadgeView: UIImageView!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func config(with repo: Repository) {
        nameLabel.text = repo.name

        if let desc = repo.description {
            descriptionLabel.isHidden = false
            descriptionLabel.text = desc
        } else {
            descriptionLabel.isHidden = true
        }

        if let languages = repo.languages {
            var languagesString = ""
            languages.forEach { language in
                if let name = language.name {
                    languagesString += "\(name)   "
                }
            }
            languagesLabel.isHidden = false
            languagesLabel.text = languagesString.uppercased()
        } else {
            languagesLabel.isHidden = true
        }

        if let stars = repo.stars {
            starCountLabel.text = "\(stars)"
        }

        starCountLabel.isHidden = repo.stars > 0 ? false : true
        starImageView.image = repo.stars > 0 ? #imageLiteral(resourceName: "icon_star") : #imageLiteral(resourceName: "icon_star_empty")
        isPrivateBadgeView.isHidden = repo.isPrivate ? false : true

    }
    
}
