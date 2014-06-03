#import "_Tweet.h"

@interface Tweet : _Tweet {}
+(NSDictionary *)dictionaryWithKeyChanges;
+(NSDictionary *)dictionaryWithKeysToValueTransforms;

-(void)setData:(NSDictionary *)data;
@end
