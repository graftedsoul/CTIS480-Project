//
//  LastUser+CoreDataProperties.swift
//  HealthPlanner_CTIS480Project
//
//  Created by CTIS Student on 14.06.2023.
//  Copyright © 2023 CTIS. All rights reserved.
//
//

import Foundation
import CoreData


extension LastUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastUser> {
        return NSFetchRequest<LastUser>(entityName: "LastUser")
    }

    @NSManaged public var lastUser: String?

}
