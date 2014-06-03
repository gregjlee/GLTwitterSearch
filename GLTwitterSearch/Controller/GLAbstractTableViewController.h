//
//  GLAbstractTableViewController.h
//  GLTwitterSearch
//
//  Created by Gregory Lee on 5/31/14.
//  Copyright (c) 2014 Greg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLTweetTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import <TSMessage.h>
@interface GLAbstractTableViewController : UIViewController  <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSManagedObjectContext *context;
-(UITableViewCell *)dequeueResuableCellWithClass:(Class)cellClass;
-(id)initWithContext:(NSManagedObjectContext *)context;
@end
