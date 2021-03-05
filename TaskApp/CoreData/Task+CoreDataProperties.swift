//
//  Task+CoreDataProperties.swift
//  TaskApp
//
//  Created by Владимир Моторкин on 05.03.2021.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var date: Date?
    @NSManaged public var status: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var title: String?

}

extension Task : Identifiable {

}
