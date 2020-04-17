//
//  ViewController.swift
//  My Do To  List
//
//  Created by Bekir Duran on 27.03.2020.
//  Copyright © 2020 info. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit

class MyToDoListVC: SwipeSuperTableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var itemList:  Results<Items>?
    var selectedCategory : Categories? {
        didSet{
         LoadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Bar error!!!")}
        
        if let navColor = selectedCategory?.CellbgColor{
            if let safeColor = UIColor(hexString: navColor) {
                navBar.backgroundColor = safeColor
                view.backgroundColor = safeColor
                searchBar.barTintColor = safeColor
                searchBar.searchTextField.textColor = safeColor
                searchBar.searchTextField.backgroundColor = ContrastColorOf(safeColor, returnFlat: true)
                navBar.tintColor = ContrastColorOf(safeColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(safeColor, returnFlat: true)]
            }
 
        }
        title = "\(selectedCategory?.name ?? "No Category")"
        
    }
    
// MARK: - Add New Items
    
    @IBAction func AddButton(_ sender: UIBarButtonItem) {
        var textfield = UITextField()

        let alert = UIAlertController(title: "Add New Do To List Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            // what will happen after clicks
            if let currentCategory = self.selectedCategory {
               
                do {
                    try self.realm.write{
                        let newItem = Items()
                        newItem.title = textfield.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                       }
                   }
                   catch{
                       print("Error when save data!!!!!\(error.localizedDescription)")
                   }
                self.tableView.reloadData()
            }

        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action2) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Enter new item"
            textfield = alertTextfield
        }
        alert.addAction(action2)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
// MARK: - LoadDatas
    func LoadItems(){

        itemList = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }
    
    // MARK: - Delete
    override func SwipeDelete(at indexPath: IndexPath) {
        
         if let item = self.itemList?[indexPath.row]{
                   do {
                       try self.realm.write{
                           self.realm.delete(item) // silme
                       }
                   }catch{
                       print("Error with deleting!!!\(error.localizedDescription)")
                   }
                   
               }
               self.tableView.reloadData()
    }
    
    // MARK: - UPDATE items

    override func SwipeUpdate(at indexPath: IndexPath) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Edit", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Save", style: .default) { (action) in

        if let rename = self.itemList?[indexPath.row]{
            do {
                try self.realm.write{
                    rename.title = textfield.text!
                }
            }catch{
                print("Error with Updating!!!\(error.localizedDescription)")
            }
            
        }
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action2) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "\(self.itemList?[indexPath.row].title ?? "")"
            textfield = alertTextfield
        }
        
        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    // MARK: - Swipe Flag
    override func SwipeFlag(at indexPath: IndexPath) {
        
        if let item = itemList?[indexPath.row]{
            do {
                try realm.write{
                    item.done = !item.done // güncelleme
                   
                }
            }catch{
                print("Error while Flag!!!\(error.localizedDescription)")
            }
            
        }
        tableView.reloadData()
    }
    
}

// MARK: - TableView DataSource

    extension MyToDoListVC{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 1
    }
        
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemList?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let safeColor = UIColor(hexString: selectedCategory!.CellbgColor)!.darken(byPercentage:(CGFloat(indexPath.row) / CGFloat(itemList!.count))) {
                cell.backgroundColor = safeColor
                 cell.textLabel?.textColor = ContrastColorOf(safeColor, returnFlat: true)
            }
            //value = condition ? valueTrue : valueFalse
            cell.accessoryType  = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "Could not find any Item"
        }

        return cell
    }
}

// MARK: - TableView Delegate

extension MyToDoListVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = itemList?[indexPath.row]{
            do {
                try realm.write{
                    item.done = !item.done // güncelleme
                }
            }catch{
                print("Error with Updating!!!\(error.localizedDescription)")
            }
            
        }
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - SearchBar Delegate

extension MyToDoListVC:UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemList = itemList?.filter("title CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "title", ascending: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        itemList = itemList?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
        if searchText == "" {
            LoadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
    }


