//
//  SwipeSuperTableViewController.swift
//  My Do To  List
//
//  Created by Bekir Duran on 13.04.2020.
//  Copyright © 2020 info. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeSuperTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
           cell.delegate = self
        return cell
    }
    
    // MARK: - Swipe Protocol
        
        
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

            guard orientation == .right else { return nil }
            
            
            
            // Deleting Action
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                self.SwipeDelete(at: indexPath)
            }
            
            // Update Action
            let updateAction = SwipeAction(style: .default, title: "Rename") { action, indexPath in
                self.SwipeUpdate(at: indexPath)
            }
            
            // Flag Action
//           let flagAction = SwipeAction(style: .default, title: "Flag") { action, indexPath in
//                   print("Flag Pressed")
//                self.SwipeFlag(at: indexPath)
//                }

            // customize the action appearance
            deleteAction.image = UIImage(systemName: "trash")
            updateAction.image = UIImage(systemName: "slider.horizontal.3")
//            flagAction.image = UIImage(systemName: "flag")
//            flagAction.backgroundColor = .blue

            
            return [deleteAction,updateAction]
        }
        
        
        func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
            var options = SwipeOptions()
            options.expansionStyle = .destructive
           // options.transitionStyle = .border
            return options
        }
    

    func SwipeDelete(at indexPath:IndexPath){
    }
    
    func SwipeUpdate(at indexPath:IndexPath){
    }
    
    func SwipeFlag(at indexPath:IndexPath){
    }



}
