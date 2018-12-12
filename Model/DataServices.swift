//
//  DataServices.swift
//  CoreDataPerson2
//
//  Created by Duc Anh on 11/28/18.
//  Copyright © 2018 Duc Anh. All rights reserved.
//

import Foundation
import CoreData

class DataServices {
    static let shared: DataServices = DataServices()
    
    var fetchedResultsController: NSFetchedResultsController<Person> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        //Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        //Edit the sort key as approprite.
        let sortDescription = NSSortDescriptor(key: "age", ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        
        //Edit the section name key path and cache name if approprite.
        //nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.context, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController?.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    private var _fetchedResultsController: NSFetchedResultsController<Person>? = nil
    
    func saveData() {
        let context = _fetchedResultsController?.managedObjectContext
        do {
            try context?.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
}
