//
//  GLAppDelegate.m
//  GLTwitterSearch
//
//  Created by Gregory Lee on 5/31/14.
//  Copyright (c) 2014 Greg. All rights reserved.
//

#import "GLAppDelegate.h"
#import "GLSearchTweetsViewController.h"
#import "GLSavedTweetsViewController.h"
@interface GLAppDelegate()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *privateContext;
@property (nonatomic, strong) UITabBarController *tabBarController;
@end
@implementation GLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initializeCoreDataStack];
    CGRect screen=[UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:screen];

    self.window.rootViewController=self.tabBarController;
    
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [self saveContext:NO];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveContext:NO];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self saveContext:NO];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self saveContext:NO];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext:NO];

}


-(UITabBarController *)tabBarController{
    if (_tabBarController) {
        return _tabBarController;
    }
    _tabBarController=[[UITabBarController alloc]init];
    GLSearchTweetsViewController *searchTweetsViewController=[[GLSearchTweetsViewController alloc]initWithContext:self.managedObjectContext];
    UINavigationController *searchNav=[[UINavigationController alloc]initWithRootViewController:searchTweetsViewController];
    
    GLSavedTweetsViewController *savedTweetsViewController= [[GLSavedTweetsViewController alloc]initWithContext:self.managedObjectContext];
    UINavigationController *saveNav=[[UINavigationController alloc]initWithRootViewController:savedTweetsViewController];
    _tabBarController.viewControllers=@[searchNav,saveNav];
    return _tabBarController;
    
}

- (void)saveContext:(BOOL)wait
{
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSManagedObjectContext *private = [self privateContext];
    
    if (!moc) return;
    if ([moc hasChanges]) {
        [moc performBlockAndWait:^{
            NSError *error = nil;
            NSAssert([moc save:&error], @"Error saving MOC: %@\n%@",
                    [error localizedDescription], [error userInfo]);
        }];
    }
    
    void (^savePrivate) (void) = ^{
        NSError *error = nil;
        NSAssert([private save:&error], @"Error saving private moc: %@\n%@",
                [error localizedDescription], [error userInfo]);
    };
    
    if ([private hasChanges]) {
        if (wait) {
            [private performBlockAndWait:savePrivate];
        } else {
            [private performBlock:savePrivate];
        }
    }
}




#pragma mark - Core Data stack

- (void)initializeCoreDataStack
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GLTwitterSearch" withExtension:@"momd"];
    NSAssert(modelURL, @"Failed to find model URL");
    
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom, @"Failed to initialize model");
    
    NSPersistentStoreCoordinator *psc = nil;
    psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSAssert(psc, @"Failed to initialize persistent store coordinator");
    
    NSUInteger type = NSPrivateQueueConcurrencyType;
    self.privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
    self.privateContext.persistentStoreCoordinator=psc;
    
    type = NSMainQueueConcurrencyType;
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
    self.managedObjectContext.parentContext=self.privateContext;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *storeURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        storeURL = [storeURL URLByAppendingPathComponent:@"GLTwitterSearch.sqlite"];
        
        NSError *error = nil;
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        if (!store) {
            NSLog(@"Error adding persistent store to coordinator %@\n%@", [error localizedDescription], [error userInfo]);
            //Present a user facing error
        }
        
    });
}


@end
