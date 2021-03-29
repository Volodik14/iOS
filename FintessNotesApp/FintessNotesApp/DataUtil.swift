//
//  DataUtil.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 29.03.2021.
//
import CoreData
import Foundation

func saveContext(container: NSPersistentContainer) {
    if container.viewContext.hasChanges {
        do {
            try container.viewContext.save()
        } catch {
            print("An error occurred while saving: \(error)")
        }
    }
}
