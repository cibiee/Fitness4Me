//
//  LoginViewController.m
//  Fitness4Me
//
//  Created by Ciby K Jose on 01/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "InitialAppLaunchViewController.h"
#import "Reachability.h"
#import "FitnessServerCommunication.h"
#import "Fitness4MeUtils.h"

#define kOFFSET_FOR_KEYBOARD 80;

#define noNetworkMessage @"Internet is not available - please try later.";

@implementation LoginViewController

@synthesize RequestString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View overloaded Methods



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [acceptAgreementView removeFromSuperview];
    [[UIApplication sharedApplication]  registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert)];
    [super viewDidLoad];
    [self setInitials];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - Instance Methods


-(IBAction)onClickLevel:(id)sender
{
    
    NSString *restorationId = [sender  restorationIdentifier];
    
    if ([restorationId isEqualToString:@"Begineer"]) {
        [begineerButton setImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
        userlevel =@"1";
        [advancedButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [experButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        
    }
    else if ([restorationId isEqualToString:@"Advanced"]) {
        [advancedButton setImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
        userlevel =@"2";
        [begineerButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [experButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        
    }
    else if ([restorationId isEqualToString:@"Expert"]) {
        [experButton setImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
        userlevel =@"3";
        [advancedButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [begineerButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
    }
    
}




-(IBAction)DismissKeyboardAway
{
    [nameTextField resignFirstResponder] ;
    [emailTextField resignFirstResponder] ;
    [usernameTextField resignFirstResponder ];
    [passwordTextField resignFirstResponder] ;
}



-(void)showErrorWithMessage:(NSString*)message
{
    [errorLabel setText:message];
    [errorIndicator setHidden: NO];
    [signUpView removeFromSuperview];
}


-(IBAction)saveUser:(id)sender
{
    
    if([nameTextField.text length] ==0 ||[emailTextField.text length]==0 ||[usernameTextField.text length]==0 ||[passwordTextField.text length]==0){
        [self showErrorWithMessage:NSLocalizedString(@"mandatory", nil)];
    
        return;
    }
    if (isValid ==NO||isValidUserName==NO  ) {
        [self showErrorWithMessage:NSLocalizedString(@"validateemailUsername", nil)];
        return;
    }
    
    [self  startActivity];
    
    UrlPath =[NSString GetURlPath];
    int selectedlang =[Fitness4MeUtils getApplicationLanguage];
    
    RequestString =[NSString stringWithFormat:@"%@register=yes&fname=%@&sname=%@&email=%@&username=%@&password=%@&level=%@&device=1&lang=%i",UrlPath,nameTextField.text,lastNameTextField.text,emailTextField.text,usernameTextField.text,passwordTextField.text,userlevel,selectedlang];
    
    [self performSelector:@selector(navigateToExcersiceListView:) withObject:RequestString afterDelay:0.5];
    
}



-(IBAction)onNavigateToHomeView:(id)sender
{
    InitialAppLaunchViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        viewController =[[InitialAppLaunchViewController alloc]initWithNibName:@"InitialAppLaunchViewController" bundle:nil];
    }
    else {
        viewController =[[InitialAppLaunchViewController alloc]initWithNibName:@"InitialAppLaunchViewController_iPad" bundle:nil];    }
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}


#pragma mark -textfield delegate methods

//////
///Description:Hide The keyboard on enter button
// Created 1-Mar-2012
// Created by: Ciby K Jose
// Function Name:textFieldShouldReturn
//////

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField ==nameTextField){
        if (nameTextField.text.length>0){
            [nameValidator setBackgroundColor:[UIColor clearColor]];
            [lastNameTextField becomeFirstResponder];
        }else{
            [Fitness4MeUtils showAlert:NSLocalizedString(@"mandatory", nil)];
            [nameValidator setBackgroundColor:[UIColor redColor]];
            [nameTextField becomeFirstResponder];
        }
    }if (textField ==lastNameTextField){
        if (lastNameTextField.text.length>0){
            [lastNameValidator setBackgroundColor:[UIColor clearColor]];
            [ emailTextField becomeFirstResponder];
        }else{
            [Fitness4MeUtils showAlert:NSLocalizedString(@"mandatory", nil)];
            [lastNameValidator setBackgroundColor:[UIColor redColor]];
            [lastNameTextField becomeFirstResponder];
        }
    }else if (textField ==emailTextField) {
        [emailImageView setHidden:YES];
        if (emailTextField.text.length>0){
            [ usernameTextField becomeFirstResponder];
            [emailValidator setBackgroundColor:[UIColor clearColor]];
        }else{
            [Fitness4MeUtils showAlert:NSLocalizedString(@"mandatory", nil)];
            [emailValidator setBackgroundColor:[UIColor redColor]];
            [emailTextField becomeFirstResponder];
        }
    }else if (usernameTextField ==textField) {
        if (usernameTextField.text.length>0){
            [passwordTextField becomeFirstResponder];
            [usernameValidator setBackgroundColor:[UIColor clearColor]];
            [usernameValidImageView setHidden:YES];
        }else{
            [Fitness4MeUtils showAlert:NSLocalizedString(@"mandatory", nil)];
            [usernameValidator setBackgroundColor:[UIColor redColor]];
            [usernameValidImageView setHidden:YES];
            [usernameTextField becomeFirstResponder];
        }
    }else if (passwordTextField ==textField) {
        if (passwordTextField.text.length>0){
            [textField resignFirstResponder];
            [passwordValidator setBackgroundColor:[UIColor clearColor]];
        }else{
            [Fitness4MeUtils showAlert:NSLocalizedString(@"mandatory", nil)];
            [passwordValidator setBackgroundColor:[UIColor redColor]];
            [passwordTextField becomeFirstResponder];
        }
    }
    return NO;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField ==passwordTextField) {
        [Fitness4MeUtils setViewMovedUp:YES :self.view :YES:80];
    }
    else if  (textField ==usernameTextField){
        [Fitness4MeUtils setViewMovedUp:YES :self.view :YES:80];
    }
    else {
        [Fitness4MeUtils setViewMovedUp:NO :self.view :YES:80];
        
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField ==usernameTextField){
        [Fitness4MeUtils setViewMovedUp:NO :self.view :NO:80];
    }
    if (textField ==passwordTextField){
        [Fitness4MeUtils setViewMovedUp:NO :self.view :NO:80];
    }
    
    // UIAlertView *alertview;;
    [usernameTextField resignFirstResponder ];
    
    if(textField ==usernameTextField){
        if (usernameTextField.text.length>0){
            [loginButton setEnabled:NO];
            [activityIndicator setHidden:NO];
            [activityIndicator startAnimating];
            [usernameValidImageView setHidden:YES];
            [NSThread detachNewThreadSelector:@selector(isValidUserName) toTarget:self withObject:nil];
        }
        
    }
    if(textField ==emailTextField){
        if (emailTextField.text.length >0){
            [loginButton setEnabled:NO];
            [emailactivityIndicator setHidden:NO];
            [emailactivityIndicator startAnimating];
            [emailImageView setHidden:YES];
            [NSThread detachNewThreadSelector:@selector(isValidEmail) toTarget:self withObject:nil];
        }
    }
    
    if(textField ==passwordTextField){
        if (passwordTextField.text.length >0) {
            [loginButton setEnabled:NO];
            [NSThread detachNewThreadSelector:@selector(isValidpassword) toTarget:self withObject:nil];
        }
    }
}


#pragma mark - Hidden Instance Method
-(void)startActivity{
    
    signUpView =[[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [signUpView addSubview:signupIndicator];
    [signUpView addSubview:pleaseWait];
    signUpView.backgroundColor=[UIColor blackColor];
    signUpView.alpha=0.8;
    [signupIndicator setHidden:NO];
    [signupIndicator startAnimating];
    [self.view addSubview:signUpView];
}



-(void)setInitials{
    
    [pleaseWait removeFromSuperview];
    [usernameValidImageView setHidden:YES];
    [emailImageView setHidden:YES];
    [activityIndicator setHidesWhenStopped:YES];
    [emailactivityIndicator setHidesWhenStopped:YES];
    errorIndicator. hidden=YES;
    [signupIndicator setHidden:YES];
    [begineerButton setImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    userlevel =@"1";
    UrlPath =[NSString GetURlPath];
}



-(void)navigateToExcersiceListView:(NSString *)requestString{
    
    FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
    userID =[fitness saveUserWithRequestString:requestString activityIndicator:activityIndicator progressView:signUpView];
    NSString *userLevel =userlevel;
    if (userID>0){
        [fitness registerDeviceWithUserID:userID andSignUpView:signUpView onCompletion:^{
            
        } onError:^(NSError *error) {
            
        }];
        [self removeActivities];
        [self saveUserToDatabase:userLevel];
        [self saveUserDetails:userLevel];
        [self updateData];
        [self navigateToWorkoutList];
    }
    
}



-(void)saveUserToDatabase:(NSString*)userLevel
{
    userDB =[[UserDB alloc]init];
    [userDB setUpDatabase];
    [userDB createDatabase];
     User *user = [[User alloc]initWithUserID:userID UserName:usernameTextField.text Name:nameTextField.text andLevel:userLevel];
    [userDB insertUser:user];
    [userDB release];
}

-(void)updateData
{
    if (userID>0){
        FitnessServerCommunication *fitnessserverCommunication =[[FitnessServerCommunication alloc]init];
        [fitnessserverCommunication parseFitnessDetails:userID];
        [fitnessserverCommunication parseCustomFitnessDetails:userID onCompletion:^(NSString *responseString){
          
      } onError:^(NSError *error) {
          // [self getExcersices];
      }];
        
    }
}


-(void)saveUserDetails:(NSString*)userLevel
{
    NSUserDefaults *userInfo =[NSUserDefaults standardUserDefaults];
    [userInfo setObject:nameTextField.text forKey:@"Name"];
    [userInfo setObject:usernameTextField.text forKey:@"Username"];
    [userInfo setObject:usernameTextField.text forKey:@"password"];
    [userInfo setInteger:userID  forKey:@"UserID"];
    [userInfo setObject:userLevel  forKey:@"Userlevel"];
    [userInfo setObject:emailTextField.text  forKey:@"email"];
}

-(void)removeActivities{
    
    [signUpView removeFromSuperview];
    [signupIndicator setHidden:YES];
    [signupIndicator stopAnimating];
}



-(void)navigateToWorkoutList
{
    Fitness4MeViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        viewController =[[Fitness4MeViewController alloc]initWithNibName:@"Fitness4MeViewController" bundle:nil];
    }
    else {
        viewController =[[Fitness4MeViewController alloc]initWithNibName:@"Fitness4MeViewController_iPad" bundle:nil];    }
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}


-(void)terminateActivities:(NSString*)message{
    
    [Fitness4MeUtils showAlert:message];
    [self removeActivity];
    [self  removeSignupView];
}


-(void)removeActivity
{
    [activityIndicator setHidden:YES];
    [activityIndicator stopAnimating];
}



-(void)removeSignupView{
    [signUpView removeFromSuperview];
}

-(void)terminateActivity:(NSString *)message
{
    
    [Fitness4MeUtils showAlert:message];
    emailImageView.image =[UIImage imageNamed:@"invalid.png"];
    [emailValidator setBackgroundColor:[UIColor redColor]];
    [loginButton setEnabled:YES];
    [emailactivityIndicator setHidden:YES];
    [emailactivityIndicator stopAnimating];
    [emailImageView setHidden:NO];
}


-(void)isValidUserName
{
    
    [errorIndicator setHidden: YES];
    [errorLabel setHidden: YES];
    isValidUserName=  [Fitness4MeUtils validUsername:usernameTextField.text];
    
    if (isValidUserName==NO){
        [Fitness4MeUtils showAlert:NSLocalizedString(@"usernameAlphanumeric", nil)];
        [usernameValidator setBackgroundColor:[UIColor redColor]];
        [activityIndicator  stopAnimating];
        
    }else {
        
        [usernameValidator setBackgroundColor:[UIColor clearColor]];
        FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
        [fitness isValidUsername:usernameTextField.text  andActivityIndicator:activityIndicator onCompletion:^(NSString *IsExist) {
            if ([IsExist isEqualToString:@"true"]){
                [self setInValidstate];
            }else{
                [self setValiidstate];
            }
            
        } onError:^(NSError *error) {
            
        }];
    }
}


-(void)isValidpassword
{
    
    [errorIndicator setHidden: YES];
    [errorIndicator setHidden: YES];
    isValidPassword=  [Fitness4MeUtils validUsername:passwordTextField.text];
    
    if (isValidPassword==NO) {
        
        [Fitness4MeUtils showAlert:NSLocalizedString(@"PasswordAlphanumeric", nil)];
        [passwordValidator setBackgroundColor:[UIColor redColor]];
    }
    else
    {
        [passwordValidator setBackgroundColor:[UIColor clearColor]];
        [loginButton setEnabled:YES];
    }
}

-(void)isValidEmail
{
    
    [errorIndicator setHidden: YES];
    [errorIndicator setHidden: YES];
    isValid=  [Fitness4MeUtils validEmail:emailTextField.text];
    
    if (isValid==NO) {
        
        [self terminateActivity:NSLocalizedString(@"invalidaMail", nil)];
    }else {
        
        [emailValidator setBackgroundColor:[UIColor clearColor]];
        FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
        [fitness isValidEmail:emailTextField.text andActivityIndicator:emailactivityIndicator onCompletion:^(NSString *IsExist) {
            if ([IsExist isEqualToString:@"true"]) {
                isValid =NO;
                [self terminateActivity:NSLocalizedString(@"emailExists", nil)];
                [emailactivityIndicator stopAnimating];
            }
            else {
                [self setvalidEmail];
            }

        } onError:^(NSError *error) {
            
        }];
    }
    
    
}


-(void)setInValidstate
{
    isValidUserName =NO;
    usernameValidImageView.image =[UIImage imageNamed:@"invalid.png"];
    [usernameValidator setBackgroundColor:[UIColor redColor]];
    [loginButton setEnabled:YES];
    [usernameValidImageView setHidden:NO];
    [self removeActivity];
    
    [Fitness4MeUtils showAlert:NSLocalizedString(@"UsernameExits", nil)];}


-(void)setValiidstate
{
    isValidUserName =YES;
    [loginButton setEnabled:YES];
    [usernameValidator setBackgroundColor:[UIColor clearColor]];
    [self removeActivity];
    [usernameValidImageView setHidden:NO];
    usernameValidImageView.image =[UIImage imageNamed:@"valid.png"];
}



-(void)setvalidEmail
{
    isValid =YES;
    [loginButton setEnabled:YES];
    [emailValidator setBackgroundColor:[UIColor clearColor]];
    [emailactivityIndicator setHidden:YES];
    [emailactivityIndicator stopAnimating];
    [emailImageView setHidden:NO];
    emailImageView.image =[UIImage imageNamed:@"valid.png"];
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
#if !TARGET_IPHONE_SIMULATOR
#endif
    NSString *devToken = [NSString stringWithFormat:@"%@" ,deviceToken];
    NSString *token= [[[devToken stringByReplacingOccurrencesOfString:@"<"withString:@""]
                       stringByReplacingOccurrencesOfString:@">" withString:@""]
                      stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setObject:token forKey:@"deviceToken"];
}



#pragma mark - view orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate {
    return YES;
}


@end
