import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    
    private let persistentContainer: NSPersistentContainer = {
        let storeURL = FileManager.appGroupContainerURL.appendingPathComponent("Canvas.sqlite")
        let container = NSPersistentContainer(name: "Canvas")
        
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        return container
    }()
}

// MARK: - Main context

extension CoreDataStack {
    var managedObjectContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        managedObjectContext.performAndWait {
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
