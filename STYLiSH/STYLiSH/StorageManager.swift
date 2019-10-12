//
//  CoreData.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/25.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation
import CoreData

class StorageManager {
    
    static let shared = StorageManager()
//    var addCarInfos: [AddCarInfo] = []
    let notification = Notification.Name ("showBarBadge")
    
    //此物件無法再被實例化
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StorageModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            print(storeDescription)
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                 NotificationCenter.default.post(name: notification, object: nil)
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
     // MARK: - fetch CoreData 資料
    func getAddCarInfos() -> [AddCarInfo] {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<AddCarInfo>(entityName: "AddCarInfo")

        do {
           let addCarInfos = try context.fetch(request)
            return addCarInfos
        } catch {
            fatalError("Can't fetch data")
        }
    }
}
