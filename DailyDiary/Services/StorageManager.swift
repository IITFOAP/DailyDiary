//
//  StorageManager.swift
//  DailyDiary
//
//  Created by Рома Баранов on 18.05.2023.
//

import Foundation
import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DailyDiary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createTask(title: String) -> Task {
        let context = persistentContainer.viewContext
        let task = Task(context: context)
        task.title = title
        saveContext()
        return task
    }
    
    func fetchTasks() -> [Task]{
        let context = persistentContainer.viewContext
        let fetchRequest = Task.fetchRequest()
        
        do {
            let task = try context.fetch(fetchRequest)
            return task
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func updateTask(task: Task, title: String) {
        task.title = title
        saveContext()
    }
    
    func deleteTask(index: Int) {
        let context = persistentContainer.viewContext
        let tasks = fetchTasks()
        let task = tasks[index]
        context.delete(task)
        saveContext()
    }
    
}
