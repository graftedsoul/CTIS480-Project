//
//  DataManager.swift
//  HealthPlanner_CTIS480Project
//
//  Created by CTIS Student on 12.06.2023.
//  Copyright © 2023 CTIS. All rights reserved.
//

import Foundation
import CoreData

// https://medium.com/@meggsila/core-data-relationship-in-swift-5-made-simple-f51e19b28326

class DataManager {
    static let shared = DataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HealthPlanner_CTIS480Project")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
  
    // SAVE DATA
    func save () {
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
    
    // CREATE USER
    func user(name: String, sex: Bool, age: Int, weight: Double, height: Double) -> User {
        let u = User(context: persistentContainer.viewContext)
        
        u.name = name
        u.sex = sex
        u.age = Int16(age)
        u.height = height
        u.weight = weight
        
        saveUser(user: u)
        
        return u
    }
    
    // SAVE USER
    func saveUser(user: User) {
        save()
        setLastUser(user: user)
    }
    
    // FETCH USERS
    func fetchUsers() -> [User] {
        let request: NSFetchRequest<User> = User.fetchRequest()
        var fetchedUsers = [User]()
        
        do {
            fetchedUsers = try persistentContainer.viewContext.fetch(request)
        } catch let error {
           print("Error fetching users: \(error)")
        }
        
        return fetchedUsers
    }
    
    // SET LAST USER
    func setLastUser(user: User) {
        print("----------------------- Setting last user")
        
        let context = persistentContainer.viewContext
        
         // do not create a new object if one already exists
        let request: NSFetchRequest<LastUser> = LastUser.fetchRequest()
        var fetched = [LastUser]()
        
        do {
            fetched = try context.fetch(request)
        } catch let error {
           print("Error fetching last user: \(error)")
        }
        
        if fetched.count == 0 {
            let lu = LastUser(context: context)
            lu.lastUser = user.name
        } else {
            let lu = fetched[0]
            lu.lastUser = user.name
        }
    }
    
    // FETCH LAST USER
    func fetchLastUser() -> User {
        let context = persistentContainer.viewContext
        
        // fetch the last user registry
        let reqLU: NSFetchRequest<LastUser> = LastUser.fetchRequest()
        var lastUser = [LastUser]()
        
        do {
            lastUser = try context.fetch(reqLU)
        } catch let error {
           print("Error fetching last user reg: \(error)")
        }
        
        print("----------------------- \(lastUser.count)")
        print("----------------------- \(lastUser[0].lastUser)")

        
        // fetch the user
        let reqU: NSFetchRequest<User> = User.fetchRequest()
        reqU.predicate = NSPredicate(format: "name == %@", lastUser[0].lastUser!)
        var user = [User]()
        
        do {
            user = try context.fetch(reqU)
        } catch let error {
           print("Error fetching last user: \(error)")
        }
        
        return user[0]
    }
    
    // CREATE HABITS
    func habits(trackMood: Bool, trackSteps: Bool, trackSleep: Bool, trackWater: Bool, user: User) -> Habits {
        let h = Habits(context: persistentContainer.viewContext)
        
        h.trackMood = trackMood
        h.trackSteps = trackSteps
        h.trackSleep = trackSleep
        h.trackWater = trackWater
        
        h.user = user
        
        return h
    }
    
    // FETCH ALL HABITS
    func fetchAllHabits() -> [Habits] {
        let request: NSFetchRequest<Habits> = Habits.fetchRequest()
        var fetchedHabits = [Habits]()
        
        do {
            fetchedHabits = try persistentContainer.viewContext.fetch(request)
        } catch let error {
           print("Error fetching habits: \(error)")
        }
        
        return fetchedHabits
    }
    
    // FETCH USER HABITS
    func fetchUserHabits(user: User) -> Habits {
        let request: NSFetchRequest<Habits> = Habits.fetchRequest()
        request.predicate = NSPredicate(format: "user = %@", user)
        var fetchedHabits = [Habits]()
        
        do {
            fetchedHabits = try persistentContainer.viewContext.fetch(request)
        } catch let error {
           print("Error fetching habits: \(error)")
        }
        
        return fetchedHabits[0]
    }
    
    // GET THE TYPE OF JSON DATA (???)
    // this was used in dynamic entity creation but it didn't work lol
    func getType(type: String) -> NSAttributeType {
        var attributeType: NSAttributeType!
        
        switch type.lowercased() {
        case "string":
            attributeType = .stringAttributeType
        case "int":
            attributeType = .integer16AttributeType
        case "date":
            attributeType = .dateAttributeType
        default:
            break
        }
        
        return attributeType
    }
    
    // CREATE WATER
    func createWater(user:User) -> Water {
        let w = Water(context: persistentContainer.viewContext)
        
        let format = DateFormatter()
        format.timeStyle = .none
        format.dateStyle = .long
        
        w.date = format.string(from: Date())
        w.glasses = 0
        
        w.user = user
        
        return w
    }
    
    // FETCH WATER BY USER
    func fetchWaters(user: User) -> [Water] {
        let request: NSFetchRequest<Water> = Water.fetchRequest()
        
        request.predicate = NSPredicate(format: "user = %@", user)
        var fetchedWater = [Water]()
        
        do {
            fetchedWater = try persistentContainer.viewContext.fetch(request)
        } catch let error {
           print("Error fetching water: \(error)")
        }
        
        return fetchedWater
    }
    
    // FETCH WATER BY USER AND DATE
    func fetchWaters(user: User, date: String) -> Water? {
        let request: NSFetchRequest<Water> = Water.fetchRequest()
        
        request.predicate = NSPredicate(format: "user = %@ AND date = %@", user, date)
        var fetchedWater = [Water]()
        
        do {
            fetchedWater = try persistentContainer.viewContext.fetch(request)
        } catch let error {
           print("Error fetching water: \(error)")
        }
        
        if fetchedWater.count != 0 {
            return fetchedWater[0]
        } else {
            return nil
        }
    }
    
    // CREATE STEPS
    func createSteps(user:User) -> Steps {
        let s = Steps(context: persistentContainer.viewContext)
        
        let format = DateFormatter()
        format.timeStyle = .none
        format.dateStyle = .long
        
        s.date = format.string(from: Date())
        s.steps = 0
        
        s.user = user
        
        return s
    }
    
    // FETCH STEPS BY USER AND DATE
    func fetchSteps(user: User, date: String) -> Steps? {
        let request: NSFetchRequest<Steps> = Steps.fetchRequest()
        
        request.predicate = NSPredicate(format: "user = %@ AND date = %@", user, date)
        var fetched = [Steps]()
        
        do {
            fetched = try persistentContainer.viewContext.fetch(request)
        } catch let error {
           print("Error fetching steps: \(error)")
        }
        
        if fetched.count != 0 {
            return fetched[0]
        } else {
            return nil
        }
    }
    
    // CREATE SLEEP
    func createSleep(user:User) -> Sleep {
        let s = Sleep(context: persistentContainer.viewContext)
        
        let format = DateFormatter()
        format.timeStyle = .none
        format.dateStyle = .long
        
        s.date = format.string(from: Date())
        s.hours = 0
        
        s.user = user
        
        return s
    }
    
    // FETCH SLEEP BY USER AND DATE
    func fetchSleep(user: User, date: String) -> Sleep? {
        let request: NSFetchRequest<Sleep> = Sleep.fetchRequest()
        
        request.predicate = NSPredicate(format: "user = %@ AND date = %@", user, date)
        var fetched = [Sleep]()
        
        do {
            fetched = try persistentContainer.viewContext.fetch(request)
        } catch let error {
           print("Error fetching sleep: \(error)")
        }
        
        if fetched.count != 0 {
            return fetched[0]
        } else {
            return nil
        }
    }
    
    // CREATE MOOD
    func createMood(user:User) -> Mood {
        let m = Mood(context: persistentContainer.viewContext)
        
        let format = DateFormatter()
        format.timeStyle = .none
        format.dateStyle = .long
        
        m.date = format.string(from: Date())
        m.mood = 0
        
        m.user = user
        
        return m
    }
    
    // FETCH MOOD BY USER AND DATE
    func fetchMood(user: User, date: String) -> Mood? {
        let request: NSFetchRequest<Mood> = Mood.fetchRequest()
        
        request.predicate = NSPredicate(format: "user = %@ AND date = %@", user, date)
        var fetched = [Mood]()
        
        do {
            fetched = try persistentContainer.viewContext.fetch(request)
        } catch let error {
           print("Error fetching mood: \(error)")
        }
        
        if fetched.count != 0 {
            return fetched[0]
        } else {
            return nil
        }
    }
}
