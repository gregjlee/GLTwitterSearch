//
//  GLViewController.m
//  GLTwitterSearch
//
//  Created by Gregory Lee on 5/31/14.
//  Copyright (c) 2014 Greg. All rights reserved.
//

#import "GLViewController.h"
#import "GLTwitterApiClient.h"
@interface GLViewController ()

@end

@implementation GLViewController
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[GLTwitterApiClient sharedClient] fetchTweetsForString:@"xmen"];

    
	// Do any additional setup after loading the view, typically from a nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
