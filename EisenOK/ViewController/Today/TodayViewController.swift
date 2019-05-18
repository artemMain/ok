//
//  TodayViewController.swift
//  EisenOK
//
//  Created by Ярослав  on 16.05.2018.
//  Copyright © 2018 UkropSoft. All rights reserved.
//

import UIKit
import CoreData

class TodayViewController: UIViewController {
    
    // Инициализируем Label (отображение каличества задач по категориям)
    @IBOutlet weak var labelCountUrgentImportant: UILabel!
    @IBOutlet weak var labelCountUrgentUnimportant: UILabel!
    @IBOutlet weak var labelCountInurgentImportant: UILabel!
    @IBOutlet weak var labelCountInurgentUnimportant: UILabel!
    
    
    @IBOutlet weak var addTaskVievButton: ANCustomView!
    
    @IBOutlet weak var viewUrgentImportant: UIView!
    @IBOutlet weak var viewUrgentUnimportant: UIView!
    @IBOutlet weak var viewInurgentImportant: UIView!
    @IBOutlet weak var viewInurgentUnimportant: UIView!
    
    
    var item = [Task]()
    
    // Переменные с имением категорий
    var categoryCountUrgentImportant : String = "Срочно - Важно "
    var categoryCountUrgentUnimportant : String = "Срочно - Не важно "
    var categoryCountInurgentImportant : String = "Не срочно - Важно "
    var categoryCountInurgentUnimportant : String = "Не срочно - Не важно "
    
    var StoredResults = [NSManagedObject]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.tabBarController!.tabBar.layer.borderWidth = 0.50 // высота бара
        self.tabBarController!.tabBar.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        self.tabBarController?.tabBar.clipsToBounds = true
        
        //MARK: Нажатия на категорию для отображения списка задач
        //Нажатие Срочно - Важно
        let tapUrgentImportant = UITapGestureRecognizer(target: self, action: #selector(handleTap1))
        viewUrgentImportant.addGestureRecognizer(tapUrgentImportant)
        //Нажатие Срочно - Не важно
        let tapUrgentUnimportant = UITapGestureRecognizer(target: self, action: #selector(handleTap2))
        viewUrgentUnimportant.addGestureRecognizer(tapUrgentUnimportant)
        //Нажатие Не срочно - Важно
        let tapInurgentImportant = UITapGestureRecognizer(target: self, action: #selector(handleTap3))
        viewInurgentImportant.addGestureRecognizer(tapInurgentImportant)
        //Нажатие Не срочно - Не важно
        let tapInurgentUnimportant = UITapGestureRecognizer(target: self, action: #selector(handleTap4))
        viewInurgentUnimportant.addGestureRecognizer(tapInurgentUnimportant)
        
    }
    
    @objc func handleTap1() {
        
        print ("👍 Нажал на категорию Срочно - Важно")

        let nameCategoryTap = categoryCountUrgentImportant
        performSegue(withIdentifier: "ShowTaskCategorySegue", sender: nameCategoryTap)
        
    }
    
    @objc func handleTap2() {
        
        print ("👍 Нажал на категорию Срочно - Не важно")
        
        let nameCategoryTap = categoryCountUrgentUnimportant
        performSegue(withIdentifier: "ShowTaskCategorySegue", sender: nameCategoryTap)
        
    }
    
    @objc func handleTap3() {
        
        print ("👍 Нажал на категорию Не срочно - Важно")
        
        let nameCategoryTap = categoryCountInurgentImportant
        performSegue(withIdentifier: "ShowTaskCategorySegue", sender: nameCategoryTap)
        
    }
    
    @objc func handleTap4() {
        
        print ("👍 Нажал на категорию Не срочно - Не важно")
        
        let nameCategoryTap = categoryCountInurgentUnimportant
        performSegue(withIdentifier: "ShowTaskCategorySegue", sender: nameCategoryTap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: Отображаем количество задач по категориям
        labelCountUrgentImportant.text = String (fetchRequest(categoryName: categoryCountUrgentImportant))
        labelCountUrgentUnimportant.text = String (fetchRequest(categoryName: categoryCountUrgentUnimportant))
        labelCountInurgentImportant.text = String (fetchRequest(categoryName: categoryCountInurgentImportant))
        labelCountInurgentUnimportant.text = String (fetchRequest(categoryName: categoryCountInurgentUnimportant))

    }

    
    //MARK: Метод фильтрации задач по категориям (имя проекта не учитывается)
    func fetchRequest(categoryName : String ) -> Int {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        // Определяем по какому атрибуту искать
        let predicate =  NSPredicate(format:"category == %@", categoryName)
        request.predicate = predicate
        
        do {
            let results =
                try context.fetch(request)
            
            StoredResults = results as! [NSManagedObject]
            print("✅ Категория \(categoryName) Задач \(StoredResults.count)")
            
        } catch let error as NSError {
            print(" error executing fetchrequest  ", error)
        }
        //Выводим результат
        let coutTask = StoredResults.count
        return coutTask
    }

    //Круглая кнопка создания задачи
    @IBAction func addTask(_ sender: UIButton) {
        
        // Анимация при нажатии
        addTaskVievButton.AnimateView()
        
    }

    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? ShowTaskTodayCategoryViewController{
            
            if let selectNameCategory = sender as? String {
                destination.textToShow = selectNameCategory
                print ("👍 Передал имя категории \(selectNameCategory)")
            }
        }
        
        
    }
    

}
