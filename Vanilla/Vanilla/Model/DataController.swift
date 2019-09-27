//
//  DataController.swift
//  Vanilla
//
//  Created by Hend  on 9/21/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import Foundation
import CoreData

class DataController{
    
    
    let persistantContainer : NSPersistentContainer
    
    init(modelName:String) {
        persistantContainer = NSPersistentContainer(name: modelName)
    }
    
    var viewContext:NSManagedObjectContext{
        return persistantContainer.viewContext
    }
    
    func configureContexts(){
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> Void)? = nil){
        persistantContainer.loadPersistentStores{description, error in
            guard error == nil else{
                fatalError(error!.localizedDescription)
            }
            self.configureContexts()
            completion?()
        }
    }
    
    func hasChanges(){
        let context = persistantContainer.viewContext
        if context.hasChanges{
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
