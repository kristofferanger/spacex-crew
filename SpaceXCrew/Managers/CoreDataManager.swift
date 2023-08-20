//
//  CoreDataManager.swift
//  SpaceX-Launches
//
//  Created by Kristoffer Anger on 2023-08-19.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "SpaceX_Launches")
        container.loadPersistentStores { description, error in
            if let error {
                print("Error loading Core Data \(error.localizedDescription)")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
        }
        catch let error {
            print("Error saving to Core Data \(error.localizedDescription)")
        }
    }
}
