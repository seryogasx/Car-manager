//
//  StorageManager.swift
//  CarManager
//
//  Created by Сергей Петров on 21.04.2022.
//

import Foundation
import RealmSwift
import UIKit

protocol StorageManagerProtocol {
    var storage: Realm? { get }
    func addObject(object: Object, completion: (StorageError?) -> Void)
    func deleteObject(object: Object, completion: (StorageError?) -> Void)
    func updateObjects(_ block: () -> Void)
    func fetchObjects(objectType: Object.Type) -> [Object]?
    func saveImage(image: UIImage) -> URL?
    func getImage(url: URL, completion: (Result<UIImage, StorageError>) -> Void)
    func deleteImage(url: URL, completion: (StorageError?) -> Void)
}

final class StorageManager: StorageManagerProtocol {
    
    static var shared: StorageManager = .init()
    
    let imageDirectory = FileManager.default.urls(for: .documentDirectory,
                                                  in: .userDomainMask).first
    
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
            completion(.internalError(message: "Ошибка добавления!"))
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
            completion(.internalError(message: "Ошибка удаления!"))
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
    
    func fetchObjects(objectType: Object.Type) -> [Object]? {
        if let objects = storage?.objects(objectType) {
            return Array(objects)
        }
        return nil
    }
    
    func saveImage(image: UIImage) -> URL? {
        if let pngData = image.pngData(),
           let path = imageDirectory?.appendingPathComponent(UUID().uuidString),
           let _ = try? pngData.write(to: path) {
            return path
        } else {
            return nil
        }
    }
    
    func getImage(url: URL, completion: (Result<UIImage, StorageError>) -> Void) {
        if let image = UIImage(contentsOfFile: url.absoluteString) {
            completion(.success(image))
        } else {
            completion(.failure(StorageError.noData(message: "Fail to get image by url: \(url.absoluteString)! ")))
        }
    }
    
    func deleteImage(url: URL, completion: (StorageError?) -> Void) {
        if FileManager.default.fileExists(atPath: url.absoluteString),
           let _ = try? FileManager.default.removeItem(at: url) {
            completion(nil)
        } else {
            completion(StorageError.noData(message: "Fail to delete image by url: \(url.absoluteURL)!"))
        }
    }
}
