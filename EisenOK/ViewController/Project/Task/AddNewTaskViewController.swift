//
//  AddNewTaskViewController.swift
//  EisenOK
//
//  Created by Ярослав  on 19.06.2018.
//  Copyright © 2018 UkropSoft. All rights reserved.
//


import UIKit
import CoreData

class AddNewTaskViewController: UIViewController {

    public var project : Project? = nil
    
    var item = [Task]()
    
    var filteredData: [Task] = []
    
    var categoryArray:[String] = Array() // Категории
    
    @IBOutlet weak var nameTaskTF: UITextView!
    @IBOutlet weak var noteTaskTF: UITextView!
    
    @IBOutlet weak var categoryTaskTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryArray.append("Нет")
        categoryArray.append("Срочно - Важно")
        categoryArray.append("Срочно - Не важно")
        categoryArray.append("Не срочно - Важно")
        categoryArray.append("Не срочно - Не важно")
        
        //Вызываем метод которая по тапу на Заметки отображает Picker
        choiceUiElement()
        
        //Вызываем метод добавления ToolBar в PickerView
        createToolBar()
        
        self.hideKeyboardWhenTappedAround() 
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.loadCoreData()
    }
    
    func loadCoreData() {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        if self.project != nil {
            fetchRequest.predicate = NSPredicate(format: "project = %@", self.project!)
        }
        do {
            // Отображать весь список задач без имение проекта
            self.item = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(fetchRequest)
            
        } catch {
            print(String(format: "Error %@: %d",#file, #line))
        }
        
    }
    
    //Функция которая по тапу на Категория отображает Picker
    func choiceUiElement() {
        let elementPicker = UIPickerView()
        elementPicker.delegate = self
        
        categoryTaskTF.inputView = elementPicker
        
        //Костомизация
        elementPicker.backgroundColor = .white
        
    }
    
    
    //Розмещение ToolBar и его вид
    func createToolBar() {
        let toolBar = UIToolbar()
        //Размещение по размаеру View
        toolBar.sizeToFit()
        //Кнопка "Закрыть"
        let doneButton = UIBarButtonItem.init(title: "Закрыть",
                                              style: .plain,
                                              target: self,
                                              action: #selector (dismissKeybord))
        //Размещаем кнопку
        toolBar.setItems([doneButton], animated: true)// !масив, можно добавлять ещё кнопки
        // Позволяем взаимодействовать пользователю с данным элементом
        toolBar.isUserInteractionEnabled = true
        // Таб по categoryTaskTF
        categoryTaskTF.inputAccessoryView = toolBar
        
        //Костомизация
        toolBar.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        toolBar.barTintColor = #colorLiteral(red: 0.8887288455, green: 0.8887288455, blue: 0.8887288455, alpha: 1)
        
    }
    
    // Selector закрытие клавиатуры
    @objc func dismissKeybord () {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    //Метод скрытия клавиатуры
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
        
        nameTaskTF.resignFirstResponder()
        noteTaskTF.resignFirstResponder()
        
    }
    
    //Выход из создания задачи
    @IBAction func cencelButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }

    //Кнопка создания новой задачи
    @IBAction func addTask(_ sender: UIButton) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let task = Task(context: context)
        
        if nameTaskTF.text != "" {
            task.name = nameTaskTF.text
            task.note = noteTaskTF.text
            task.category = categoryTaskTF.text
        } else {
            task.name = String(self.item.count+1)
        }
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MM/dd/yyyy HH:mm"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        
        task.date = stringOfDate
        self.project?.addToTask(task)
        
        do {
            try context.save()
            
        } catch {
            print(String(format: "Error %@: %d",#file, #line))
        }
        
        self.loadCoreData()
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddNewTaskViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    //Возращает количество барабанов для использования
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Возращает количество елементов в pickerView согласно елементов в массиве
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return categoryArray.count
        }
        return categoryArray.count
    }
    
    //Позволяет отобрадать в PickerView определённое значение
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return categoryArray[row]
        }
        return categoryArray[row]
    }
    
    //Позволяет работать с выбранным елементом
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let urgencySelected = categoryArray[pickerView.selectedRow(inComponent: 0)]
        
        categoryTaskTF.text = "\(urgencySelected) "
    }
    
    //Внешний вид pickerView
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        //Костомизация отображения
        var pickerViewLabel = UILabel()
        
        if let currentLabel = view as? UILabel {
            pickerViewLabel = currentLabel
        } else {
            pickerViewLabel = UILabel ()
        }
        
        print(self.categoryArray[row])
        
        //Внешний вид каждой категории
        switch row {
        case 0:
            // create attributed string
            pickerViewLabel.textColor = .red
            pickerViewLabel.backgroundColor = .white
            pickerViewLabel.textAlignment = .center
            pickerViewLabel.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 30)
            pickerViewLabel.text = categoryArray[row]
            //Закраашивание View в цвет категории
            //self.view.backgroundColor = UIColor.white
            
        case 1:
            pickerViewLabel.textColor = .white
            pickerViewLabel.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            pickerViewLabel.textAlignment = .center
            pickerViewLabel.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 30)
            pickerViewLabel.text = categoryArray[row]
            
        case 2:
            pickerViewLabel.textColor = .white
            pickerViewLabel.backgroundColor = #colorLiteral(red: 0.168627451, green: 0.768627451, blue: 0.4235294118, alpha: 1)
            pickerViewLabel.textAlignment = .center
            pickerViewLabel.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 30)
            pickerViewLabel.text = categoryArray[row]
            
        case 3:
            pickerViewLabel.textColor = .white
            pickerViewLabel.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.6352941176, blue: 0.9411764706, alpha: 1)
            pickerViewLabel.textAlignment = .center
            pickerViewLabel.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 30)
            pickerViewLabel.text = categoryArray[row]
            
        case 4:
            pickerViewLabel.textColor = .white
            pickerViewLabel.backgroundColor = #colorLiteral(red: 1, green: 0.6549019608, blue: 0.1490196078, alpha: 1)
            pickerViewLabel.textAlignment = .center
            pickerViewLabel.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 30)
            pickerViewLabel.text = categoryArray[row]
        default:
            //It all depends on your datasource, but if you have 0-42 strings(core, APG included) you can just output the rest under default here
            pickerViewLabel.textColor = .white
            pickerViewLabel.backgroundColor = .red
            pickerViewLabel.textAlignment = .center
            pickerViewLabel.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 30)
            pickerViewLabel.text = categoryArray[row]
            
        }
        
        return pickerViewLabel
        
    }
    
    // Высота строки
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60.0
    }
  
}


