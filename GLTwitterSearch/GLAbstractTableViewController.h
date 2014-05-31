//
//  GLAbstractTableViewController.h
//  GLTwitterSearch
//
//  Created by Gregory Lee on 5/31/14.
//  Copyright (c) 2014 Greg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLAbstractTableViewController : UIViewController  <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
-(UITableViewCell *)dequeueResuableCellWithClass:(Class)cellClass;

@end
