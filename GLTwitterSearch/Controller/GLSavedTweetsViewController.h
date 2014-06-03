//
//  GLSavedTableViewController.h
//  GLTwitterSearch
//
//  Created by Gregory Lee on 6/1/14.
//  Copyright (c) 2014 Greg. All rights reserved.
//

#import "GLAbstractTableViewController.h"

@interface GLSavedTweetsViewController : GLAbstractTableViewController
@property (nonatomic,strong)NSFetchedResultsController *fetchedResultsController;

@end
