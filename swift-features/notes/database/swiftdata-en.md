SwiftData

@Model macro plays two roles.
First, it defines schema, automatically inferring its fields and relations.
Second, it defines API of insances which can be used in code.

Schema is applied to ModelContainer which knows how to persist data.
ModelContainer consumes Schema to generate a database that can hold instances of Model

Instances of Model are linked to ModelContext, which manages its state.

ModelConfiguration controls where data is stored (memory, disk), URL, CloudKit.

Its possible to configure different configurations for different grahps of schema. (e g to sync something with icloud). SwiftUI views can define their own containers with .modelContainer() likely choosing Models to use.

ModelContext works same way as NSManagedObjectContext - it tracks model instances changes and pushes it or persists on context.save(). undo is supportd with system-given undo manager.
But theres a feature - Autosave I havent met in CoreData. It makes context save itself on system events (e g enter background) or periodically as app is used. Autosave of main context is enabled by default but disabled in custom contexts.

Emerged new struct - FetchDescriptor( supose its counterpart of FetchRequest ). It works with #Predicate macro. This macro allows to write complex queries(subqueries, joins) in Swift (there are restrictions though). 

Context has func enumerate which literally enumerates fetched by descriptor entities. Default batch size is 5000. Its possible to educe IO ops enlarging batch size. If object graph is heavy(contains images, blobs) its recommended to reduce batch size to reduce memory consumption, increasing IO.

SwiftData, comparing to CoreData, lacks a concept of child contexts, although its possible to create background contexts with Container. Changes emerging in Container are propagated in their contexts, so when context (main or background) is saved, changes appear in sibling contexts (affects @Query statements).

Contexts arent Sendable so cannot be transfered between actors. But Containers are, so to create background context, container can be passed to an actor. Models arent sendable either, but ther ids can be transferred.

Theres a phrase on "hackingwithswift"
 If you intend to create a background context using an actor in order to do bulk data imports, I would recommend against storing the context as a property because the extra actor synchronization will slow down your code dramatically.
I dont quite understand it yet.

To safely use background context @ModelActor macro is introduced. It creates DefaultSerialModelExecutor and provides modelContext.

https://developer.apple.com/videos/play/wwdc2023/10196/
https://developer.apple.com/videos/play/wwdc2024/10137/
https://www.hackingwithswift.com/quick-start/swiftdata/how-to-create-a-background-context
https://useyourloaf.com/blog/swiftdata-background-tasks/