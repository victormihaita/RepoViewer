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
                    languagesString += "\(name), "
                }
            }
            languagesLabel.isHidden = false
            languagesLabel.text = languagesString
        } else {
            languagesLabel.isHidden = true
        }

    }
    
}
