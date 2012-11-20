//
//  SettingsViewController.h
//  Fitness4Me
//
//  Created by Ciby on 04/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fitness4MeViewController.h"
#import "NSString+Config.h"
#import "WorkoutDB.h"
#import "RatingViewController.h"
#import "FitnessServerCommunication.h"
#import "Fitness4MeUtils.h"
#import <QuartzCore/QuartzCore.h>

@interface SettingsViewController : UIViewController<FitnessServerCommunicationDelegate>

{
    BOOL isValid;
    BOOL isLevelChanged;
    
    int userID;

    NSString *userlevel;
   
    NSString *oldUserlevel;
    
    
    WorkoutDB *workoutDB;
    
    UIView *signUpView;
    
    
    IBOutlet UIButton *updateButton;
    IBOutlet UIButton *begineerButton;
    IBOutlet UIButton *advancedButton;
    IBOutlet UIButton *experButton;
    IBOutlet UIButton *fulldownloadButton;
    
    IBOutlet  UIImageView *errorIndicator;
    IBOutlet UIImageView *emailImageView;
   
    IBOutlet UILabel *errorLabel;
    IBOutlet UILabel *pleaseWait;
    IBOutlet UILabel *emailValidator;
    IBOutlet UILabel *usernameLabel;
    IBOutlet UILabel *passwordLabel;
   
    IBOutlet UILabel *lblCompleted;

    
    IBOutlet UIView *downloadFullView;
    IBOutlet UIView *loadView;
    IBOutlet UIView *profileUpdatedView;
  
    
    IBOutlet UIProgressView *fileDownloadProgressView;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIActivityIndicatorView *emailactivityIndicator;
    IBOutlet UIActivityIndicatorView *signupIndicator;
    IBOutlet UIActivityIndicatorView *loadactivityIndicator;
    IBOutlet UIActivityIndicatorView *downloadFullViewIndicator;
    IBOutlet UIActivityIndicatorView *activityindicators;
    
       
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextView *lblFreedownloadmessageTextView;

   
}
-(IBAction)navigateToHome;
-(IBAction)navigateToRating;

-(IBAction)DismissKeyboardAway;
-(IBAction)cancelDownloas:(id)sender;

-(IBAction)onClickYes;
-(IBAction)onClickNo;




@end
