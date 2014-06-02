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
@property (nonatomic, strong) NSManagedObjectCOntext *privateContext;
@property (nonatomic, strong) UITabBarController *tabBarController;
@end
@implementation GLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initializeCoreDataStack];
    CGRect screen=[UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:screen];

    
    UITabBarController *tabBarController=[[UITabBarController alloc]init];
    
    tabBarController.viewControllers=@[[GLViewController new],[GLViewController new]];
    self.window.rootViewController=[GLViewController new];
    
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

#pragma mark - View Controllers

-(UITabBarController *)tabBarController{
    if (_tabBarController) {
        return _tabBarController;
    }
    
}


#pragma mark - Core Data stack

- (void)initializeCoreDataStack
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PPRecipes" withExtension:@"momd"];
    ZAssert(modelURL, @"Failed to find model URL");
    
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    ZAssert(mom, @"Failed to initialize model");
    
    NSPersistentStoreCoordinator *psc = nil;
    psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    ZAssert(psc, @"Failed to initialize persistent store coordinator");
    
    NSManagedObjectContext *private = nil;
    NSUInteger type = NSPrivateQueueConcurrencyType;
    private = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
    [private setPersistentStoreCoordinator:psc];
    
    type = NSMainQueueConcurrencyType;
    NSManagedObjectContext *moc = nil;
    moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
    [moc setParentContext:private];
    [self setPrivateContext:private];
    
    [self setManagedObjectContext:moc];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *storeURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        storeURL = [storeURL URLByAppendingPathComponent:@"PPRecipes.sqlite"];
        
        NSError *error = nil;
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        if (!store) {
            ALog(@"Error adding persistent store to coordinator %@\n%@", [error localizedDescription], [error userInfo]);
            //Present a user facing error
        }
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Type"];
        
        [moc performBlockAndWait:^{
            NSError *error = nil;
            NSInteger count = [[self managedObjectContext] countForFetchRequest:request error:&error];
            ZAssert(count != NSNotFound || !error, @"Failed to count type: %@\n%@", [error localizedDescription], [error userInfo]);
            
            if (count) return;
            
            NSArray *types = [[[NSBundle mainBundle] infoDictionary] objectForKey:ppRecipeTypes];
            
            for (NSString *recipeType in types) {
                NSManagedObject *typeMO = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:moc];
                [typeMO setValue:recipeType forKey:@"name"];
            }
            
            ZAssert([moc save:&error], @"Error saving moc: %@\n%@", [error localizedDescription], [error userInfo]);
        }];
        
        [self contextInitialized];
    });
}


@end
