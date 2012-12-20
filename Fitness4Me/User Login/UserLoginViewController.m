//
//  UserLoginViewController.m
//  Fitness4Me
//
//  Created by Ciby on 01/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserLoginViewController.h"


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
    [[UIApplication sharedApplication]  registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert)];
    [activityIndicator setHidden:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



#pragma mark - Private Methods

-(void)doLogIn
{
    userID=0;
    if (usernameTextField.text.length ==0 ||passwordTextField.text.length ==0){
        [Fitness4MeUtils showAlert:NSLocalizedString(@"UsernameNull", nil)];
        [signUpView removeFromSuperview];
    }
    else
    {
        FitnessServerCommunication *fitness= [FitnessServerCommunication sharedState];
        [fitness login:usernameTextField.text password:passwordTextField.text activityIndicator:activityIndicator progressView:signUpView onCompletion:^(NSString *response) {
            NSMutableArray *object = [response JSONValue];
            NSMutableArray *itemsarray =[object valueForKey:@"items"];
            [self parseUserDetails:itemsarray];
            
        }
               onError:^(NSError *error) {
                   
               }];
    }
}

- (void)parseUserDetails:(NSMutableArray *)itemsarray
{
    
    [itemsarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* item = obj;
        userID=[[item objectForKey:@"id"]intValue];
        if (userID>0) {
            [self saveUser:[item objectForKey:@"username"]
             nameOfTheUser:[item objectForKey:@"fname"]
          levelofExpertise: [item objectForKey:@"level"]
           mailIdOfTheUser:[item objectForKey:@"email"]
       hasDoneFullPruchase:[item objectForKey:@"fullpurchase"]];
            
            FitnessServerCommunication *fitness= [FitnessServerCommunication sharedState];
            [fitness registerDeviceWithUserID:userID andSignUpView:signUpView onCompletion:^{
                
            } onError:^(NSError *error) {
                
            }];
            [self termainateActivityIndicator];
            [self updateData];
            [Fitness4MeUtils navigateToHomeView:self];
        }else {
            NSString *message;
            message=[item objectForKey:@"message"];
            if([message length]==0){
                message=NSLocalizedString(@"NoInternetMessage", nil);
            }[self termainateActivityIndicator];
            [Fitness4MeUtils showAlert:message];
        }
    }];
}


-(void)updateData
{
    if (userID>0){
        FitnessServerCommunication *fitnessserverCommunication =[[FitnessServerCommunication alloc]init];
        [fitnessserverCommunication parseFitnessDetails:userID];
        [fitnessserverCommunication getFreePurchaseCount:userID];
        [fitnessserverCommunication parseCustomFitnessDetails:userID onCompletion:^(NSString *responseString){
            
        } onError:^(NSError *error) {
            // [self getExcersices];
        }];
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
    
    User *usershared =[User sharedState];
    [usershared setName:name];
    
    NSUserDefaults *userInfo =[NSUserDefaults standardUserDefaults];
    [userInfo setObject:userlevel  forKey:@"Userlevel"];
    [userInfo setObject:name forKey:@"Name"];
    [userInfo setObject:username forKey:@"Username"];
    [userInfo setObject:passwordTextField.text forKey:@"password"];
    [userInfo setInteger:userID  forKey:@"UserID"];
    [userInfo setObject:email  forKey:@"email"];
    [userInfo setObject:fullpurchase forKey:@"hasMadeFullPurchase"];
    
}

- (void)showScreenInaccessor
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        signUpView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        
    }
    else {
        signUpView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1004)];
    }
    [signUpView addSubview:activityIndicator];
    [signUpView setBackgroundColor:[UIColor blackColor]];
    [signUpView setAlpha :0.5];
    [activityIndicator setHidden:NO];
    [activityIndicator startAnimating];
    [self.view addSubview:signUpView];
}

#pragma mark -textfieldDelgates


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(usernameTextField ==textField){
        if (usernameTextField.text.length>0){
            [passwordTextField becomeFirstResponder];
        }else{
            [Fitness4MeUtils showAlert:NSLocalizedString(@"mandatory", nil)];
            [usernameTextField becomeFirstResponder];
        }
    }
    
    if(passwordTextField ==textField){
        
        if (passwordTextField.text.length>0){
            [textField resignFirstResponder];
        }else{
            [Fitness4MeUtils showAlert:NSLocalizedString(@"mandatory", nil)];
            [passwordTextField becomeFirstResponder];
        }
    }
    //[textField resignFirstResponder];
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onclickLogin:(id)sender
{
    [self dismissKeyboardAway];
    [self showScreenInaccessor];
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