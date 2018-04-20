//
// VTDCoreDataStore.h
//
// Copyright (c) 2014 Mutual Mobile (http://www.mutualmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

@import Foundation;
@import CoreData;

typedef void(^CoreDataStoreFetchCompletionBlock)(NSArray *results);
typedef void(^CoreDataStoreSaveCompletion)(BOOL saved, NSError *error);

static NSString * const CoreDataStorePurgeUserDataNotification = @"CoreDataStorePurgeUserDataNotification";
static NSString * const CoreDataStoreRecordDefaultFileName = @"CoreDataStore.sqlite";

/**
 *  Merge and notification behaviour Core Data Stack
 *  - CRUD operations goes in the backgroundManagedObjectContext, after operations, send the NSManagedObjectContextDidSaveNotification
 *  - Listening for the updated changes is performed on the managedObjectContext, by listening for the NSManagedObjectContextDidSaveNotification
 *    and do a mergeChangesFromContextDidSaveNotification
 *  - Fetches uses the main managedObjectContext to...
 */
@interface CoreDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataStore *)sharedInstance;

#pragma mark Saving

- (void)saveIntoMainContext;
- (BOOL)saveIntoContext:(NSManagedObjectContext*)context;
- (void)saveDataIntoMainContextUsingBlock:(CoreDataStoreSaveCompletion)savedBlock;
- (void)saveDataIntoContext:(NSManagedObjectContext*)context usingBlock:(CoreDataStoreSaveCompletion)savedBlock;

#pragma mark CRUD

- (id)createEntryWithEntityName:(NSString *)className
           attributesDictionary:(NSDictionary *)attributesDictionary;
- (id)createEntryWithEntityName:(NSString *)className
           attributesDictionary:(NSDictionary *)attributesDictionary
         inManagedObjectContext:(NSManagedObjectContext *)context;
- (void)deleteEntity:(NSManagedObject *)entity;
- (void)deleteAllFromEntity:(NSString *)entityName NS_AVAILABLE_IOS(9_0);
- (void)deleteEntity:(NSManagedObject *)entity inManagedObjectContext:(NSManagedObjectContext *)context;
- (void)deleteAllFromEntity:(NSString *)entityName inManagedObjectContext:(NSManagedObjectContext *)context NS_AVAILABLE_IOS(9_0);

#pragma mark Fetching

- (void)fetchEntriesForEntityName:(NSString *)entityName
                   withPredicate:(NSPredicate *)predicate
                 sortDescriptors:(NSArray *)sortDescriptors
                 completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock;
- (void)fetchEntriesForEntityName:(NSString *)entityName
                   withPredicate:(NSPredicate *)predicate
                 sortDescriptors:(NSArray *)sortDescriptors
            managedObjectContext:(NSManagedObjectContext *)context
                 completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock;
- (void)fetchEntriesForEntityName:(NSString *)entityName
                   withPredicate:(NSPredicate *)predicate
                 sortDescriptors:(NSArray *)sortDescriptors
            managedObjectContext:(NSManagedObjectContext *)context
                    asynchronous:(BOOL)asynchronous
                 completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock;


- (void)fetchEntriesForEntityName:(NSString *)entityName
                    withPredicate:(NSPredicate *)predicate
                  sortDescriptors:(NSArray *)sortDescriptors
             managedObjectContext:(NSManagedObjectContext *)context
                     asynchronous:(BOOL)asynchronous
                       fetchLimit:(NSInteger)fetchLimit
                  completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock;
@end

@interface CoreDataStore (Parsing)

/**
 *  @return Temporary moc for model parsing purposes
 */
- (NSManagedObjectContext *)temporaryMOC;

@end

@interface CoreDataStore (NSFecthedResultsController)

- (BOOL)uniqueAttributeForEntityName:(NSString *)className
                      attributeName:(NSString *)attributeName
                     attributeValue:(id)attributeValue;

- (NSFetchedResultsController *)controllerWithEntitiesName:(NSString *)className
                                                 predicate:(NSPredicate *)predicate
                                           sortDescriptors:(NSArray *)sortDescriptors
                                                 batchSize:(NSUInteger)batchSize
                                        sectionNameKeyPath:(NSString *)sectionNameKeypath
                                                 cacheName:(NSString *)cacheName;

- (NSFetchedResultsController *)fetchEntitiesWithClassName:(NSString *)className
                                                 predicate:(NSPredicate *)predicate
                                           sortDescriptors:(NSArray *)sortDescriptors
                                                 batchSize:(NSUInteger)batchSize
                                        sectionNameKeyPath:(NSString *)sectionNameKeypath
                                                 cacheName:(NSString *)cacheName;

@end
