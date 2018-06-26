//
//  ViewController.swift
//  Todoey
//
//  Created by Ali Aljoubory on 06/06/2018.
//  Copyright © 2018 Ali Aljoubory. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add a new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            
            if let currentCategory = self.selectedCategory {
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textfield.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
            } catch {
                print("Error adding items, \(error)")
            }
        }
            
            self.tableView.reloadData()
            
    }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Todoey"
            textfield = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Methods
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

    }

}

    //MARK: Search Bar Methods

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
        }
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
