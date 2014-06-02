//
//  GLTwitterApiClient.m
//  GLTwitterSearch
//
//  Created by Gregory Lee on 5/31/14.
//  Copyright (c) 2014 Greg. All rights reserved.
//

#import "GLTwitterApiClient.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
@interface GLTwitterApiClient ()
@property (nonatomic,strong) ACAccountStore *accountStore;
@end
@implementation GLTwitterApiClient
+ (GLTwitterApiClient *)sharedClient {
    
    static GLTwitterApiClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[self alloc] init];
    });
    
    return _sharedClient;
}

-(id)init{
    self=[super init];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}


- (void)fetchTweetsForString:(NSString *)search
{
    if (![self userHasAccessToTwitter]) {
        return;
    }

    ACAccountType *twitterAccountType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:
     ACAccountTypeIdentifierTwitter];
    
    [self.accountStore
     requestAccessToAccountsWithType:twitterAccountType
     options:NULL
     completion:^(BOOL granted, NSError *error) {
         if (granted) {
             //  Step 2:  Create a request
             NSArray *twitterAccounts =
             [self.accountStore accountsWithAccountType:twitterAccountType];
             NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
             NSDictionary *params = @{@"q" : search};
             SLRequest *request =
             [SLRequest requestForServiceType:SLServiceTypeTwitter
                                requestMethod:SLRequestMethodGET
                                          URL:url
                                   parameters:params];
             
             //  Attach an account to the request
             [request setAccount:[twitterAccounts lastObject]];
             
             //  Step 3:  Execute the request
             [request performRequestWithHandler:
              ^(NSData *responseData,
                NSHTTPURLResponse *urlResponse,
                NSError *error) {
                  
                  if (responseData) {
                      if (urlResponse.statusCode >= 200 &&
                          urlResponse.statusCode < 300) {
                          
                          NSError *jsonError;
                          NSDictionary *timelineData =
                          [NSJSONSerialization
                           JSONObjectWithData:responseData
                           options:NSJSONReadingAllowFragments error:&jsonError];
                          if (timelineData) {
                              NSArray *tweets=timelineData[@"statuses"];
                              for (NSDictionary *tweet in tweets) {
                                  NSLog(@"tweet %@ %@",tweet[@"id"],tweet[@"text"]);
                              }
                          }
                          else {
                              // Our JSON deserialization went awry
                              NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                          }
                      }
                      else {
                          // The server did not respond ... were we rate-limited?
                          NSLog(@"The response status code is %d",
                                urlResponse.statusCode);
                      }
                  }
              }];
         }
         else {
             // Access was not granted, or an error occurred
             NSLog(@"%@", [error localizedDescription]);
         }
     }];
}

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController
            isAvailableForServiceType:SLServiceTypeTwitter];
}


@end
