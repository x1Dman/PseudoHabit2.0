//
//  CoreDataHabitsManager.swift
//  SberTestApp
//
//  Created by Nikita Khusnutdinov on 7/16/20.
//  Copyright © 2020 Nikita Khusnutdinov. All rights reserved.
//

import Foundation
import CoreData

/*
    protocol was made for update/delete/insert in database
 */
protocol Storable {
    associatedtype ModelDTO
    associatedtype Model
    
    func create(_ model: ModelDTO) -> Model?
    func get(name: String) -> Model?
    func getAll() -> [Model]?
    func update(_ model: Model)
    func delete(_ model: Model)
}

final class CoreDataHabitsManager: Storable {
    
    private enum Constants {
        static let habitModelName = "HabitsModel"
        static let habitDBName = "HabitDB"
        static let equationPredicat = "name == %@"
    }
    
    typealias ModelDTO = HabitModel
    typealias Model = HabitDB
    
    static let instance = CoreDataHabitsManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.habitModelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func create(_ model: HabitModel) -> HabitDB? {
        return createHabit(withHabitModel: model)
    }
    
    func get(name: String) -> HabitDB? {
        return fetchHabit(withName: name)
    }
    
    func getAll() -> [HabitDB]? {
        return fetchHabits()
    }
    
    func update(_ model: HabitDB) {
        updateHabit(habit: model)
    }
    
    func delete(_ model: HabitDB) {
        deleteHabit(habit: model)
    }
    
    private func createHabit(withHabitModel habit: HabitModel) -> HabitDB? {
        let context = persistentContainer.viewContext
        
        guard let newHabit = NSEntityDescription.insertNewObject(forEntityName: Constants.habitDBName, into: context) as? HabitDB else { return nil }
        
        newHabit.habitNameDB = habit.name
        newHabit.datesDB = habit.dates
        newHabit.habitsMotivationDB = habit.motivation
        newHabit.habitTypeDB = habit.type
        
        do {
            try context.save()
            return newHabit
        } catch let failedToCreateError {
            print("\(failedToCreateError)")
            return nil
        }
    }
    
    private func fetchHabits() -> [HabitDB]? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<HabitDB>(entityName: Constants.habitDBName)
        
        do {
            let habits = try context.fetch(fetchRequest)
            return habits
        } catch let failedToGetHabitsError {
            print("\(failedToGetHabitsError)")
            return nil
        }
    }
    
    private func fetchHabit(withName name: String) -> HabitDB? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<HabitDB>(entityName: Constants.habitDBName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: Constants.equationPredicat, name)
        
        do {
            let habit = try context.fetch(fetchRequest)
            return habit.first
        } catch let failedToGetHabitsError {
            print("\(failedToGetHabitsError)")
            return nil
        }
    }
    
    private func updateHabit(habit: HabitDB) {
        let context = persistentContainer.viewContext
        
        do {
            try context.save()
        } catch let updFailError {
            print("\(updFailError)")
        }
    }
    
    private func deleteHabit(habit: HabitDB){
        let context = persistentContainer.viewContext
        context.delete(habit)
        do {
            try context.save()
        } catch let delFailError {
            print("\(delFailError)")
        }
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
