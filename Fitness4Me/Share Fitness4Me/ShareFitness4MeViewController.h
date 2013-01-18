//
//  ShareFitness4MeViewController.h
//  Fitness4Me
//
//  Created by Ciby K Jose on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import <Twitter/TWRequest.h>
#import <Accounts/Accounts.h>
#import <Twitter/TWTweetComposeViewController.h>
#import "Fitness4MeViewController.h"
#import "Fitness4MeUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "FitnessServerCommunication.h"


@interface ShareFitness4MeViewController : UIViewController <FBSessionDelegate,FBRequestDelegate,FBDialogDelegate> 

{

    NSString *ExcersiceTitle;
    NSString * imageUrl;
    NSString * imageName;
    NSString *_facebookName;
    NSArray *permissions;
    NSString *dataPath;
    NSString  *storeURL;
    NSString  *name;

    BOOL _posting;
    
    IBOutlet UIView *slownetView;
    IBOutlet UIImageView *logoImageHolder;
    IBOutlet UIImageView *excersiceImageHolder;
    IBOutlet UITextView  *shareAppMessageTextView;
    
    Facebook *facebook;
       
}


@property (retain,nonatomic) NSString *imageName;
@property (nonatomic, copy) NSString *facebookName;
@property(retain,nonatomic)NSString *imageUrl;
@property(strong,nonatomic)NSString *workoutType;

-(IBAction)shareAppOnTwitter :(id)sender;
-(IBAction)shareAppOnFacebook :(id)sender;
-(IBAction)navigateToHome;
-(IBAction)navigateBackHome;


@end
