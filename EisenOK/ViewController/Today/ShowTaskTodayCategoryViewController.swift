//
//  ShowTaskTodayViewController.swift
//  EisenOK
//
//  Created by Ярослав  on 19.06.2018.
//  Copyright © 2018 UkropSoft. All rights reserved.
//

import UIKit
import CoreData

class ShowTaskTodayCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //@IBOutlet weak var nameCategoryBar: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countTasks: UILabel!
    
    public var project : Project? = nil
    var item = [Task]() // это для отображения задач
    var filteredData: [Task] = [] // это я так понял для фильтрации
    var StoredResults = [NSManagedObject]()
    
    var textToShow = ""

    override func viewDidLoad() {
        super.viewDidLoad()
       
        //--- Присваиваем имя Бару
        //self.nameCategoryBar.text = textToShow
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.loadCoreData() // обновление таблицы
        self.tableView.reloadData()
    }

    //MARK: Метод загрузки данных
    func loadCoreData() {
     
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        // Определяем по какому атрибуту искать
        let predicate =  NSPredicate(format:"category == %@", textToShow)
        request.predicate = predicate
        
        do {
            let results =
                try context.fetch(request)
            
            StoredResults = results as! [NSManagedObject]
            
            item = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(request) as! [Task]
            filteredData = item
            
            print("👍 Категория: Срочно - Важно  Задач: \(StoredResults.count)")
            
        } catch let error as NSError {
            print("⛔️ error executing fetchrequest  ", error)
        }
        //Выводим результат
        let coutTask = StoredResults.count
        countTasks.text = "Задач: \(coutTask)"
        
    }
    
    //Кнопка назад
    @IBAction func backButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    //Отображение таблицы с списком задач (имя, время)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCellTask
        
        cell.nameTask!.text = filteredData[indexPath.row].name
        cell.dateTask!.text = String(describing: filteredData[indexPath.row].date!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //performSegue(withIdentifier: "showTaskSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
   

}
