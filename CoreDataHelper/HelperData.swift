//
//  HelperData.swift
//  CoreDataHelper
//
//  Created by Panbers on 20/12/20.
//
import Foundation
import CoreData

class HelperData: ObservableObject {
  @Published var loadTotal = false
  
  func saveContext(context: NSManagedObjectContext){
    do {
      try context.save()
      self.loadTotal = true
    } catch {
      print(error)
    }
  }
  
  func addCart(context: NSManagedObjectContext){
    let newCart = CartData(context: context)
    newCart.name = "Baju"
    newCart.desc = "Baju Pria"
    newCart.jumlah = 1
    newCart.price = 10000
    newCart.total = newCart.jumlah * newCart.price
    saveContext(context: context)
  }
  
  func deleteCart(context: NSManagedObjectContext, item: CartData){
    context.delete(item)
    saveContext(context: context)
  }
  
  func clearDatabase(context: NSManagedObjectContext, entity:String) {
    let coord = context.persistentStoreCoordinator
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity )
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
      let result = try coord?.execute(deleteRequest, with: context)
      print("Result \(String(describing: result))")
    } catch let error as NSError {
        debugPrint(error)
    }
  }
  
  func deleteAllCart(context: NSManagedObjectContext){
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartData")
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    batchDeleteRequest.resultType = .resultTypeObjectIDs
    
    do {
      let result = try context.execute(batchDeleteRequest) as! NSBatchDeleteResult
      let changes: [AnyHashable: Any] = [
          NSDeletedObjectsKey: result.result as! [NSManagedObjectID]
      ]
      NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
    } catch {
      print(error)
    }
  }
  
  func plusOneItem(context: NSManagedObjectContext, item: CartData){
    item.jumlah += 1
    item.total += item.price
    saveContext(context: context)
  }
  
  func minusOneItem(context: NSManagedObjectContext, item: CartData){
    item.jumlah -= 1
    item.total -= item.price
    saveContext(context: context)
  }
}
