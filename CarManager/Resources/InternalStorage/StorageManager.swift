//
//  StorageManager.swift
//  CarManager
//
//  Created by Сергей Петров on 21.04.2022.
//

import Foundation
import RealmSwift

protocol StorageManagerProtocol {
    var storage: Realm? { get }
    func addObject(object: Object, completion: (StorageError?) -> Void)
    func deleteObject(object: Object, completion: (StorageError?) -> Void)
    func updateObjects(_ block: () -> Void)
    func fetchObjects(objectType: Object.Type) -> Results<Object>?
}

final class StorageManager: StorageManagerProtocol {
    
    static var shared: StorageManager = .init()
    
    lazy var storage: Realm? = {
        do {
            let realm = try Realm()
            return realm
        } catch {
            print("Fail to init realm!")
            return nil
        }
    }()
    
    private init() { }
    
    func addObject(object: Object, completion: (StorageError?) -> Void) {
        do {
            try storage?.write {
                storage?.add(object)
                completion(nil)
            }
        } catch {
            print("fail to addObject: \(object)")
            completion(.internalError)
        }
    }
    
    func deleteObject(object: Object, completion: (StorageError?) -> Void) {
        do {
            try storage?.write {
                storage?.delete(object)
                completion(nil)
            }
        } catch {
            print("fail to deleteObject: \(object)")
            completion(.internalError)
        }
    }
    
    func updateObjects(_ block: () -> Void) {
        do {
            try storage?.write {
                block()
            }
        } catch {
            print("fail to updateObjects!")
        }
    }
    
    func fetchObjects(objectType: Object.Type) -> Results<Object>? {
        storage?.objects(objectType)
    }
}
