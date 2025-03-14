//
//  CoreDataStack.swift
//  Pardus
//
//  Created by Igor Postoev on 19.5.24..
//

import CoreData

// swiftlint:disable:next type_body_length
class CoreDataStack {
    
    var container: NSPersistentContainer!
    
    var coordinator: NSPersistentStoreCoordinator {
        container.persistentStoreCoordinator
    }
    
    lazy var rootContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.automaticallyMergesChangesFromParent = false
        context.persistentStoreCoordinator = coordinator
        return context
    }()
    
    lazy var mainQueueContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = rootContext
        context.automaticallyMergesChangesFromParent = true
        context.retainsRegisteredObjects = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.shouldDeleteInaccessibleFaults = true
        return context
    }()
    
    func makeStubMainQueueContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = mainQueueContext
        context.automaticallyMergesChangesFromParent = true
        context.retainsRegisteredObjects = false
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.shouldDeleteInaccessibleFaults = true
        return context
    }
    
    func setup(inMemory: Bool) {
        let model = makeModel()
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        
        let url = documentDir!.appending(path: "Pardus.sqlite")
        
        container = NSPersistentContainer(name: "Pardus", managedObjectModel: model)
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }
        print("DBURL: \(url)")
        description.url = url
        description.type = inMemory ? NSInMemoryStoreType : NSSQLiteStoreType
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    // swiftlint:disable:next function_body_length
    private func makeModel() -> NSManagedObjectModel {
        let mealDescription = {
            let desc = NSEntityDescription()
            desc.name = "Meal"
            desc.managedObjectClassName = String(describing: Meal.self)
            desc.properties = [makeIdAttribute(),
                               makeCreatedAtAttribute(),
                               makeAttribute(name: "date", type: .dateAttributeType)]
            return desc
        }()
        
        let dishDescription = {
            let desc = NSEntityDescription()
            desc.name = "Dish"
            desc.managedObjectClassName = String(describing: Dish.self)
            desc.properties = [makeIdAttribute(),
                               makeCreatedAtAttribute(),
                               makeAttribute(name: "name", type: .stringAttributeType, defaultValue: "")]
            return desc
        }()
        
        let dishCategoryDescription = {
            let desc = NSEntityDescription()
            desc.name = "DishCategory"
            desc.managedObjectClassName = String(describing: DishCategory.self)
            desc.properties = [makeIdAttribute(),
                               makeCreatedAtAttribute(),
                               makeAttribute(name: "name", type: .stringAttributeType, defaultValue: ""),
                               makeAttribute(name: "colorHex", type: .stringAttributeType, isOptional: true)]
            return desc
        }()
        
        // Dish --> DishCategory
        let dishToCatRel = NSRelationshipDescription()
        dishToCatRel.name = "category"
        dishToCatRel.destinationEntity = dishCategoryDescription
        dishToCatRel.maxCount = 1
        dishToCatRel.deleteRule = .nullifyDeleteRule
        dishToCatRel.isOptional = true
        
        // DishCategory --> Dish
        let catToDishRel = NSRelationshipDescription()
        catToDishRel.name = "dishes"
        catToDishRel.destinationEntity = dishDescription
        catToDishRel.deleteRule = .nullifyDeleteRule
        catToDishRel.isOptional = true
        
        dishToCatRel.inverseRelationship = catToDishRel
        catToDishRel.inverseRelationship = dishToCatRel
    
        dishDescription.properties.append(dishToCatRel)
        dishCategoryDescription.properties.append(catToDishRel)

        // MealDish attributes and relationships
        let mealDishDescription = {
            let desc = NSEntityDescription()
            desc.name = "MealDish"
            desc.managedObjectClassName = String(describing: MealDish.self)
            desc.properties = [makeIdAttribute(),
                               makeCreatedAtAttribute(),
                               makeAttribute(name: "name", type: .stringAttributeType, defaultValue: "")]
            return desc
        }()
        
        // MealDish --> Meal
        let mealDishToMealRel = NSRelationshipDescription()
        mealDishToMealRel.name = "meal"
        mealDishToMealRel.destinationEntity = mealDescription
        mealDishToMealRel.deleteRule = .nullifyDeleteRule
        mealDishToMealRel.maxCount = 1
        mealDishToMealRel.minCount = 1
        mealDishDescription.properties.append(mealDishToMealRel)

        // Meal --> MealDish
        let mealToMealDishRel = NSRelationshipDescription()
        mealToMealDishRel.name = "dishes"
        mealToMealDishRel.isOptional = true
        mealToMealDishRel.destinationEntity = mealDishDescription
        mealToMealDishRel.deleteRule = .cascadeDeleteRule
        mealDescription.properties.append(mealToMealDishRel)
        
        mealDishToMealRel.inverseRelationship = mealToMealDishRel
        mealToMealDishRel.inverseRelationship = mealDishToMealRel
        
        // MealDish --> Dish
        let mealDishToDishRel = NSRelationshipDescription()
        mealDishToDishRel.name = "dish"
        mealDishToDishRel.destinationEntity = dishDescription
        mealDishToDishRel.deleteRule = .nullifyDeleteRule
        mealDishToDishRel.maxCount = 1
        mealDishToDishRel.minCount = 1
        mealDishDescription.properties.append(mealDishToDishRel)

        // Dish --> MealDish
        let dishToMealDishRel = NSRelationshipDescription()
        dishToMealDishRel.name = "mealDishes"
        dishToMealDishRel.isOptional = true
        dishToMealDishRel.destinationEntity = mealDishDescription
        dishToMealDishRel.deleteRule = .nullifyDeleteRule
        dishDescription.properties.append(dishToMealDishRel)
        
        mealDishToDishRel.inverseRelationship = dishToMealDishRel
        dishToMealDishRel.inverseRelationship = mealDishToDishRel
        
        let ingridientDescription = {
            let desc = NSEntityDescription()
            desc.name = "Ingridient"
            desc.managedObjectClassName = String(describing: Ingridient.self)
            desc.properties = [makeIdAttribute(),
                               makeCreatedAtAttribute(),
                               makeAttribute(name: "name", type: .stringAttributeType, defaultValue: ""),
                               makeAttribute(name: "calories", type: .doubleAttributeType, defaultValue: 0),
                               makeAttribute(name: "proteins", type: .doubleAttributeType, defaultValue: 0),
                               makeAttribute(name: "fats", type: .doubleAttributeType, defaultValue: 0),
                               makeAttribute(name: "carbs", type: .doubleAttributeType, defaultValue: 0)]
            
            return desc
        }()
        
        // Dish <--> Ingridient
        let ingridientToDishRel = NSRelationshipDescription()
        ingridientToDishRel.name = "dishes"
        ingridientToDishRel.destinationEntity = dishDescription
        ingridientToDishRel.deleteRule = .nullifyDeleteRule
        ingridientToDishRel.isOptional = true
        
        let dishToIngridientRel = NSRelationshipDescription()
        dishToIngridientRel.name = "ingridients"
        dishToIngridientRel.destinationEntity = ingridientDescription
        dishToIngridientRel.deleteRule = .nullifyDeleteRule
        dishToIngridientRel.isOptional = true
        
        ingridientToDishRel.inverseRelationship = dishToIngridientRel
        dishToIngridientRel.inverseRelationship = ingridientToDishRel
    
        ingridientDescription.properties.append(ingridientToDishRel)
        dishDescription.properties.append(dishToIngridientRel)
        
        let ingridientCategoryDescription = {
            let desc = NSEntityDescription()
            desc.name = "IngridientCategory"
            desc.managedObjectClassName = String(describing: IngridientCategory.self)
            desc.properties = [makeIdAttribute(),
                               makeCreatedAtAttribute(),
                               makeAttribute(name: "name", type: .stringAttributeType, defaultValue: ""),
                               makeAttribute(name: "colorHex", type: .stringAttributeType, isOptional: true)]
            return desc
        }()
        
        // Ingridient --> Category
        let ingridientToCatRel = NSRelationshipDescription()
        ingridientToCatRel.name = "category"
        ingridientToCatRel.destinationEntity = ingridientCategoryDescription
        ingridientToCatRel.maxCount = 1
        ingridientToCatRel.deleteRule = .nullifyDeleteRule
        ingridientToCatRel.isOptional = true
        
        // Category --> Ingridient
        let catToIngridientRel = NSRelationshipDescription()
        catToIngridientRel.name = "ingridients"
        catToIngridientRel.destinationEntity = ingridientDescription
        catToIngridientRel.deleteRule = .nullifyDeleteRule
        catToIngridientRel.isOptional = true
        
        ingridientToCatRel.inverseRelationship = catToIngridientRel
        catToIngridientRel.inverseRelationship = ingridientToCatRel
    
        ingridientDescription.properties.append(ingridientToCatRel)
        ingridientCategoryDescription.properties.append(catToIngridientRel)

        let mealIngridientDescription = {
            let desc = NSEntityDescription()
            desc.name = "MealIngridient"
            desc.managedObjectClassName = String(describing: MealIngridient.self)
            desc.properties = [makeIdAttribute(),
                               makeCreatedAtAttribute(),
                               makeAttribute(name: "name", type: .stringAttributeType, defaultValue: ""),
                               makeAttribute(name: "caloriesPer100", type: .doubleAttributeType, defaultValue: 0),
                               makeAttribute(name: "proteinsPer100", type: .doubleAttributeType, defaultValue: 0),
                               makeAttribute(name: "fatsPer100", type: .doubleAttributeType, defaultValue: 0),
                               makeAttribute(name: "carbsPer100", type: .doubleAttributeType, defaultValue: 0),
                               makeAttribute(name: "weight", type: .doubleAttributeType, defaultValue: 0)]

            return desc
        }()
        
        // MealIngridient <--> MealDish
        let mealIngridientToMealDishRel = NSRelationshipDescription()
        mealIngridientToMealDishRel.name = "dish"
        mealIngridientToMealDishRel.destinationEntity = mealDishDescription
        mealIngridientToMealDishRel.maxCount = 1
        mealIngridientToMealDishRel.deleteRule = .nullifyDeleteRule
        mealIngridientToMealDishRel.isOptional = true
        
        let mealDishToMealIngridient = NSRelationshipDescription()
        mealDishToMealIngridient.name = "ingridients"
        mealDishToMealIngridient.destinationEntity = mealIngridientDescription
        mealDishToMealIngridient.deleteRule = .cascadeDeleteRule
        mealDishToMealIngridient.isOptional = true
        
        mealIngridientToMealDishRel.inverseRelationship = mealDishToMealIngridient
        mealDishToMealIngridient.inverseRelationship = mealIngridientToMealDishRel
    
        mealIngridientDescription.properties.append(mealIngridientToMealDishRel)
        mealDishDescription.properties.append(mealDishToMealIngridient)
        
        // MealIngridient <--> Ingridient
        let mealIngridientToIngridientRel = NSRelationshipDescription()
        mealIngridientToIngridientRel.name = "ingridient"
        mealIngridientToIngridientRel.destinationEntity = ingridientDescription
        mealIngridientToIngridientRel.maxCount = 1
        mealIngridientToIngridientRel.deleteRule = .nullifyDeleteRule
        mealIngridientToIngridientRel.isOptional = true
        
        let ingridientToMealIngridientRel = NSRelationshipDescription()
        ingridientToMealIngridientRel.name = "mealIngridients"
        ingridientToMealIngridientRel.destinationEntity = mealIngridientDescription
        ingridientToMealIngridientRel.deleteRule = .nullifyDeleteRule
        ingridientToMealIngridientRel.isOptional = true
        
        mealIngridientToIngridientRel.inverseRelationship = ingridientToMealIngridientRel
        ingridientToMealIngridientRel.inverseRelationship = mealIngridientToIngridientRel
    
        mealIngridientDescription.properties.append(mealIngridientToIngridientRel)
        ingridientDescription.properties.append(ingridientToMealIngridientRel)
        
        let model = NSManagedObjectModel()
        model.entities = [mealDescription,
                          dishDescription,
                          dishCategoryDescription,
                          mealDishDescription,
                          ingridientDescription,
                          ingridientCategoryDescription,
                          mealIngridientDescription]
        return model
    }
    
    private func makeIdAttribute() -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = "id"
        attribute.attributeType = .UUIDAttributeType
        return attribute
    }
    
    private func makeCreatedAtAttribute() -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = "createdAt"
        attribute.attributeType = .dateAttributeType
        return attribute
    }
    
    private func makeAttribute(name: String,
                               type: NSAttributeType,
                               isOptional: Bool = false,
                               defaultValue: Any? = nil) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = type
        attribute.isOptional = isOptional
        attribute.defaultValue = defaultValue
        return attribute
    }
}
