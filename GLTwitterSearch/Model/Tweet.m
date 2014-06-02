#import "Tweet.h"
typedef id (^TransformBlock)(id value);


@interface Tweet ()

// Private interface goes here.

@end


@implementation Tweet

+(NSDictionary *)dictionaryWithKeyChanges{
    NSArray *keys=@[TweetAttributes.tweetID,
                    TweetAttributes.createdAt];
    NSArray *fields= @[@"id",@"created_at"];
    return [NSDictionary dictionaryWithObjects:fields forKeys:keys];
}

+(NSDictionary *)dictionaryWithKeysToValueTransforms{
    NSArray *keys=@[TweetAttributes.createdAt];
    TransformBlock dateTransform=^id(id value){
        return [NSDate date];
    };
    NSArray *transforms= @[dateTransform];
    return [NSDictionary dictionaryWithObjects:transforms forKeys:keys];

}
// Custom logic goes here.

@end
