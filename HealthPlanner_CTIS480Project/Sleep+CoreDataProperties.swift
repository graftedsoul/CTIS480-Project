//
//  Sleep+CoreDataProperties.swift
//  HealthPlanner_CTIS480Project
//
//  Created by CTIS Student on 14.06.2023.
//  Copyright © 2023 CTIS. All rights reserved.
//
//

import Foundation
import CoreData


extension Sleep {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sleep> {
        return NSFetchRequest<Sleep>(entityName: "Sleep")
    }

    @NSManaged public var hours: Int16
    @NSManaged public var date: String?
    @NSManaged public var user: User?

}
