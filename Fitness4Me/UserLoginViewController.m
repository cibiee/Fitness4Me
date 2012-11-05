//
//  UserLoginViewController.m
//  Fitness4Me
//
//  Created by Ciby on 01/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserLoginViewController.h"
#import "InitialAppLaunchViewController.h"
#import "NSString+Config.h"
#import "Reachability.h"
#import "FitnessServerCommunication.h"
#import "Fitness4MeUtils.h"

#define kOFFSET_FOR_KEYBOARD 110;

@implementation UserLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        
    }
    return self;
}

#pragma mark - view oveloaded Method


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [Fitness4MeUtils showAdMobPrelogin:self];
    
    [[UIApplication sharedApplication]  registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert)];
    
    [activityIndicator setHidden:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



#pragma mark - Private Methods

- (void)parseUserDetails:(NSMutableArray *)itemsarray
{
    
    [itemsarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* item = obj;
        userID=[[item objectForKey:@"id"]intValue];
        if (userID>0) {
            [self saveUser:[item objectForKey:@"username"] nameOfTheUser:[item objectForKey:@"fname"] levelofExpertise: [item objectForKey:@"level"] mailIdOfTheUser:[item objectForKey:@"email"] hasDoneFullPruchase:[item objectForKey:@"fullpurchase"]];
            
            [Fitness4MeUtils registerDevice:signUpView];
            [self termainateActivityIndicator];
            [self updateData];
            [Fitness4MeUtils navigateToHomeView:self];
        }
        else {
            NSString *message;
            message=[item objectForKey:@"message"];
            if([message length]==0){
                message=NSLocalizedString(@"NoInternetMessage", nil);
            }
            
            [self termainateActivityIndicator];
            [Fitness4MeUtils showAlert:message];
        }
    }];
}

-(void)doLogIn
{
    urlPath =[NSString GetURlPath];
    userID=0;
    
    if (usernameTextField.text.length ==0 ||passwordTextField.text.length ==0){
        [Fitness4MeUtils showAlert:NSLocalizedString(@"UsernameNull", nil)];
        [signUpView removeFromSuperview];
    }
    else
    {
        
        BOOL isReachable =[Fitness4MeUtils isReachable];
        if (isReachable){
            
            NSString *requestString =[NSString stringWithFormat:@"%@login=yes&username=%@&password=%@", urlPath,usernameTextField.text,passwordTextField.text];
            
            
            NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            ASIFormDataRequest   *request = [ASIFormDataRequest   requestWithURL:url];
            [request startSynchronous];
            
            NSError *error = [request error];
            
            if (!error){
                
                NSString *response = [request responseString];
                if ([response length]>0){
                    NSMutableArray *object = [response JSONValue];
                    NSMutableArray *itemsarray =[object valueForKey:@"items"];
                    [self parseUserDetails:itemsarray];
                }
                else{
                    
                    [self termainateActivityIndicator];
                    [Fitness4MeUtils showAlert:NSLocalizedString(@"slowdata", nil)];
                }
            }
            else{
                [self termainateActivityIndicator];
                [Fitness4MeUtils showAlert:NSLocalizedString(@"requestError", nil)];
            }
        }
        else {
            [self termainateActivityIndicator];
            [Fitness4MeUtils showAlert:NSLocalizedString(@"NoInternetMessage", nil)];
        }
    }
}

-(void)navigateToHomeView
{
    Fitness4MeViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[Fitness4MeViewController alloc]initWithNibName:@"Fitness4MeViewController" bundle:nil];
    }
    else{
        viewController =[[Fitness4MeViewController alloc]initWithNibName:@"Fitness4MeViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}


-(void)updateData
{
    
    if (userID>0){
        
        FitnessServerCommunication *fitnessserverCommunication =[[FitnessServerCommunication alloc]init];
        [fitnessserverCommunication parseFitnessDetails:userID];
        [fitnessserverCommunication getFreePurchaseCount:userID];
    }
    
}


-(void)termainateActivityIndicator
{
    [signUpView removeFromSuperview];
    [activityIndicator setHidden:YES];
    [activityIndicator stopAnimating];
}


-(void)saveUser:(NSString *)username nameOfTheUser:(NSString *) name levelofExpertise :(NSString *)userlevel  mailIdOfTheUser:
(NSString *)email  hasDoneFullPruchase :(NSString *)fullpurchase
{
    UserDB *userDB =[[UserDB alloc]init];
    [userDB setUpDatabase];
    [userDB createDatabase];
    User *user = [[[User alloc]initWithUserID:userID UserName:username Name:name andLevel:userlevel]autorelease];
    [userDB insertUser:user];
    [userDB release];
    
    NSUserDefaults *userInfo =[NSUserDefaults standardUserDefaults];
    [userInfo setObject:userlevel  forKey:@"Userlevel"];
    [userInfo setObject:name forKey:@"Name"];
    [userInfo setObject:username forKey:@"Username"];
    [userInfo setObject:passwordTextField.text forKey:@"password"];
    [userInfo setInteger:userID  forKey:@"UserID"];
    [userInfo setObject:email  forKey:@"email"];
    [userInfo setObject:fullpurchase forKey:@"hasMadeFullPurchase"];
    
}

-(void)registerDevice
{
    
    NSString *devToken;
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    devToken =[userinfo stringForKey:@"deviceToken"];
    UIDevice *dev = [UIDevice currentDevice];
	NSString *deviceUuid = dev.uniqueIdentifier;
    NSString *requestUrl =[NSString stringWithFormat:@"%@iphone_register.php?deviceregister=yes&userid=%i&devicetoken=%@&deviceuid=%@",[NSString getDeviceRegisterPath],userID,devToken,deviceUuid];
    NSURL *urlrequest =[NSURL URLWithString:requestUrl];
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        
        
        ASIFormDataRequest   *request = [ASIFormDataRequest   requestWithURL:urlrequest];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error)
        {
            NSString *response = [request responseString];
            if ([response length]>0)
            {
                
            }
        }
    }
    
    else {
        
        [Fitness4MeUtils showAlert:NSLocalizedString(@"NoInternetMessage", nil)];
        [signUpView removeFromSuperview];
    }
}


#pragma mark -textfieldDelgates


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(usernameTextField ==textField){
        if (usernameTextField.text.length>0){
            [passwordTextField becomeFirstResponder];
        }
        else{
            [Fitness4MeUtils showAlert:NSLocalizedString(@"mandatory", nil)];
            [usernameTextField becomeFirstResponder];
        }
    }
    
    if(passwordTextField ==textField){
        
        if (passwordTextField.text.length>0){
            [textField resignFirstResponder];
        }
        else{
            [Fitness4MeUtils showAlert:NSLocalizedString(@"mandatory", nil)];
            [passwordTextField becomeFirstResponder];
        }
    }
    [textField resignFirstResponder];
    return NO;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [Fitness4MeUtils setViewMovedUp:YES:self.view:YES:110];
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [Fitness4MeUtils setViewMovedUp:NO:self.view:NO:110];
}

#pragma mark - Instance Methods

-(IBAction)dismissKeyboardAway
{
    [usernameTextField resignFirstResponder ];
    [passwordTextField resignFirstResponder] ;
}



-(IBAction)onNavigateToHomeView:(id)sender
{
    InitialAppLaunchViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController=[[InitialAppLaunchViewController alloc]initWithNibName:@"InitialAppLaunchViewController" bundle:nil];
    }
    else{
        viewController = [[InitialAppLaunchViewController alloc]initWithNibName:@"InitialAppLaunchViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}


-(IBAction)onclickLogin:(id)sender
{
    [self dismissKeyboardAway];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        signUpView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        
    }
    else {
        signUpView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1004)];
    }
    [signUpView addSubview:activityIndicator];
    signUpView.backgroundColor=[UIColor blackColor];
    signUpView.alpha=0.5;
    [activityIndicator setHidden:NO];
    [activityIndicator startAnimating];
    [self.view addSubview:signUpView];
    [self performSelector:@selector(doLogIn) withObject:nil afterDelay:0.5];
}

#pragma mark - view orientation Methods


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate {
    return NO;
}



@end