//
//  ExcersicePostPlayViewController.h
//  Fitness4Me
//
//  Created by Ciby K Jose on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Excersice.h"
#import "Workout.h"
#import "GADBannerView.h"
#import "WorkoutDB.h"

@interface ExcersicePostPlayViewController : UIViewController

{
    IBOutlet UIButton *listVideoButton;
    IBOutlet UIButton *closeUpgradeViewButton;
    IBOutlet UIButton *quitButton;
    IBOutlet UIView *upgradeView;
    
    IBOutlet UIView *signUpView;
    IBOutlet UIImageView *excersiceImageHolder;
    IBOutlet UITextView  *descriptiontextView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITextView *pleaseWait;
   
    NSString *urlPath;
    NSString *userID;

    NSString *dataPath;
    Excersice * Excersice;
    Workout * workout;
    GADBannerView *bannerView_;
    WorkoutDB *workoutDB;
   
    

}

@property(retain,nonatomic)NSString *userID;
@property (retain,nonatomic)Excersice *Excersice;
@property (retain,nonatomic)Workout *workout;

-(IBAction)startActivity;
-(IBAction)navigateToListView:(id)sender;
-(IBAction)navigateToShareAppView:(id)sender;
-(IBAction)removeUpgardeView:(id)sender;

@end
