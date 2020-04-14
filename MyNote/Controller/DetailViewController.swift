//
//  DetailViewController.swift
//  MyNote
//
//  Created by trungnghia on 4/13/20.
//  Copyright © 2020 trungnghia. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
   
    @IBOutlet weak var label: UILabel!
    let realm = try! Realm()
    var selectedCategory: Category?
    var detail: Results<Detail>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let number = selectedCategory?.details.count {
            if number == 0 {
                do {
                    try realm.write {
                        let newNote = Detail()
                        newNote.text = ""
                        selectedCategory?.details.append(newNote)
                    }
                } catch {
                    
                }
                label.text = selectedCategory?.details[0].text
            } else {
               label.text = selectedCategory?.details[0].text
            }
        }

    }
    
    func saveText(text: String) {
        do {
            try realm.write {
                selectedCategory?.details[0].text = text
                label.text = text
            }
        } catch {
            print("Error saving Note, \(error)")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
    }
    
    //MARK: - Data manipulation methods
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Edit Note", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
           
            // What will happen once user clicks the Add Item on our UIAlert
            self.saveText(text: textField.text!)
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addTextField { (alertTextField) in
            alertTextField.text = self.label.text!
            textField = alertTextField
            // this print code will appear after pressing addButton
            print("Adding a new Category")
        }
        present(alert, animated: true, completion: nil)
    
    }
    
   
    

}
