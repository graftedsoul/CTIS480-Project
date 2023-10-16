//
//  Habits+CoreDataProperties.swift
//  HealthPlanner_CTIS480Project
//
//  Created by CTIS Student on 14.06.2023.
//  Copyright © 2023 CTIS. All rights reserved.
//
//

import Foundation
import CoreData


extension Habits {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habits> {
        return NSFetchRequest<Habits>(entityName: "Habits")
    }

    @NSManaged public var trackMood: Bool
    @NSManaged public var trackSleep: Bool
    @NSManaged public var trackSteps: Bool
    @NSManaged public var trackWater: Bool
    @NSManaged public var user: User?

}
