//
//  CategoryViewController.swift
//  Todo List
//
//  Created by Pavithra Pravinkumar on 5/22/18.
//  Copyright © 2018 Pavithra Pravinkumar. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController{

    var categoryList = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    //MARK: - Add New Category
    
 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryList.append(newCategory)
            
            self.saveCategories()
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
        
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
         print(categoryList[indexPath.row])
        
        cell.textLabel?.text = categoryList[indexPath.row].name
        
        print(categoryList[indexPath.row])
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
        
    }
   
    
    
    //MARK: - TableView Delegates method
    
    //MARK: - Data Manipulation method
    
    func saveCategories(){
        
        do{
            try  context.save()
        }catch{
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            categoryList = try context.fetch(request)
        }catch{
            
            print("Error fetching the data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
    

}
