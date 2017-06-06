//
//  RestaurantTableViewController.swift
//  App
//
//  Created by 康錦豐 on 2017/6/2.
//  Copyright © 2017年 appcoda. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var restaurants:[RestaurantMo] = []
    var fetchResultController: NSFetchedResultsController<RestaurantMo>!
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //從資料儲存區中讀取資料
        let fetchRequest: NSFetchRequest<RestaurantMo> = RestaurantMo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    restaurants = fetchedObjects
                }
            } catch {
                print(error)
            }
            searchController = UISearchController(searchResultsController: nil)
            tableView.tableHeaderView = searchController.searchBar
        }
        
        //Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.hidesBarsOnSwipe = true
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        if let fetchedObjects = controller.fetchedObjects {
            restaurants = fetchedObjects as! [RestaurantMo]
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
        
        // Configure the cell...
        cell.nameLabel.text = restaurants[indexPath.row].name
        cell.thumbnailImageView.image = UIImage(data: restaurants[indexPath.row].image as! Data)
        cell.locationLabel.text = restaurants[indexPath.row].location
        cell.typeLabel.text = restaurants[indexPath.row].type
        
//        if restaurantIsVisited[indexPath.row] {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        } 這五行等於下面這一行 ⬇️
        cell.accessoryType = restaurants[indexPath.row].isVisited ? .checkmark : .none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //資料源刪除列
            restaurants.remove(at: indexPath.row)
            
        }
       tableView.deleteRows(at: [indexPath], with: .fade)
        
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //社群分享
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Share", handler: { (action, indexPath) -> Void in
            
            let defaultText = "Just checking in at" + self.restaurants[indexPath.row].name!
            
            if let imageToShare = UIImage(data: self.restaurants[indexPath.row].image as! Data){
             let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)

            }
        })
        //刪除按鈕
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler: { (action, indexPath) -> Void in
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let restaurantToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(restaurantToDelete)
                
            //從資料源刪除列
            self.restaurants.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
                
            appDelegate.saveContext()
            }
        })
        shareAction.backgroundColor = UIColor(red: 17.0/255.0, green: 139.0/155.0, blue: 232.0/255.0, alpha: 2.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        return [deleteAction, shareAction]

    }
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    }
    override func  prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = restaurants[indexPath.row]
            }
        }
    }
}

