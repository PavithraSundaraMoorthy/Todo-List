//
//  CategoryViewController.swift
//  Todo List
//
//  Created by Pavithra Pravinkumar on 5/22/18.
//  Copyright © 2018 Pavithra Pravinkumar. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController{

    let realm = try! Realm()
    
    var categoryList : Results<Category>?
    
    override func viewDidLoad() {
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        super.viewDidLoad()
        load()
    }

    //MARK: - Add New Category
    
 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new Category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Datasource method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
      
        cell.textLabel?.text = categoryList?[indexPath.row].name ?? "No Categories Added yet"
       
        cell.accessoryType = .disclosureIndicator
        
        return cell
        
    }
   
    //MARK: - TableView Delegates method
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryList?[indexPath.row]
        }
        
        
    }
    
    //MARK: - Data Manipulation method
    
    func save(category: Category){
        
        do{
            try  realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func load(){

        categoryList = realm.objects(Category.self)
        
        tableView.reloadData()

    }
    

}
