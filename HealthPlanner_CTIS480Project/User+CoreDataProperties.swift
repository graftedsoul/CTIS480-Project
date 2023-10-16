//
//  User+CoreDataProperties.swift
//  HealthPlanner_CTIS480Project
//
//  Created by CTIS Student on 14.06.2023.
//  Copyright © 2023 CTIS. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var age: Int16
    @NSManaged public var height: Double
    @NSManaged public var name: String?
    @NSManaged public var sex: Bool
    @NSManaged public var weight: Double
    @NSManaged public var tracked: Habits?
    @NSManaged public var water: NSSet?

}

// MARK: Generated accessors for water
extension User {

    @objc(addWaterObject:)
    @NSManaged public func addToWater(_ value: Water)

    @objc(removeWaterObject:)
    @NSManaged public func removeFromWater(_ value: Water)

    @objc(addWater:)
    @NSManaged public func addToWater(_ values: NSSet)

    @objc(removeWater:)
    @NSManaged public func removeFromWater(_ values: NSSet)

}
