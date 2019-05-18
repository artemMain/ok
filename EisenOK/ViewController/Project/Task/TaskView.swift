//
//  TaskView.swift
//  EisenOK
//
//  Created by Ярослав  on 14.06.2018.
//  Copyright © 2018 UkropSoft. All rights reserved.
//

import UIKit
import CoreData

class TaskView: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    
    public var project : Project? = nil
    var selectedIndex: Int!
    
    var item = [Task]() // это для отображения задач
    var filteredData: [Task] = [] // это я так понял для фильтрации

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.loadCoreData() // обновление таблицы
        self.tableView.reloadData()
    }
    
    //MARK: Метод загрузки данных
    func loadCoreData() {

        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        if self.project != nil {
            fetchRequest.predicate = NSPredicate(format: "project = %@", self.project!)
        }
        do {
            // Отображать весь список задач без имение проекта
            item = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(fetchRequest)
            
            filteredData = item
            
            //nameProjectLabel.text = "Задач всего: \(item.count)"
            //Отображение имени проекта в заголовке окна
            self.navigationItem.title = project?.name
            
            //self.tableView.reloadData()
        } catch {
            print(String(format: "Error %@: %d",#file, #line))
        }

    }


    //MARK: Кнопка удаления всех задач
    @IBAction func removeAllData(_ sender: Any) {
        
        let alert: UIAlertController =
            UIAlertController(title: "Внимание!", message: "Удалить все задачи?", preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction =
            UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                (action: UIAlertAction!) -> Void in
                
                //Добираемся до всего контекста содержащего все записи
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                for obj in self.filteredData {
                    context.delete(obj)
                }
                do {
                    try context.save()
                } catch {
                    print(String(format: "Error %@: %d",#file, #line))
                }
                self.filteredData = [Task]()
                self.tableView.reloadData()
            })
        let cancelAction: UIAlertAction =
            UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel, handler:{
                (action: UIAlertAction!) -> Void in
            })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
        
    }
    


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    //Отображение таблицы с списком задач (имя, время)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel!.text = filteredData[indexPath.row].name
        cell.detailTextLabel!.text = String(describing: filteredData[indexPath.row].date!)
        
        return cell
    }
    
    
    //MARK: Кнопки свайпа по задачи
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        selectedIndex = indexPath.row
        
        // Cвайп "Переименовать здачу"
        let rename = UITableViewRowAction(style: .default, title: "Редактировать") { (action, indexPath) in

            //MARK: Окно сообщения ввода имени объекта
            let alert = UIAlertController(title: "Переименовывание задачи",
                                          message: "Введите новое имя задачи",
                                          preferredStyle: .alert)
            
            // Кнопка сохранить в окне соообщения
            let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [unowned self] action in
                
                let textField = alert.textFields?.first
                
                // Сообщение если не введенно имя обьекта
                
                if (textField?.text!.isEmpty)! || textField?.text == "" {
                    print("No Data")
                    
                    let alert = UIAlertController(title: "Внимание!!!", message: "Введите новое название проекта", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                        
                    })
                    
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    //Текущее имя задачи
                    let lastName: String = self.item[indexPath.row].name!
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
                    let predicate = NSPredicate(format: "name = %@" , lastName )
                    fetchRequest.predicate = predicate
                    
                    do {
                        let fetchedEntities = try context.fetch(fetchRequest) as! [Task]
                        fetchedEntities.first?.name = textField?.text
                        
                    } catch {
                        // Do something in response to error condition
                    }
                    
                    do {
                        try context.save()
                    } catch {
                        // Do something in response to error condition
                    }
  
                    self.loadCoreData()
                    self.tableView.reloadData()
                }
                
            }
            
            let cancelAction = UIAlertAction(title: "Отмена",
                                             style: .default)
            
            alert.addTextField()
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
            
        }
        
        //MARK: Cвайп "Удалить задачу"
        let delete = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexPath) in
            // delete item at indexPath
            
            let alert: UIAlertController =
                UIAlertController(title: "Внимание!", message: "Удалить задачу?", preferredStyle:  UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction =
                UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                    (action: UIAlertAction!) -> Void in
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    context.delete(self.item[indexPath.row])
                    do {
                        try context.save()
                    } catch {
                        print(String(format: "Error %@: %d",#file, #line))
                    }
                    
                    self.loadCoreData()
                    
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                })
            let cancelAction: UIAlertAction =
                UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel, handler:{
                    (action: UIAlertAction!) -> Void in
                    self.tableView.reloadData()
                })
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        //кнопка "поделиться"
        let share = UITableViewRowAction(style: .default, title: "Поделиться") { (action, indexPath) in
            // delete item at indexPath
            
            let name = self.item[indexPath.row].name
            let date = self.item[indexPath.row].date
            
            let textShare = "Задача: ''\(name!)'' cоздана: \(date!)"
            
            let sharefal = UIActivityViewController.init(activityItems: [textShare ], applicationActivities: nil)
            self.present(sharefal, animated: true, completion: nil)
            
        }
        
        delete.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
        share.backgroundColor = UIColor(red: 54/255, green: 215/255, blue: 183/255, alpha: 1.0)
        rename.backgroundColor = #colorLiteral(red: 0.03497960791, green: 0.4257493615, blue: 0.9826281667, alpha: 1)
        
        return [delete, share, rename]

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //performSegue(withIdentifier: "showTaskSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: Метод поиска по задачам

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredData = item
            
        } else {
            
            filteredData = item.filter { ($0.name?.lowercased().contains(searchText.lowercased()))! }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }


    //MARK: Метод передачи названия проекта при помощи Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Если нажат определённый проект, передаётся его название
        if segue.identifier == "NewTaskView" {
            let taskView:AddNewTaskViewController = segue.destination as! AddNewTaskViewController
            taskView.project = project
            taskView.title = self.navigationItem.title
            
        }
        
//        if segue.identifier == "UpdateTask" {
//
//            print("Переход на экран обновления")
//
//
//        }
        
        if segue.identifier == "showTaskSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc =  segue.destination as! ShowTaskViewController
                dvc.name = item[indexPath.row].name!
                dvc.note = item[indexPath.row].note!
                dvc.category = item[indexPath.row].category!
            }
        }
            // Если нажата кнопка "Все задачи" то название проекта не передаётся и загружается весь список задач
//        else if segue.identifier == "AllTaskView" {
//            let taskView:TaskView = segue.destination as! TaskView
//            taskView.project = nil
//        }
    }
    
    /////------

}
