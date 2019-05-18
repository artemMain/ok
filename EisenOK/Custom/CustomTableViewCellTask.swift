//
//  CustomTableViewCellTask.swift
//  EisenOK
//
//  Created by Ярослав  on 15.08.2018.
//  Copyright © 2018 UkropSoft. All rights reserved.
//

import UIKit

class CustomTableViewCellTask: UITableViewCell {
    
    @IBOutlet weak var nameTask: UILabel!
    @IBOutlet weak var dateTask: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
