//
//  Blocks.h
//  GLTwitterSearch
//
//  Created by Gregory Lee on 6/2/14.
//  Copyright (c) 2014 Greg. All rights reserved.
//

#ifndef GLTwitterSearch_Blocks_h
#define GLTwitterSearch_Blocks_h
typedef void (^ProcessBlock)(BOOL success, NSError *error);
typedef void (^CompletionBlock)();
typedef void (^ResponseBlock)(id result);
typedef void (^MessageBlock)(NSString *Title, NSString *subtitle);
typedef id (^TransformBlock)(id value);


#endif
