//
//  StatisticsViewController.swift
//  EisenOK
//
//  Created by Ярослав  on 03.07.2018.
//  Copyright © 2018 UkropSoft. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Прячем обводку у TabBar
        //self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        self.tabBarController?.tabBar.clipsToBounds = true
        
        
    }
    
    
    @IBAction func sliderAction(_ sender: UISlider) {
        
     
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
