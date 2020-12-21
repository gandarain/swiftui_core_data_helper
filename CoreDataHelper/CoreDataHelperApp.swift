//
//  CoreDataHelperApp.swift
//  CoreDataHelper
//
//  Created by Panbers on 20/12/20.
//

import SwiftUI

@main
struct CoreDataHelperApp: App {
  let persistenceContainer = PersistenceUserData.shared
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
    }
  }
}
