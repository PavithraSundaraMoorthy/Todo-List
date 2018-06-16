//
//  ViewController.swift
//  Todo List
//
//  Created by Pavithra Pravinkumar on 5/15/18.
//  Copyright © 2018 Pavithra Pravinkumar. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var todoItems : Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory : Category? {
        
        didSet{
        
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
 
        //tableView.separatorStyle = .none
       
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        guard let colorHex = selectedCategory?.color else{fatalError()}
            
            updateNavBar(withHexCode: colorHex)
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "39C4F3")
    }
    
    func updateNavBar(withHexCode colorHexCode : String){
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation Bar Doesnt exits")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else{ fatalError()}
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
        
    }
    //MARK - TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:CGFloat(indexPath.row)/CGFloat(todoItems!.count)){
                
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
                
            cell.accessoryType = (item.done)  ? .checkmark : .none
        }else{
            
            cell.textLabel?.text = "No Item Added yet"
        }
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    //        itemArray?[indexPath.row].done = !(itemArray?[indexPath.row].done)!
    //
    //        saveData()
        
        if let item = todoItems?[indexPath.row]{
        do{
            try realm.write {
                item.done = !item.done
            }
        }catch{
            print("Error while updating items, \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
                
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let item = Item()
                        item.title = textField.text!
                        item.dateCreated = Date()
                        currentCategory.items.append(item)
                    }
                }catch{
                    print("Error Saving new items, \(error)")
                    
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
                       
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Create save method
        
    func loadData( ){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

    }
     // MARK: - Create Swipe Delete method
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemDelete = todoItems?[indexPath.row]{
            
            do{
                try realm.write {
                    realm.delete(itemDelete)
                }
            }catch{
                print("Error when item deltes, \(error) ")
            }
            tableView.reloadData()
        }
 
    }
    
}

 //MARK: - Search bar methods

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    
        tableView.reloadData()
    }



    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if(searchBar.text?.count == 0){
            loadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }

}
