//
//  SettingsViewController.m
//  Fitness4Me
//
//  Created by Ciby on 04/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"


@interface SettingsViewController ()

@end

@implementation SettingsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - view overloaded Method

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    hasMadeFullPurchase= [userinfo valueForKey:@"hasMadeFullPurchase"];
    [hasMadeFullPurchase retain];
    NSString *showDownload= [userinfo valueForKey:@"showDownload"];
    
    userID=0;
    [fulldownloadButton removeFromSuperview];
    
    [self showHideDownloadButton:showDownload];
    
    //[self.view addSubview:loadView];
    [loadactivityIndicator startAnimating];
    
   [profileUpdatedView removeFromSuperview];
    profileUpdatedView.layer .cornerRadius =14;
    
    [self setInitials];
   
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self getUserDetails];
}


#pragma mark - Hidden Instance Method

- (void)showHideDownloadButton:(NSString *)showDownload
{
    if ([hasMadeFullPurchase isEqualToString:@"true"]) {
        if ([showDownload isEqualToString:@"true"]) {
            [self.view addSubview:fulldownloadButton];
        }
    }
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable) {
        [fulldownloadButton setHidden:NO];
    }else{
        [fulldownloadButton setHidden:YES];
    }
}

- (void)setInitials
{
    [downloadFullView removeFromSuperview];
    downloadFullView.layer .cornerRadius =14;
    downloadFullView.layer.borderWidth = 2;
    downloadFullView.layer.borderColor = [UIColor whiteColor].CGColor;
    //SyncView =nil;
    
    SyncView.layer.cornerRadius =14;
    SyncView.layer.borderWidth = 2;
    
    SyncView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [emailImageView setHidden:YES];
    [activityIndicator setHidesWhenStopped:YES];
    [emailactivityIndicator setHidesWhenStopped:YES];
}

-(void)startActivity{
    
    signUpView =[[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [signUpView addSubview:signupIndicator];
    [signUpView addSubview:pleaseWait];
    [signUpView setBackgroundColor:[UIColor blackColor]];
    [signUpView setAlpha:0.8];
    [signupIndicator setHidden:NO];
    [signupIndicator startAnimating];
    [self.view addSubview:signUpView];
    
}

-(void)terminateActivity:(NSString *)message
{
    [Fitness4MeUtils showAlert:message];
    [emailImageView setImage:[UIImage imageNamed:@"invalid.png"]];
    [emailValidator setBackgroundColor:[UIColor redColor]];
    [updateButton setEnabled:YES];
    [emailactivityIndicator setHidden:YES];
    [emailactivityIndicator stopAnimating];
    [emailImageView setHidden:NO];
}


-(void)isValidEmail
{
    
    if (emailTextField.text.length>0){
        isValid=  [Fitness4MeUtils validEmail:emailTextField.text];
        if (isValid==NO) {
            [self terminateActivity:NSLocalizedString(@"invalidaMail", nil)];
        }
        else {
            
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
}

-(void)navigateToExcersiceListView:(NSString *)requestString{
    
    [profileUpdatedView removeFromSuperview];
    NSString *userid =[NSString stringWithFormat:@"%i",userID];
    
    FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
    [fitness updateUserWithName:nameTextField.text surname:@"" email:emailTextField.text userLevel:userlevel userID:userid activityIndicator:signupIndicator progressView:signUpView  onCompletion:^(NSString *isExist) {
        if ([isExist isEqualToString:@"success"]){
            [self saveUserDetails:userlevel];
            
            if ([oldUserlevel isEqualToString:userlevel]){
                isLevelChanged =NO;
            }else{
                isLevelChanged =YES;
                oldUserlevel=userlevel;
            }
            
            
            NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
            if ([hasMadeFullPurchase isEqualToString:@"true"]) {
                if(isLevelChanged ==YES){
                    [self.view addSubview:profileUpdatedView];
                    [userinfo setObject:@"true" forKey:@"showDownload"];
                }
                freeVideo =@"false";
                [self.view addSubview:fulldownloadButton];
            }else{
                if(isLevelChanged ==YES){
                    freeVideo =@"true";
                    if ([userlevel isEqualToString:@"1"]) {
                        [lblFreedownloadmessageTextView setText:NSLocalizedString(@"beginnerLevelMessage", nil)];
                    }else  if ([userlevel isEqualToString:@"2"]){
                        [lblFreedownloadmessageTextView setText:NSLocalizedString(@"advancedLevelMessage", nil)];
                    }else{
                        [lblFreedownloadmessageTextView setText:NSLocalizedString(@"experLevelMessage", nil)];
                    }
                    [self freeVideoDownload];
                }
            }
            
            FitnessServerCommunication *fitnessserverCommunication =[[FitnessServerCommunication alloc]init];
            [fitnessserverCommunication parseFitnessDetails:userID];
            [fitnessserverCommunication parseWorkoutVideos];
            [self removeActivities];
        }
    } onError:^(NSError *error) {
        
    }];
    
}



- (void)parseUserDetails:(NSMutableArray *)object
{
    NSMutableArray *itemsarray =[object valueForKey:@"items"];
    for (int i=0; i<[itemsarray count]; i++) {
        userID=[[[itemsarray objectAtIndex:i] valueForKey:@"id"]intValue];
        if (userID>0) {
            NSString * name=[[itemsarray objectAtIndex:i] valueForKey:@"fname"];
            NSString * username =[[itemsarray objectAtIndex:i] valueForKey:@"username"];
            NSString * userlevels =[[itemsarray objectAtIndex:i] valueForKey:@"level"];
            NSString *email=[[itemsarray objectAtIndex:i]valueForKey:@"email"];
            NSString *fullPurchase=[[itemsarray objectAtIndex:i]valueForKey:@"fullpurchase"];
            [self saveUser:username :name:userlevels: email:fullPurchase];
        }
    }
}

-(void)doLogIn
{
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    NSString *usernameTextField= [userinfo valueForKey:@"Username"];
    NSString *passwordTextField= [userinfo valueForKey:@"password"];
    
    FitnessServerCommunication *fitness= [FitnessServerCommunication sharedState];
    [fitness login:usernameTextField password:passwordTextField activityIndicator:loadactivityIndicator progressView:loadView onCompletion:^(NSString *response) {
        NSMutableArray *object = [response JSONValue];
        [loadactivityIndicator stopAnimating];
        [loadView removeFromSuperview];
        [self parseUserDetails:object];
    }
           onError:^(NSError *error) {
               
           }];
}

-(void)saveUser:(NSString *)username:(NSString *) name :(NSString *)userlevels :
(NSString *)email :(NSString *)fullpurchase
{
    UserDB *userDB =[[UserDB alloc]init];
    [userDB setUpDatabase];
    [userDB createDatabase];
    User *user = [[User alloc]initWithUserID:userID UserName:username Name:name andLevel:userlevels];
    [userDB insertUser:user];
    
    
    NSUserDefaults *userInfo =[NSUserDefaults standardUserDefaults];
    [userInfo setObject:userlevels  forKey:@"Userlevel"];
    [userInfo setObject:name forKey:@"Name"];
    [userInfo setObject:username forKey:@"Username"];
    [userInfo setInteger:userID  forKey:@"UserID"];
    [userInfo setObject:email  forKey:@"email"];
    [userInfo setObject:fullpurchase forKey:@"hasMadeFullPurchase"];
    
}


-(void)getUserDetails
{
    
    [self doLogIn];
    
    NSUserDefaults *userInfo =[NSUserDefaults standardUserDefaults];
    usernameLabel.text =  [userInfo stringForKey:@"Username"];
    nameTextField.text =  [userInfo stringForKey:@"Name"];
    userID=  [userInfo integerForKey:@"UserID"];
    userlevel =[userInfo stringForKey:@"Userlevel"];
    oldUserlevel =[[NSString alloc]init];
    
    oldUserlevel =[userInfo stringForKey:@"Userlevel"];
    [oldUserlevel retain];
    
    if ([userlevel isEqualToString:@"1"]) {
        [begineerButton setImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
        [advancedButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [experButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else if ([userlevel isEqualToString:@"2"]) {
        [begineerButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [advancedButton setImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
        [experButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
    }else {
        [begineerButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [advancedButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [experButton setImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    }
    
    emailTextField.text =[userInfo stringForKey:@"email"];
    isValid=YES;
}


-(void)startDownload
{
    FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
    [fitness setDelegate:self];
    [fitness getAllvideos];
    fileDownloadProgressView.progress = ((float)0 / (float) 100);
}

-(void)navigateToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)freeVideoDownload{
    freeVideo =@"true";
    
    [self.view addSubview:SyncView];
    [SyncView setHidden:NO];
    [activityindicators startAnimating];
    [NSThread detachNewThreadSelector:@selector(startFreeDownload) toTarget:self withObject:nil];
}

-(void)startFreeDownload
{
    FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
    [fitness setDelegate:self];
    [fitness getFreevideos];
    fileDownloadProgressView.progress = ((float)0 / (float) 100);
}

-(void)saveUserDetails:(NSString*)userLevel
{
    NSUserDefaults *userInfo =[NSUserDefaults standardUserDefaults];
    [userInfo setObject:nameTextField.text forKey:@"Name"];
    [userInfo setObject:userLevel  forKey:@"Userlevel"];
    [userInfo setObject:emailTextField.text  forKey:@"email"];
}


-(void)removeActivities
{
    [UIView transitionWithView:downloadFullView duration:1
                       options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                           [signUpView setAlpha:0.0];
                           
                       }
                    completion:^(BOOL finished)
     {
         [signUpView setHidden:YES];
     }];
}

-(void)setvalidEmail
{
    isValid =YES;
    [updateButton setEnabled:YES];
    [emailValidator setBackgroundColor:[UIColor clearColor]];
    [emailactivityIndicator setHidden:YES];
    [emailactivityIndicator stopAnimating];
    [emailImageView setHidden:NO];
    emailImageView.image =[UIImage imageNamed:@"valid.png"];
}


#pragma mark -  Instance Method

-(IBAction)fullVideoDownload:(id)sender{
    
    [self.view addSubview:downloadFullView];
    freeVideo =@"false";
    [downloadFullViewIndicator startAnimating];
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setObject:@"true" forKey:@"fullVideoDownloadlater"];
    [NSThread detachNewThreadSelector:@selector(startDownload) toTarget:self withObject:nil];
    [Fitness4MeUtils showAlert:NSLocalizedString(@"fullDownloadMsg", nil)];
}



-(IBAction)cancelDownloas:(id)sender
{
    [downloadFullView removeFromSuperview];
    FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
    [fitness cancelDownload];
    [lblCompleted removeFromSuperview];
}


-(IBAction)saveUser:(id)sender
{
    [self  startActivity];
    if([nameTextField.text length] ==0 ||[emailTextField.text length]==0){
        [Fitness4MeUtils showAlert:NSLocalizedString(@"mandatory", Nil)];
        [signUpView removeFromSuperview];
        return;
    }
    if (isValid ==NO) {
        
        [Fitness4MeUtils showAlert:NSLocalizedString(@"validateemailUsername", Nil)];
        [errorLabel setText:NSLocalizedString(@"validateemailUsername", Nil)];
        [errorIndicator setHidden: NO];
        [signUpView removeFromSuperview];
        return;
    }
    [self performSelector:@selector(navigateToExcersiceListView:) withObject:nil afterDelay:0.5];
}



-(IBAction)onclickBeginerButton:(id)sender
{
    [begineerButton setImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    userlevel =@"1";
    [advancedButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [experButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
}

-(IBAction)onclickAdvancedButton:(id)sender
{
    [advancedButton setImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    userlevel =@"2";
    [begineerButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [experButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
}

-(IBAction)onclickExpertButton:(id)sender
{
    [experButton setImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    userlevel =@"3";
    [advancedButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [begineerButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
}


-(IBAction)onClickYes{
    
    [profileUpdatedView removeFromSuperview];
    [self.view addSubview:downloadFullView];
    [downloadFullViewIndicator startAnimating];
    [NSThread detachNewThreadSelector:@selector(startDownload) toTarget:self withObject:nil];
    [Fitness4MeUtils showAlert:NSLocalizedString(@"fullDownloadMsg", nil)];
}



-(IBAction)onClickNo{
    [profileUpdatedView removeFromSuperview];
    [Fitness4MeUtils showAlert:NSLocalizedString(@"workoutsthroughsettingsmsg", nil)];
}

-(IBAction)navigateToRating{
    RatingViewController *ratingViewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        ratingViewController = [[RatingViewController alloc]initWithNibName:@"RatingViewController" bundle:nil];
    }else {
        ratingViewController = [[RatingViewController alloc]initWithNibName:@"RatingViewControllerView_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:ratingViewController animated:YES];
}



#pragma mark -textField delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField ==nameTextField){
        if (nameTextField.text.length>0){
            [updateButton setEnabled:YES];
            [emailTextField becomeFirstResponder];
        }else{
            [Fitness4MeUtils showAlert:NSLocalizedString(@"mandatory", nil)];
            [updateButton setEnabled:NO];
            [nameTextField becomeFirstResponder];
        }
    }
    
    if (textField ==emailTextField){
        [emailImageView  setHidden:YES];
        if (emailTextField.text.length>0){
            [updateButton setEnabled:YES];
        }else{
            [Fitness4MeUtils showAlert:NSLocalizedString(@"mandatory", nil)];
            [updateButton setEnabled:NO];
            [emailTextField becomeFirstResponder];
        }
    }else{
        [textField resignFirstResponder];
    }
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if(textField ==emailTextField){
        if (emailTextField.text.length >0) {
            [updateButton setEnabled:NO];
            [emailactivityIndicator setHidden:NO];
            [emailactivityIndicator startAnimating];
            [emailImageView setHidden:YES];
            [NSThread detachNewThreadSelector:@selector(isValidEmail) toTarget:self withObject:nil];
        }
    }
}



#pragma mark - private Methods


-(IBAction)DismissKeyboardAway
{
    if ([nameTextField.text length]>0 && [emailTextField.text length]>0) {
        [updateButton setEnabled:YES];
    }
    [nameTextField resignFirstResponder] ;
    [emailTextField resignFirstResponder] ;
    
}



#pragma mark - fitness communication delegate Methods

- (void)didfinishedWorkout:(int)countCompleted:(int)totalCount
{

    if ([freeVideo isEqualToString:@"false"]) {
        [downloadFullView addSubview:lblCompleted];
        NSString *s= [NSString stringWithFormat:@"%i / %i",countCompleted,totalCount];
        lblCompleted.text =s;
        if (countCompleted ==totalCount) {
            

            [UIView transitionWithView:downloadFullView duration:1
                               options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                                   [downloadFullView setAlpha:0.0];
                                   
                               }
                            completion:^(BOOL finished)
             {
                  [downloadFullView removeFromSuperview];
                 NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
                 [userinfo setObject:@"false" forKey:@"showDownload"];
                 [fulldownloadButton removeFromSuperview];
                 
             }];
        }
        
        fileDownloadProgressView.progress = ((float)countCompleted / (float) totalCount);
    }else{
        
        [SyncView addSubview:lblCompleteCount];
        NSString *ss= [NSString stringWithFormat:@"%i / %i",countCompleted,totalCount];
        lblCompleteCount.text =ss;
        if (countCompleted ==totalCount) {
            [UIView transitionWithView:SyncView duration:3
                               options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                                   [SyncView removeFromSuperview];
                                   //[self.view addSubview:newView];
                               }
                            completion:NULL];
        }
        fileDownloadView.progress = ((float)countCompleted / (float) totalCount);
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate {
    return NO;
}

@end
