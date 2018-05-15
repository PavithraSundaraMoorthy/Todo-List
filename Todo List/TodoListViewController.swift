//
//  ViewController.swift
//  Todo List
//
//  Created by Pavithra Pravinkumar on 5/15/18.
//  Copyright © 2018 Pavithra Pravinkumar. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Buy apple","Go Gym","call Appa"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK - TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(indexPath.row)
       //print(itemArray[indexPath.row])
       
        
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    


}

