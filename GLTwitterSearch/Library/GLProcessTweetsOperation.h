//
//  GLLoadTweetsOperation.h
//  GLTwitterSearch
//
//  Created by Gregory Lee on 6/1/14.
//  Copyright (c) 2014 Greg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Blocks.h"
@interface GLProcessTweetsOperation : NSOperation
- (id)initWithData:(NSData*)data context:(NSManagedObjectContext *)context completion:(ProcessBlock)completion;
@end
