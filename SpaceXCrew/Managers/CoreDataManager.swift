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
    
    func fetchOrCreateEntities<Entity, IdentifiableCollection>(ofType type: Entity.Type, matchingData data: IdentifiableCollection, entityUpdate: (Entity, IdentifiableCollection.Element) -> Void) where Entity : NSManagedObject, IdentifiableCollection: Collection, IdentifiableCollection.Element: Identifiable {
        
        for element in data {
            self.fetchOrCreateEntity(id: element.id, ofType: type) { entity in
                entityUpdate(entity, element)
            }
        }
    }
    
    func fetchOrCreateEntity<Entity: NSManagedObject>(id: Any, ofType type: Entity.Type, entityUpdate: (Entity) -> Void) {
        // make fetch request to get existing entity, ie item in DB
        let request = NSFetchRequest<Entity>(entityName: type.description())
        request.predicate = NSPredicate(format: "id == %@", "\(id)")
        // fetch or create
        if let result = try? context.fetch(request), let storedEntity = result.first{
            // return fetched entity for updating vars
            entityUpdate(storedEntity)
        }
        else {
            // return created entity for setting vars
            entityUpdate(Entity(context: context))
        }
        // save entity
        save()
    }
}
