//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Ali Aljoubory on 18/06/2018.
//  Copyright © 2018 Ali Aljoubory. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
                
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Todoey categories added"
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "goToItems", sender: self)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TodoListViewController")
        
//        if let indexPath = tableView.indexPathForSelectedRow {
//            vc.selectedCategory = categoryArray?[indexPath.row]
//        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let destinationVC = segue.destination as! TodoListViewController
//
//        if let indexPath = tableView.indexPathForSelectedRow {
//            destinationVC.selectedCategory = categoryArray?[indexPath.row]
//        }
//    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category : Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        
       tableView.reloadData()
    }
    
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add a new Todoey category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textfield.text!
            
            self.save(category : newCategory)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Todoey category"
            textfield = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    
    }

    
}
