//
//  TableViewCell.swift
//  TestExcApp
//
//  Created by Kisa Shket on 17.01.2021.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewContainer: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
