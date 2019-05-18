//
//  CustomTableViewCell.swift
//  EisenOK
//
//  Created by Ярослав  on 17.07.2018.
//  Copyright © 2018 UkropSoft. All rights reserved.
//  Класс для костомизации TableViewCell экрана списка проектов

import UIKit

class CustomTableViewCellProject: UITableViewCell {

    @IBOutlet weak var iconProject: UIImageView!
    @IBOutlet weak var nameProject: UILabel!
    @IBOutlet weak var infoCompleteTask: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
