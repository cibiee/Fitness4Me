//
//  ShareFitness4MeViewController.m
//  Fitness4Me
//
//  Created by Ciby K Jose on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShareFitness4MeViewController.h"


@implementation ShareFitness4MeViewController

@synthesize facebookName = _facebookName;

@synthesize imageName,imageUrl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - Viewoverriden Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.transform = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeRotation(M_PI_2));
    slownetView.layer.cornerRadius=14;
    slownetView.layer.borderWidth = 1;
    slownetView.layer.borderColor = [[UIColor greenColor] CGColor];
    slownetView .backgroundColor =[UIColor clearColor];
    [self InitializeView];
    
    static NSString* kApiKey = @"447892125262110";
    
    // Initialize Facebook
    permissions = [[NSArray alloc] initWithObjects:@"offline_access", @"read_stream", @"publish_stream", nil];
    
    facebook = [[Facebook alloc] initWithAppId:kApiKey andDelegate:self];
    
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
}


- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Hidden Intance Methods

- (void)showImage
{
    if ([Fitness4MeUtils isReachable]) {
        [Fitness4MeUtils createDirectoryatPath:dataPath];
        storeURL= [dataPath stringByAppendingPathComponent :imageName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:storeURL]){
            
            NSURL * imageURL = [NSURL URLWithString:self.imageUrl];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            excersiceImageHolder.image = [UIImage imageWithData:imageData];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.imageUrl]];
            [request setDownloadDestinationPath:storeURL];
            [request setDelegate:self];
            [request startAsynchronous];
        }else {
            UIImage *im =[[UIImage alloc]initWithContentsOfFile:storeURL];
            excersiceImageHolder.image=im;
        }
    }
            else{
        storeURL= [dataPath stringByAppendingPathComponent :[self imageName]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:storeURL]){
            UIImage *im =[[UIImage alloc]initWithContentsOfFile:storeURL];
            excersiceImageHolder.image=im;
            [im release];
        }else{
            UIImage *im =[UIImage imageNamed:@"dummyimg.png"];
            excersiceImageHolder.image =im;
        }
    }
}

-(void)InitializeView
{
    
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    name=[userinfo stringForKey:@"Name"];
    NSString *workoutName=[userinfo stringForKey:@"WorkoutName"];
    NSString *workoutType=[userinfo stringForKey:@"workoutType"];
    NSString *msg;
    if ([Fitness4MeUtils getApplicationLanguage] ==1) {
         msg =[NSString stringWithFormat:@" just completed the %@ fitness4.me ",workoutType];
    }else{
         msg =[NSString stringWithFormat:@" just completed the %@ fitness4.me ",workoutType];
    }
   
    msg =[name stringByAppendingString:msg];
    shareAppMessageTextView.text=[msg stringByAppendingString:workoutName];
    dataPath =[Fitness4MeUtils path];

    [self showImage];
}


-(void)navigateToHome
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"fitness4.me" message:NSLocalizedString(@"ExitMsg", nil)
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertview show];
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.0];
    alertview.transform = CGAffineTransformRotate(alertview.transform, 3.14159/2);
    [UIView commitAnimations];
    [alertview release];
    
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    // UIAlertView in landscape mode
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.0];
    alertView.transform = CGAffineTransformRotate(alertView.transform, 3.14159/2);
    [UIView commitAnimations];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [Fitness4MeUtils navigateToHomeView:self];
    }
    else {
        exit(0);
    }
}


#pragma mark - Instance Methods

-(IBAction)shareAppOnTwitter :(id)sender{
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
    if([TWTweetComposeViewController canSendTweet]) {
        
        TWTweetComposeViewController *controller = [[TWTweetComposeViewController alloc] init];
        controller.view.transform = CGAffineTransformConcat( controller.view.transform, CGAffineTransformMakeRotation(M_PI_2));
        NSString *pageLink = @"http://fitness4.Me/"; // replace it with yours
        NSString *fbPagelink = @"https://www.facebook.com/fitness4.Me"; // replate it with yours
        [controller setInitialText:shareAppMessageTextView.text];
        [controller addImage: excersiceImageHolder.image];
        [controller  addURL:[NSURL URLWithString:pageLink]];
        [controller  addURL:[NSURL URLWithString:fbPagelink]];
        [controller setEditing:NO];
        controller.completionHandler = ^(TWTweetComposeViewControllerResult result)  {
            
            [self dismissModalViewControllerAnimated:YES];
            
            switch (result) {
                case TWTweetComposeViewControllerResultCancelled:
                    break;
                    
                case TWTweetComposeViewControllerResultDone:
                    break;
                    
                default:
                    break;
            }
        };
        
        
        [self presentModalViewController:controller animated:YES];
        [controller setEditing:NO];
        [controller release];
    }
    
    else{
        [Fitness4MeUtils showAlert:NSLocalizedString(@"twitterConfigure", nil)];
    }
    }
    else {
        [Fitness4MeUtils showAlert:NSLocalizedString(@"NoInternetMessage", nil)];
        
    }
}


-(IBAction)shareAppOnFacebook :(id)sender{
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        [self login];
    }
    else {
        [Fitness4MeUtils showAlert:NSLocalizedString(@"NoInternetMessage", nil)];
    }
}


-(IBAction)EditText :(id)sender{
    
    [shareAppMessageTextView setEditable:YES];
}



-(IBAction)navigateBackHome
{
    [Fitness4MeUtils navigateToHomeView:self];
}

#pragma mark - Private Helper Methods for facebook


- (void)apiFQLIMe {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name, pic FROM user WHERE uid=me()", @"query",
                                   nil];
    [facebook requestWithMethodName:@"fql.query"
                          andParams:params
                      andHttpMethod:@"POST"
                        andDelegate:self];
}

- (void)apiGraphUserPermissions {
    [facebook requestWithGraphPath:@"me/permissions" andDelegate:self];
}



- (void)showLoggedIn {
    
    [self apiFQLIMe];
}

- (void)showLoggedOut {
}

- (void)login {
    if (![facebook isSessionValid]) {
        [facebook authorize:permissions];
    } else {
        [self apiDialogFeedUser];
        
    }
}

- (void)logout {
    [facebook logout];
}


#pragma mark - FBSessionDelegate Methods

- (void)fbDidLogin {
    [self apiDialogFeedUser];
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    
    // [self storeAuthData:accessToken expiresAt:expiresAt];
}

-(void)fbDidNotLogin:(BOOL)cancelled {
    //   [pendingApiCallsController userDidNotGrantPermission];
}

- (void)fbDidLogout {
    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self showLoggedOut];
}

- (void)fbSessionInvalidated {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [alertView release];
    [self fbDidLogout];
}

#pragma mark - FBRequestDelegate Methods

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    
    if ([result objectForKey:@"name"]) {
        [self apiGraphUserPermissions];
    } else {
        
    }
}

- (void)apiDialogFeedUser {
    
    NSString *msg =shareAppMessageTextView.text;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"fitness4.Me", @"name",@"Fitness Program.", @"caption",msg, @"message",@"http://fitness4.Me/", @"link",imageUrl, @"picture",nil];
    [facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"Err code: %d", [error code]);
}


#pragma mark - view orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(BOOL)shouldAutorotate {
    return NO;
}


@end
