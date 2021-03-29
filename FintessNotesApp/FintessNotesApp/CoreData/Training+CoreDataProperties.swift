//
//  Training+CoreDataProperties.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 27.03.2021.
//
//

import Foundation
import CoreData


extension Training {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Training> {
        return NSFetchRequest<Training>(entityName: "Training")
    }
    

    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var exercises: NSSet

}

// MARK: Generated accessors for exercises
extension Training {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: Exercise)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: Exercise)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}

extension Training : Identifiable {

}

extension Training {
    var allExercises: [Exercise] {
            set {
                exercises = NSSet(array: newValue)
            }
            get {
                return exercises.allObjects as! [Exercise] 
            }
        }
}
