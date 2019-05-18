//
//  IconProjectCell.swift
//  EisenOK
//
//  Created by Ярослав  on 24.07.2018.
//  Copyright © 2018 UkropSoft. All rights reserved.
//

import UIKit

class IconProjectCell: UICollectionViewCell {
    

    @IBOutlet weak var iconProjectImage: UIImageView!
    //Метод отслеживания нажатия/отжатия на иконку (можно добавить анимацию при нажатии)
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                // Долгое нажатие
                // print("👍 yes")
                
            } else {
                // Отжатие (убрал палец с иконки)
                // print("👎no")
                
            }
        }
    }
    
    //---
    
    //Метод конкретно отслеживания нажатияна иконку (можно добавить анимацию при нажатии)
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.contentView.backgroundColor = #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)
                //self.iconProjectImage.isHidden = false
            }
            else
            {
                self.transform = CGAffineTransform.identity
                self.contentView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
                //self.iconProjectImage.isHidden = true
            }
        }
    }
    
}
