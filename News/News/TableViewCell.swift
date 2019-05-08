//
//  TableViewCell.swift
//  News
//
//  Created by Bohdan Datskiv on 5/6/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    weak var delegate: arrowButtonTappedDelegate?

    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var isSeenButton: UIButton!
    @IBOutlet weak var imageOfArticle: UIImageView!
    @IBOutlet weak var articleSourceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func arrowButtonTapped(_ sender: UIButton) {
       // print("work")
        delegate?.arrowButtonTapped(for: self)
    }
    
}

protocol arrowButtonTappedDelegate: class {
    func arrowButtonTapped(for cell: TableViewCell)
}
