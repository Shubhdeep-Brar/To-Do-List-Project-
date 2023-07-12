//
//  ToDoListItem+CoreDataProperties.swift
//  ToDoList
//
//  Created by Shubhdeep on 2023-07-12.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var name: String?

}

extension ToDoListItem : Identifiable {

}
