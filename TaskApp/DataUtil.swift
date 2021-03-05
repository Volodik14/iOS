//
//  DataUtil.swift
//  TaskApp
//
//  Created by Владимир Моторкин on 05.03.2021.
//
import CoreData
import Foundation
import UIKit



func saveContext(container: NSPersistentContainer) {
    if container.viewContext.hasChanges {
        do {
            try container.viewContext.save()
        } catch {
            print("An error occurred while saving: \(error)")
        }
    }
}




