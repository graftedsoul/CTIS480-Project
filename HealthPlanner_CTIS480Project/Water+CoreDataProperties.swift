//
//  Water+CoreDataProperties.swift
//  HealthPlanner_CTIS480Project
//
//  Created by CTIS Student on 14.06.2023.
//  Copyright © 2023 CTIS. All rights reserved.
//
//

import Foundation
import CoreData


extension Water {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Water> {
        return NSFetchRequest<Water>(entityName: "Water")
    }

    @NSManaged public var date: String?
    @NSManaged public var glasses: Int16
    @NSManaged public var user: User?

}
