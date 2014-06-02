//
//  GLLoadTweetsOperation.m
//  GLTwitterSearch
//
//  Created by Gregory Lee on 6/1/14.
//  Copyright (c) 2014 Greg. All rights reserved.
//

#import "GLProcessTweetsOperation.h"

@interface GLProcessTweetsOperation()
@property (nonatomic, strong) NSData *incomingData;
@property (nonatomic, copy) Proc completionBlock;
@property (nonatomic, weak) NSManagedObjectContext *mainContext;

@end
@implementation GLProcessTweetsOperation
- (id)initWithData:(NSData*)data context:(NSManagedObjectContext *)context completion:(CompletionBlock)completion {
    if (!(self = [super init])) return nil;
    _incomingData=data;
    _mainContext=context;
    _completionBlock=completion;
    return self;
}


- (void)main
{
    NSManagedObjectContext *localContext = nil;
    NSUInteger type = NSConfinementConcurrencyType;
    localContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
    [localContext setParentContext:self.mainContext];
    
    NSError *error = nil;
    id tweetsJSON = [NSJSONSerialization JSONObjectWithData:[self incomingData]
                                                  options:0
                                                    error:&error];
    if (!tweetsJSON && error) {
        [self completionBlock](NO, error);
        return;
    }
    
    NSString *entityName=@"Tweet";
    NSManagedObject *tweet;
    NSDictionary *keyChanges=[Tweet dictionaryWithKeyChanges];
    NSDictionary *valueTransforms = [Tweet dictionaryWithKeysToValueTransforms];
    
    
    //delete all for now
    NSArray *oldObjects=[self loadObjectsWithEntityName:entityName predicate:nil context:localContext];
    for (NSManagedObject *oldObject in oldObjects) {
        [localContext deleteObject:oldObject];
    }
    
    
    void(^saveBlock)() = ^ {
        NSError *error = nil;
        NSAssert([localContext save:&error], @"Error saving context: %@\n%@",
                 [error localizedDescription], [error userInfo]);
        if (self.completionBlock) {
            self.completionBlock(YES,nil);
        }
    };
    
    if ([tweetsJSON isKindOfClass:[NSDictionary class]]) {
        tweet = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                 inManagedObjectContext:localContext];
        
        [self populateManagedObject:tweet fromDictionary:tweetsJSON keyChanges:keyChanges valueTransforms:valueTransforms];
        saveBlock();
        return;
    }
    
    NSAssert([tweetsJSON isKindOfClass:[NSArray class]],
             @"Unknown structure root: %@", [tweetsJSON class]);
    for (id tweetDict in tweetsJSON) {
        NSAssert([tweetDict isKindOfClass:[NSDictionary class]],
                 @"Unknown tweet structure: %@", [tweetDict class]);
        tweet = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                              inManagedObjectContext:localContext];
        
        [self populateManagedObject:tweet fromDictionary:tweetDict keyChanges:keyChanges valueTransforms:valueTransforms];
    }
    saveBlock();

    
    
}

- (void)populateManagedObject:(NSManagedObject*)managedObject
               fromDictionary:(NSDictionary*)dict keyChanges:(NSDictionary *)keyChanges valueTransforms:(NSDictionary *)transforms;
{
    NSEntityDescription *entity = [managedObject entity];
    NSArray *attributeKeys = [[entity attributesByName] allKeys];
    for (NSString *key in attributeKeys) {
        NSString *adjustedKey=key;
        if ([keyChanges.allKeys containsObject:key]) {
            adjustedKey=keyChanges[key];
        }
        id value=dict[adjustedKey];
        if ([transforms.allKeys containsObject:key]) {
            TransformBlock transform=transforms[key];
            value=transform(value);
        }
        [managedObject setValue:value forKey:key];
        
    }
}

-(NSArray *)loadObjectsWithEntityName:(NSString *)className predicate:(NSPredicate*)predicate context:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    if (predicate) {
        fetchRequest.predicate=predicate;
    }
    NSError *error = nil;

    NSArray *result=[context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"fetch error %@ %@",className, error);
    }
    return  result;
    
}



@end
