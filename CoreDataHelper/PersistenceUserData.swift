//
//  PersistenceUserData.swift
//  CoreDataHelper
//
//  Created by Panbers on 20/12/20.
//

import Foundation
import CoreData

struct PersistenceUserData {
  static let shared = PersistenceUserData()
  
  let container: NSPersistentContainer
  
  init() {
    container = NSPersistentContainer(name: "UserData")
    
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error: \(error)")
      }
    }
  }
}
