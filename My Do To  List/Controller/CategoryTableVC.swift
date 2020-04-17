//
//  CategoryTableVC.swift
//  My Do To  List
//
//  Created by Bekir Duran on 9.04.2020.
//  Copyright © 2020 info. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


// MARK: - CategoryTableVievController

class CategoryTableVC: SwipeSuperTableViewController {

    var realm = try! Realm()
    var CategoryList: Results<Categories>?

    
    override func viewDidLoad() {
        super.viewDidLoad()    
        LoadCategories()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Bar error!!!")}
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
        view.backgroundColor = UIColor(hexString: "1D9BF6")
        
    }
    
    
    // MARK: - Add Button View

    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Categories()
            newCategory.name = textfield.text!
            newCategory.CellbgColor = RandomFlatColor().hexValue()
         //   self.CategoryArray.append(newCategory)
            self.Save(category: newCategory)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action2) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Enter a Category"
            textfield = alertTextfield
        }
        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - FLAG Action
    
//    override func SwipeFlag(at indexPath: IndexPath) {
//       let cell = tableView.cellForRow(at: indexPath)
//        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
//    }
    
    // MARK: - unFLAG Action


    // MARK: - Save data

    func Save(category:Categories){
        do {
            try realm.write{
                realm.add(category)
            }
        }
        catch{
            print("Error when save data!!!!!\(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    // MARK: - Load data
      func LoadCategories(){
        CategoryList = realm.objects(Categories.self)
        tableView.reloadData()
    }
    
    // MARK: - Delete data

    override func SwipeDelete(at indexPath: IndexPath) {
        if let item = self.CategoryList?[indexPath.row]{
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
    // MARK: - UPDATE data
    override func SwipeUpdate(at indexPath: IndexPath) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Edit", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Save", style: .default) { (action) in

        if let rename = self.CategoryList?[indexPath.row]{
            do {
                try self.realm.write{
                    rename.name = textfield.text!
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
            alertTextfield.placeholder = "\(self.CategoryList?[indexPath.row].name ?? "")"
            textfield = alertTextfield
        }
        
        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CategoryList?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = CategoryList?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No Category"
        
     
        if let cellColor = category?.CellbgColor {
            cell.backgroundColor = UIColor(hexString: cellColor)
            guard let safeColor = UIColor(hexString: cellColor) else {fatalError()}
            cell.textLabel?.textColor = ContrastColorOf(safeColor, returnFlat: true)
        }
    
      //  cell.textLabel?.font = UIFont(name: "Avenir-Light", size: 17.0)
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoitem", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MyToDoListVC
       if let indeks = tableView.indexPathForSelectedRow {
        destinationVC.selectedCategory = CategoryList?[indeks.row]
        }
    }
    
    
    
}
