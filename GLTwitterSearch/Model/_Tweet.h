// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tweet.h instead.

#import <CoreData/CoreData.h>


extern const struct TweetAttributes {
	__unsafe_unretained NSString *imageURL;
	__unsafe_unretained NSString *text;
	__unsafe_unretained NSString *tweetID;
} TweetAttributes;

extern const struct TweetRelationships {
} TweetRelationships;

extern const struct TweetFetchedProperties {
} TweetFetchedProperties;






@interface TweetID : NSManagedObjectID {}
@end

@interface _Tweet : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TweetID*)objectID;





@property (nonatomic, strong) NSString* imageURL;



//- (BOOL)validateImageURL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* tweetID;



@property int64_t tweetIDValue;
- (int64_t)tweetIDValue;
- (void)setTweetIDValue:(int64_t)value_;

//- (BOOL)validateTweetID:(id*)value_ error:(NSError**)error_;






@end

@interface _Tweet (CoreDataGeneratedAccessors)

@end

@interface _Tweet (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveImageURL;
- (void)setPrimitiveImageURL:(NSString*)value;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;




- (NSNumber*)primitiveTweetID;
- (void)setPrimitiveTweetID:(NSNumber*)value;

- (int64_t)primitiveTweetIDValue;
- (void)setPrimitiveTweetIDValue:(int64_t)value_;




@end
