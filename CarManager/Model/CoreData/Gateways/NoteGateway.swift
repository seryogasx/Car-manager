//
//  NoteGateway.swift
//  CarManager
//
//  Created by Сергей Петров on 19.03.2022.
//

import Foundation
import CoreData

protocol NoteStorageGatewayProtocol: CoreDataGateway {
    typealias NoteFetchedResultsController = NSFetchedResultsController<Note>
    var noteFetchedResultsController: NoteFetchedResultsController { get }
    func fetchNotes(car: Car, completion: @escaping (Result<NoteFetchedResultsController, StorageError>) -> Void)
    func deleteNote(note: Note, completion: @escaping (StorageError?) -> Void)
    func addNote(note: Note, completion: @escaping (StorageError?) -> Void)
    func initNote(car: Car) -> Note
}

class NoteGateway: NoteStorageGatewayProtocol {
    
    var storageManager: StorageManagerProtocol
    
    lazy var noteFetchedResultsController: NoteFetchedResultsController = {
        let context = storageManager.mainContext
        let fetchRequest = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "completeDate", ascending: true)]
        let controller = NoteFetchedResultsController(fetchRequest: fetchRequest,
                                                      managedObjectContext: context,
                                                      sectionNameKeyPath: nil,
                                                      cacheName: nil)
        return controller
    }()
    
    func fetchNotes(car: Car, completion: @escaping (Result<NoteFetchedResultsController, StorageError>) -> Void) {
        do {
            try noteFetchedResultsController.performFetch()
            completion(.success(noteFetchedResultsController))
        } catch let error {
            completion(.failure(StorageError.failToFetch(message: "Fail to fetch notes! \(error.localizedDescription)")))
        }
    }
    
    func deleteNote(note: Note, completion: @escaping (StorageError?) -> Void) {
        let context = storageManager.mainContext
        context.delete(note)
        storageManager.saveContext(context: context) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func initNote(car: Car) -> Note {
        let note = Note(entity: Note.entity(), insertInto: storageManager.mainContext)
        note.car = car
        return note
    }
    
    func addNote(note: Note, completion: @escaping (StorageError?) -> Void) {
        if let carContext = note.managedObjectContext {
            storageManager.saveContext(context: carContext) { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(StorageError.noData(message: "No context for aler! Please, use initAlert!"))
        }
    }
    
    init(storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
    }
}
