#import "Tweet.h"
typedef id (^TransformBlock)(id value);


@interface Tweet ()

// Private interface goes here.

@end


@implementation Tweet

+(NSDictionary *)dictionaryWithKeyChanges{
    NSArray *keys=@[TweetAttributes.tweetID,
                    TweetAttributes.imageURL];
    NSArray *fields= @[@"id",@"user"];
    return [NSDictionary dictionaryWithObjects:fields forKeys:keys];
}

+(NSDictionary *)dictionaryWithKeysToValueTransforms{
    NSArray *keys=@[TweetAttributes.imageURL];
    TransformBlock imageTransform=^id(id value){
        NSDictionary *user=value;
        return user[@"profile_image_url"];
    };

    NSArray *transforms= @[imageTransform];
    return [NSDictionary dictionaryWithObjects:transforms forKeys:keys];

}

-(void)setData:(NSDictionary *)dict{
    NSDictionary *keyChanges=[Tweet dictionaryWithKeyChanges];
    NSDictionary *valueTransforms = [Tweet dictionaryWithKeysToValueTransforms];
    
    NSEntityDescription *entity = [self entity];
    NSArray *attributeKeys = [[entity attributesByName] allKeys];
    for (NSString *key in attributeKeys) {
        NSString *adjustedKey=key;
        if ([keyChanges.allKeys containsObject:key]) {
            adjustedKey=keyChanges[key];
        }
        id value=dict[adjustedKey];
        if ([valueTransforms.allKeys containsObject:key]) {
            TransformBlock transform=valueTransforms[key];
            value=transform(value);
        }
        [self setValue:value forKey:key];
        
    }


    
}

// Custom logic goes here.

@end
