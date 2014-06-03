//
//  GLSearchTableViewController.m
//  GLTwitterSearch
//
//  Created by Gregory Lee on 6/1/14.
//  Copyright (c) 2014 Greg. All rights reserved.
//

#import "GLSearchTweetsViewController.h"
#import "GLTwitterApiClient.h"
@interface GLSearchTweetsViewController ()<UIAlertViewDelegate>
@property (nonatomic,strong)NSArray *results;
@end

@implementation GLSearchTweetsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.results=@[];
    UIBarButtonItem *searchItem=[[UIBarButtonItem alloc]initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(handleSearchTapped:)];
    self.navigationItem.rightBarButtonItem=searchItem;
    [self fetchTweetsWithSearchText:@"ios 8"];
}

-(void)fetchTweetsWithSearchText:(NSString *)searchText{
    [[GLTwitterApiClient sharedClient] fetchTweetsForString:searchText success:^(id result) {
        
        [TSMessage showNotificationInViewController:self title:[NSString stringWithFormat:@"searched %@",searchText] subtitle:nil type:TSMessageNotificationTypeSuccess duration:TSMessageNotificationDurationAutomatic canBeDismissedByUser:YES];

        self.results=result;
        [self.tableView reloadData];
    } fail:^(NSString *title, NSString *subtitle){
        
        [TSMessage showNotificationInViewController:self title:title subtitle:subtitle type:TSMessageNotificationTypeError duration:TSMessageNotificationDurationEndless canBeDismissedByUser:YES];
        NSLog(@"fail search %@",searchText);
    }];
}


-(void)handleSearchTapped:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Search Tweets"
                              message:@"Please enter words to search"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Search", nil];
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

#pragma mark -
#pragma mark UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    return self.results.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLTweetTableViewCell *cell=(GLTweetTableViewCell *)[self dequeueResuableCellWithClass:[GLTweetTableViewCell class]];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tweetData=self.results[indexPath.row];
    cell.textLabel.text=tweetData[@"text"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *user= tweetData[@"user"];
    NSString *urlString=user[@"profile_image_url"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
}


#pragma mark -
#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict=self.results[indexPath.row];
    Tweet *tweet= [NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:self.context];
    [tweet setData:dict];
    [TSMessage showNotificationInViewController:self title:@"Tweet Saved!" subtitle:nil type:TSMessageNotificationTypeSuccess];

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
