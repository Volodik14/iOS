//
//  TrainingTemplate+CoreDataProperties.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 29.03.2021.
//
//

import Foundation
import CoreData


extension TrainingTemplate {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<TrainingTemplate> {
        return NSFetchRequest<TrainingTemplate>(entityName: "TrainingTemplate")
    }

    @NSManaged public var name: String?
    @NSManaged public var exercisesTemplates: NSSet

}

// MARK: Generated accessors for relationship
extension TrainingTemplate {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: ExerciseTemplate)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: ExerciseTemplate)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)

}

extension TrainingTemplate : Identifiable {

}

extension TrainingTemplate {
    var allExercisesTemplates: [ExerciseTemplate] {
            set {
                exercisesTemplates = NSSet(array: newValue)
            }
            get {
                return exercisesTemplates.allObjects as! [ExerciseTemplate] 
            }
        }
}
