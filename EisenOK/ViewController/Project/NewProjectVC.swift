//
//  NewProjectVC.swift
//  EisenOK
//
//  Created by Ярослав  on 17.07.2018.
//  Copyright © 2018 UkropSoft. All rights reserved.
//  Класc ViewController для создания нового проекта

import UIKit
import CoreData



class NewProjectVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var nameProject: UITextView!
    @IBOutlet weak var noteProject: UITextView!
    @IBOutlet weak var labelIcon: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var item = [Project]()
    
    //Массив имён иконок
    let iconNameArray = ["iconMisc",
                         "iconStudy",
                         "iconWork",
                         "iconMisc",
                         "iconStudy",
                         "iconWork"]
    
    let reuseIdentifier = "collectionViewCellId"
    
    //--- Переменная для имени иконки
    //var iconNameText: String?
    
    var placeholderNameProject = "Введите имя проекта"
    var placeholderNoteProject = "Введите краткое описание проекта..."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Отображение в TextView Placeholder
        nameProject.placeholder = placeholderNameProject
        noteProject.placeholder = placeholderNoteProject
       
        print("✅ Экран нового проекта  viewDidLoad")
        
        self.hideKeyboardWhenTappedAround() 
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("✅ Экран нового проекта  viewWillAppear")
        
        self.loadCoreData()
   
    }
   
    
    //MARK: Метод загрузки данных
    func loadCoreData() {
        
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        do {
            self.item = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(String(format: "Error %@: %d",#file, #line))
        }
        
        print("✅ Экран нового проекта loadCoreData (загрузка данных)")
    }

    
    //Создания нового проекта (сохранение)
    @IBAction func saveProject(_ sender: UIBarButtonItem) {
        
        print("✅ Экран нового проекта кнопка СОХРАНИТЬ ПРОЕКТ")
        
        // Проверка на ввод названия проекта
        if (nameProject.text!.isEmpty) || nameProject.text == "" {
            
            let alert = UIAlertController(title: "Внимание!!!", message: "Введите название проекта", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in})
            self.present(alert, animated: true, completion: nil)
            print("⛔️ Не введено название проекта")
            
        } else {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let project = Project(context: context)
       
            project.name = nameProject.text
            project.note = noteProject.text
            project.iconName = labelIcon.text //это жосткий кастыль 😀
            
            print("✅ Сохранение данных - name: \(String(describing: nameProject.text)) note: \(String(describing: noteProject.text)) iconName: \(String(describing: labelIcon.text))")
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MM/dd/yyyy HH:mm"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        
        project.date = stringOfDate
        
        do {
            try context.save()
            print("👍 Проект сохранён")
        } catch {
            print("⛔️ ОШИБКА!!!", String(format: "Error %@: %d",#file, #line))
        }
        
        self.loadCoreData()
            
        //Закрытие экрана создания проекта
        dismiss(animated: true, completion: nil)
        
        }
    }
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("✅ Экран выбора иконки проекта cellForItemAt")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! IconProjectCell
        
        cell.iconProjectImage.image = UIImage(named: iconNameArray[indexPath.row])
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let printNameIcon = iconNameArray[indexPath.row]
        print("👍 Я выбрал картинку с именем \(printNameIcon) ")
        labelIcon.text = iconNameArray[indexPath.row]
      
    }
    
}

//MARK: Методы для отображения Placeholder в TextView
extension UITextView :UITextViewDelegate
{
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.characters.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
}



