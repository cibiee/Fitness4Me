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
    
    NSString *userlevel;
    NSString *UrlPath;
    NSString *RequestString;
    NSString *oldUserlevel;
    NSString *urlPath;
    
    NSString *freeVideo;

    IBOutlet UILabel *lblCompleted;
    IBOutlet UIProgressView *fileDownloadProgressView;
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *emailTextField;
    IBOutlet UIButton *updateButton;
    IBOutlet UIButton *begineerButton;
    IBOutlet UIButton *advancedButton;
    IBOutlet UIButton *experButton;
    IBOutlet UIButton *fulldownloadButton;
    IBOutlet UILabel *errorLabel;
    IBOutlet  UIImageView *errorIndicator;
    IBOutlet UILabel *pleaseWait;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIActivityIndicatorView *emailactivityIndicator;
    IBOutlet UIActivityIndicatorView *signupIndicator;
    IBOutlet UIImageView *emailImageView;
    IBOutlet UILabel *emailValidator;
    IBOutlet  UILabel *usernameLabel;
    IBOutlet  UILabel *passwordLabel;
    IBOutlet UIView *downloadFullView;
    IBOutlet UIView *loadView;
    IBOutlet UIActivityIndicatorView *loadactivityIndicator;
    IBOutlet UIActivityIndicatorView *downloadFullViewIndicator;
    IBOutlet  UIView *profileUpdatedView;
    IBOutlet UIView *SyncView;
    IBOutlet UIProgressView *fileDownloadView;
    IBOutlet UIActivityIndicatorView *activityindicators;
    IBOutlet UILabel *lblCompleteCount;
   
     IBOutlet UITextView *lblFreedownloadmessageTextView;
    
    BOOL isValid;
    
    UIView *signUpView;

    WorkoutDB *workoutDB;
    
    int userID;
    
    BOOL isLevelChanged;
    
   
}
-(IBAction)navigateToHome;
-(IBAction)navigateToRating;

-(IBAction)DismissKeyboardAway;
-(IBAction)cancelDownloas:(id)sender;

-(IBAction)onClickYes;
-(IBAction)onClickNo;


@property (nonatomic ,retain)  NSString *RequestString;

@end
