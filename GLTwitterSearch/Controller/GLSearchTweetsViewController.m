//
//  GLSearchTableViewController.m
//  GLTwitterSearch
//
//  Created by Gregory Lee on 6/1/14.
//  Copyright (c) 2014 Greg. All rights reserved.
//

#import "GLSearchTweetsViewController.h"
#import "GLTwitterApiClient.h"
@interface GLSearchTweetsViewController ()

@end

@implementation GLSearchTweetsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Search";
    // Do any additional setup after loading the view.
}

-(void)handleSearchTweetsTapped:(id)sender{
    NSString *search=@"xmen";
    [GLTwitterApiClient sharedClient] fetchTweetsForString:<#(NSString *)#>
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
