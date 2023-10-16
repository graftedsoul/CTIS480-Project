//
//  Steps+CoreDataProperties.swift
//  HealthPlanner_CTIS480Project
//
//  Created by CTIS Student on 14.06.2023.
//  Copyright © 2023 CTIS. All rights reserved.
//
//

import Foundation
import CoreData


extension Steps {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Steps> {
        return NSFetchRequest<Steps>(entityName: "Steps")
    }

    @NSManaged public var date: String?
    @NSManaged public var steps: Int16
    @NSManaged public var user: User?

}
