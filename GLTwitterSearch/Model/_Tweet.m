// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tweet.m instead.

#import "_Tweet.h"

const struct TweetAttributes TweetAttributes = {
	.createdAt = @"createdAt",
	.saved = @"saved",
	.text = @"text",
	.tweetID = @"tweetID",
};

const struct TweetRelationships TweetRelationships = {
};

const struct TweetFetchedProperties TweetFetchedProperties = {
};

@implementation TweetID
@end

@implementation _Tweet

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Tweet";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:moc_];
}

- (TweetID*)objectID {
	return (TweetID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"savedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"saved"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"tweetIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"tweetID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic createdAt;






@dynamic saved;



- (BOOL)savedValue {
	NSNumber *result = [self saved];
	return [result boolValue];
}

- (void)setSavedValue:(BOOL)value_ {
	[self setSaved:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSavedValue {
	NSNumber *result = [self primitiveSaved];
	return [result boolValue];
}

- (void)setPrimitiveSavedValue:(BOOL)value_ {
	[self setPrimitiveSaved:[NSNumber numberWithBool:value_]];
}





@dynamic text;






@dynamic tweetID;



- (int64_t)tweetIDValue {
	NSNumber *result = [self tweetID];
	return [result longLongValue];
}

- (void)setTweetIDValue:(int64_t)value_ {
	[self setTweetID:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveTweetIDValue {
	NSNumber *result = [self primitiveTweetID];
	return [result longLongValue];
}

- (void)setPrimitiveTweetIDValue:(int64_t)value_ {
	[self setPrimitiveTweetID:[NSNumber numberWithLongLong:value_]];
}










@end
