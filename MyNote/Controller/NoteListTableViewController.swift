//
//  NoteListTableViewController.swift
//  MyNote
//
//  Created by trungnghia on 4/13/20.
//  Copyright © 2020 trungnghia. All rights reserved.
//

import UIKit
import RealmSwift

class NoteListTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        load()
    }
    
    
    //MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
        }
        return cell
    }
    
    //MARK: - Add a new category
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Note", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Note", style: .default) { (action) in
            
            // What will happen once user clicks the Add Item on our UIAlert
            let newCategory = Category()
            newCategory.name = textField.text!
            //Do not appending because Results auto-updating
            self.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new Category"
            textField = alertTextField
            // this print code will appear after pressing addButton
            print("Adding a new Category")
        }
        present(alert, animated: true, completion: nil)
    
    }
    
    
    //MARK: - Data manipulation methods
    func load() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        tableView.reloadData()
    }
    
    // Delete category and item inside
    override func updateModal(at indexPath: IndexPath) {
        if let categoryForDeletion = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion.details[0])
                    realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
        
    }
    
    // Edit category
    override func editModal(at indexPath: IndexPath) {
        if let categoryForEdit = categories?[indexPath.row] {
            var textField = UITextField()
            let alert = UIAlertController(title: "Edit Note", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                do {
                    try self.realm.write {
                        if textField.text != "" {
                            categoryForEdit.name = textField.text!
                        }
                    }
                } catch {
                    print("Error editting category, \(error)")
                }
                self.tableView.reloadData()
            }
            alert.addAction(action)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            alert.addTextField { (alertTextField) in
               alertTextField.placeholder = "Edit category"
               textField = alertTextField

            }
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        } 
    }
}

//MARK: - Search bar methods
extension NoteListTableViewController: UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            print("Search pressed....")
            categories = categories?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
            tableView.reloadData()
        }
        
        // Return all list if searchText empty
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText == "" {
                load()
                // Bring searchBar to foreground and then resign it
                DispatchQueue.main.async {
                   searchBar.resignFirstResponder()
                }
            }
        }
}
