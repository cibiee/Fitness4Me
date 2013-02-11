//
//  UserLoginViewController.h
//  Fitness4Me
//
//  Created by Ciby on 01/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitnessServerCommunication.h"
#import "Fitness4MeUtils.h"
#import "User.h"
#import "UserDB.h"

@interface UserLoginViewController : UIViewController
{
    int userID;
    Boolean *stayup;
    NSString *urlPath;
    UIView *signUpView;
    
    IBOutlet UITextField *usernameTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UIActivityIndicatorView *activityIndicator;
}
@property (retain, nonatomic) IBOutlet UINavigationItem *navigationBar;
-(IBAction)onNavigateToHomeView:(id)sender;
-(IBAction)onclickLogin:(id)sender;
-(IBAction)dismissKeyboardAway;

@end
