//
//  ProjectViewController.swift
//  EisenOK
//
//  Created by Ярослав  on 14.06.2018.
//  Copyright © 2018 UkropSoft. All rights reserved.
//  Класс отображения списка проектов

import UIKit
import CoreData
import Foundation

class ProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var projects = [Project]()
    var filteredProject: [Project] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Прячем обводку у TabBar
        self.tabBarController!.tabBar.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        self.tabBarController?.tabBar.clipsToBounds = true
        
        // Удаление полосок в таблице
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true // Navigation bar large titles
            navigationItem.title = "Проекты"
            
            // Setup the Search Controller
            navigationItem.hidesSearchBarWhenScrolling = true
            searchController.searchResultsUpdater = self as? UISearchResultsUpdating
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Поиск"
            navigationItem.searchController = searchController
            definesPresentationContext = true
            
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadCoreData()
        self.tableView.reloadData()
    }
    
    // MARK: Loading Project
    
    func loadCoreData() {
        
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        do {
            self.projects = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(fetchRequest)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            print(String(format: "Error %@: %d",#file, #line))
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredProject = projects.filter({( project : Project) -> Bool in
            return (project.name?.lowercased().contains(searchText.lowercased()))!
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
   // MARK: - Action
    
    // MARK: Кнопка удаления всех проектов и задач
    @IBAction func removeAllData(_ sender: Any) {
        
        if projects.count != 0 {
            
            let alert: UIAlertController =
                UIAlertController(title: "Внимание!", message: "Удалить все проекты?", preferredStyle:  UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction =
                UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                    (action: UIAlertAction!) -> Void in
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    for obj in self.projects {
                        context.delete(obj)
                    }
                    do {
                        try context.save()
                    } catch {
                        print(String(format: "Error %@: %d",#file, #line))
                    }
                    self.projects = [Project]()
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
        
    }
    
    // MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering() ? filteredProject.count : self.projects.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCellProject
        
        let entry = self.isFiltering() ? filteredProject[indexPath.row] : projects[indexPath.row]
        let iconProject = UIImage(named: entry.iconName!)
        
        cell.nameProject.text = entry.name
        cell.infoCompleteTask.text = entry.date
        cell.iconProject.image = iconProject
        
        return cell
    }

    
        // MARK: Кнопки свайпа по задачи
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // ----- Вытягиваем текущее имя проекта
        
        let nameProjectSelect = self.isFiltering() ? self.filteredProject[indexPath.row].name : self.projects[indexPath.row].name

        //MARK: - Cвайп "Переименовать проект"
        
        let rename = UITableViewRowAction(style: .default, title: "      ") { (action, indexPath) in

            // Окно сообщения ввода имени обьекта
            let alert = UIAlertController(title: "Переименовывание проекта",
                                          message: "Введите новое имя проекта",
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
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
                    let predicate = NSPredicate(format: "name = %@" , nameProjectSelect! )
                    fetchRequest.predicate = predicate

                    do {
                        let fetchedEntities = try context.fetch(fetchRequest) as! [Project]
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

        // MARK: - Cвайп "Удалить проект"
        
        let delete = UITableViewRowAction(style: .default, title: "      ") { (action, indexPath) in
            
            let alert: UIAlertController =
                UIAlertController(title: "Внимание!", message: "Удалить проект с именем \n \(String(describing: nameProjectSelect))?", preferredStyle:  UIAlertControllerStyle.alert)
            
            let defaultAction: UIAlertAction =
                UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{
                    (action: UIAlertAction!) -> Void in
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

                    let item = self.isFiltering() ? self.filteredProject[indexPath.row] : self.projects[indexPath.row]
                    
                    context.delete(item)
                    
                    self.isFiltering() ? self.filteredProject.remove(at: indexPath.row) : self.projects.remove(at: indexPath.row)
                    
                    do {
                        try context.save()
                        } catch {
                                print(String(format: "Error %@: %d",#file, #line))
                                    }
                    
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self.loadCoreData()
                    self.tableView.reloadData()
                    
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

        //===== Костомизация кнопка
        let backView = UIView(frame: CGRect(x: 0 , y: 0, width: 65, height: 75))
        backView.layer.shadowPath = UIBezierPath(roundedRect: backView.bounds, cornerRadius: 12).cgPath
        backView.layer.shadowColor =  #colorLiteral(red: 0.1866586804, green: 0.2055505216, blue: 0.2376019955, alpha: 0.5)
        backView.layer.shadowOpacity = 1
        backView.layer.shadowRadius = 5
        backView.layer.cornerRadius = 12
        backView.layer.shadowOffset = CGSize(width: 0, height: 5)
        backView.layer.bounds = backView.bounds
        backView.layer.position = backView.center
        backView.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.7921568627, blue: 0.5764705882, alpha: 1)
        backView.layer.contentsGravity = kCAGravityResize

        //------

        let myImage = UIImageView(frame: CGRect(x: 20 , y: backView.frame.size.height/2-15, width: 30, height: 30))

    
        myImage.image = #imageLiteral(resourceName: "trashit")
        backView.addSubview(myImage)
        

        let imgSize: CGSize = tableView.frame.size
        UIGraphicsBeginImageContextWithOptions(imgSize, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        backView.layer.render(in: context!)


        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //
        let renameBackView = UIView(frame: CGRect(x: 0 , y: 0, width: 65, height: 75))
        renameBackView.layer.shadowPath = UIBezierPath(roundedRect: renameBackView.bounds, cornerRadius: 12).cgPath
        renameBackView.layer.shadowColor =  #colorLiteral(red: 0.1866586804, green: 0.2055505216, blue: 0.2376019955, alpha: 0.5)
        renameBackView.layer.shadowOpacity = 1
        renameBackView.layer.shadowRadius = 5
        renameBackView.layer.cornerRadius = 12
        renameBackView.layer.shadowOffset = CGSize(width: 0, height: 5)
        renameBackView.layer.bounds = renameBackView.bounds
        renameBackView.layer.position = renameBackView.center
        renameBackView.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.7921568627, blue: 0.5764705882, alpha: 1)
        renameBackView.layer.contentsGravity = kCAGravityResize
        //------
        let renameImage = UIImageView(frame: CGRect(x: 20 , y: renameBackView.frame.size.height/2-15, width: 30, height: 30))
        
        
        renameImage.image = #imageLiteral(resourceName: "edit")
        renameBackView.addSubview(renameImage)
        
        let renameImgSize: CGSize = tableView.frame.size
        UIGraphicsBeginImageContextWithOptions(renameImgSize, false, UIScreen.main.scale)
        let renameContext = UIGraphicsGetCurrentContext()
        renameBackView.layer.render(in: renameContext!)
        
        
        let newRenameImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        


        rename.backgroundColor = UIColor(patternImage: newRenameImage)
        
        delete.backgroundColor = UIColor(patternImage: newImage)
        
        return [delete, rename]

    }
    

    //MARK: Метод передачи названия проекта при помощи Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Если нажат определённый проект, передаётся его название
        if segue.identifier == "TaskView" {
            let taskView:TaskView = segue.destination as! TaskView
            
            let nameProjectSelect = self.isFiltering() ? self.filteredProject[(self.tableView.indexPathForSelectedRow?.row)!] : self.projects[(self.tableView.indexPathForSelectedRow?.row)!]
            
            taskView.project = nameProjectSelect
            taskView.title = nameProjectSelect.name
            
        }
        // Если нажата кнопка "Все задачи" то название проекта не передаётся и загружается весь список задач
        else if segue.identifier == "AllTaskView" {
            let taskView:TaskView = segue.destination as! TaskView
            taskView.project = nil
        }
    }

    
}

//MARK: Search

extension ProjectViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
    }
}






