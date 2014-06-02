//
//  GLSearchTableViewController.m
//  GLTwitterSearch
//
//  Created by Gregory Lee on 6/1/14.
//  Copyright (c) 2014 Greg. All rights reserved.
//

#import "GLSearchTweetsViewController.h"
#import "GLTwitterApiClient.h"
#import "GLProcessTweetsOperation.h"
@interface GLSearchTweetsViewController ()<UIAlertViewDelegate>

@end

@implementation GLSearchTweetsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Search";
    UIBarButtonItem *searchItem=[[UIBarButtonItem alloc]initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(handleSearchTapped:)];
    self.navigationItem.rightBarButtonItem=searchItem;
    // Do any additional setup after loading the view.
}

-(void)fetchTweetsWithSearchText:(NSString *)searchText{
    [[GLTwitterApiClient sharedClient] fetchTweetsForString:searchText success:^(id result) {
        [self processTweetData:result];
    } fail:^{
        NSLog(@"fail search %@",searchText);
    }];
}

-(void)processTweetData:(id)data{
    GLProcessTweetsOperation *operation= [[GLProcessTweetsOperation alloc] initWithData:data context:self.context completion:^(BOOL success, NSError *error) {
        
    }];
    [[NSOperationQueue mainQueue] addOperation:operation];

}

-(void)handleSearchTapped:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"New Saved Search"
                              message:@"Please enter a name for this search"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Save", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [alertView show];

}

#pragma mark - alert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        return;
    }
    UITextField *textField=[alertView textFieldAtIndex:0];
    NSString *searchText=textField.text;
    //validate text
    [self fetchTweetsWithSearchText:searchText];
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
