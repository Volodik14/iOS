//
//  ExerciseTemplate+CoreDataProperties.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 29.03.2021.
//
//

import Foundation
import CoreData


extension ExerciseTemplate {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<ExerciseTemplate> {
        return NSFetchRequest<ExerciseTemplate>(entityName: "ExerciseTemplate")
    }

    @NSManaged public var name: String?
    @NSManaged public var isWeight: Bool
    @NSManaged public var trainingTemplate: TrainingTemplate?

}

extension ExerciseTemplate : Identifiable {

}
