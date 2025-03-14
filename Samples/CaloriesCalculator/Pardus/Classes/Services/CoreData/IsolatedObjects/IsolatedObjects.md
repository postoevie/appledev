# Isolated Objects

Service incapsulating changes of Managed Object contexts in a thread-safe manner. 

## Overview

CoreData obliges clients to use managed objects only within their contexts and perform its opearations only on owning queue. Since violating these rules can lead to barely reproducable bugs, crashes and other issues, emerges motivation to encapsulate an access to Managed Object context or at least to make its usage safer.

An attempt to conform to these conditions with isolating contexts resulted in develpment of **CoreDataEntityService**. The safety is supported using models(structs) representing managed object attrubutes and relationships. Service leverages mappings provided by user to map these models to Managed objects and vice versa to implement CRUD operations.

On a fetch, the service accepts predicate and fetches data from a context mapping it to associated structs. But there are scenarios when managed objects should be kept in the memory to gain faster access (it has speed advantage over CoreData own cache). The **CoreDataInMemoryCache** is developed for this scenario.

**CoreDataRestorationStore** is developed to store contexts and caches in memory to avoid loss of changes. Using in SUI navigation has no sence since View's memory tree is preserved between re-renders on changing navigation path (despite assemply builds are called). 

Despite access to contexts become isolated and safe, these restrictions lead to inability to use CoreData features like faulting, increases complexity, makes working with relations unoptimized and hard to support. This makes it usable in limited set of scenarios with a simple schemas set, a few data and not requiring much performance. For instance, it makes impossible to update single property without populating all the props and things become worse if relationship tree is complex or contains circular references. 

During implementing the service, I made sure that it could be optimal solution not to incapsulate Managed Context in single service but rather restrict by code conventions to return managed objects to classes which potentially could use it in non-correct thread.
For instance, in MVP some use-case service could keep list of managed objects and return mapped structs to the presenter. 
