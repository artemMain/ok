//
//  ShowTaskViewController.swift
//  EisenOK
//
//  Created by Артём Гусев on 06.07.2018.
//  Copyright © 2018 UkropSoft. All rights reserved.
//

import UIKit
import CoreData

class ShowTaskViewController: UIViewController{

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    var item = [Task]()
    
    var name = ""
    var note = ""
    var category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = name
        print (name, note, category)
        noteLabel.text = note
        categoryLabel.text = category
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
