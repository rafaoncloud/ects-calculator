//
//  Subject+CoreDataProperties.swift
//  ects-calculator
//
//  Created by Rafael Henriques on 23/08/2018.
//  Copyright © 2018 rafaoncloud. All rights reserved.
//
//

import Foundation
import CoreData


extension Subject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subject> {
        return NSFetchRequest<Subject>(entityName: "Subject")
    }

    @NSManaged public var abbreviation: String?
    @NSManaged public var fullName: String?
    @NSManaged public var ects: Int16
    @NSManaged public var grade: Int16
    @NSManaged public var semester: Semester?

}
