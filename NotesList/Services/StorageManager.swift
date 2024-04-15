//
//  StorageManager.swift
//  NotesList
//
//  Created by Анастасия Конончук on 15.04.2024.
//

import CoreData

final class StorageManager {
    // MARK: - Public Properties
    static let shared = StorageManager()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Private Properties
    // Core Data stack
    private let persistentContainer: NSPersistentContainer
    
    // MARK: - Private Initializers
    private init() {
        persistentContainer = NSPersistentContainer(name: "Note")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: - Public Methods
    // Saving support
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Fetch support
    func fetchData<T: NSManagedObject>(_ entity: T.Type, sortKey: String) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entity))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortKey, ascending: false)]
        do {
            return try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    // Delete support
    func delete<T: NSManagedObject>(_ object: T) {
        context.delete(object)
        saveContext()
    }
    
    func deleteAllObjects<T: NSManagedObject>(_ entity: T.Type) {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entity))
        if let objects = try? context.fetch(fetchRequest) {
            for object in objects {
                context.delete(object)
            }
        }
        saveContext()
    }
    
    // Get object by id support
    func getObjectById<T: NSManagedObject>(id: UUID, for entity: T.Type) -> T? {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entity))
        fetchRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}
