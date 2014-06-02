//
//  GLTwitterApiClient.h
//  GLTwitterSearch
//
//  Created by Gregory Lee on 5/31/14.
//  Copyright (c) 2014 Greg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Blocks.h"
@interface GLTwitterApiClient : NSObject
+(GLTwitterApiClient *)sharedClient;
- (void)fetchTweetsForString:(NSString *)search success:(ResponseBlock)success fail:(CompletionBlock)fail;

@end
