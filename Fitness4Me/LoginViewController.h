//
//  LoginViewController.h
//  Fitness4Me
//
//  Created by Ciby K Jose on 01/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "SBJSON.h"
#import "SBJsonParser.h"
#import "ASIFormDataRequest.h"
#import "UserDB.h"
#import "User.h"
#import "Fitness4MeViewController.h"
#import "NSString+Config.h"


@interface LoginViewController : UIViewController<UIWebViewDelegate>
{
    
    NSString *UrlPath;
    NSString *RequestString;
    NSString *userlevel;
    
    UserDB *userDB;
    
    UIView *signUpView;
    
    int userID;
    
    BOOL *stayup;
    BOOL checkBoxSelected;
    BOOL isValid;
    BOOL isValidUserName;
    BOOL isValidPassword;
    
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *lastNameTextField;
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *usernameTextField;
    IBOutlet UITextField *passwordTextField;
    
    IBOutlet UILabel *nameValidator;
    IBOutlet UILabel *lastNameValidator;
    IBOutlet UILabel *emailValidator;
    IBOutlet UILabel *usernameValidator;
    IBOutlet UILabel *passwordValidator;
    IBOutlet UILabel *errorLabel;
    IBOutlet UILabel *pleaseWait;
    
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *begineerButton;
    IBOutlet UIButton *advancedButton;
    IBOutlet UIButton *experButton;
    IBOutlet UIButton *termsandConditionButton;
    IBOutlet  UIButton *checkbox ;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIActivityIndicatorView *emailactivityIndicator;
    IBOutlet UIActivityIndicatorView *signupIndicator;
    
    IBOutlet UIImageView *usernameValidImageView;
    IBOutlet UIImageView *emailImageView;
    IBOutlet  UIImageView *errorIndicator;

    IBOutlet UIView *acceptAgreementView;
    IBOutlet UIWebView *webView;
    
}


@property (nonatomic ,retain)  NSString *RequestString;


-(IBAction)DismissKeyboardAway;
-(IBAction)saveUser:(id)sender;
-(IBAction)onNavigateToHomeView:(id)sender;


-(IBAction)onClickLevel:(id)sender;


@end

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
