//
//  ListWorkoutsViewController.h
//  Fitness4Me
//
//  Created by Ciby on 02/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutDB.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "SBJsonParser.h"
#import "Workout.h"
#import "CellContentController.h"
#import "ExcersiceIntermediateViewController.h"
#import "Fitness4MeViewController.h"
#import "FitnessServerCommunication.h"
#import <QuartzCore/QuartzCore.h>

@interface ListWorkoutsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,FitnessServerCommunicationDelegate>
{
    __unsafe_unretained IBOutlet UITableView *tableview;
    IBOutlet UINavigationBar *navigationBars;
    IBOutlet UIImageView *testImage;
    IBOutlet UIButton *unlockAllButton;
    IBOutlet UIButton *unlockOneButton;
    IBOutlet UIView *offerView;
  __unsafe_unretained  IBOutlet UIActivityIndicatorView *activityIndicator;
   __unsafe_unretained  IBOutlet UIView *signUpView;
    IBOutlet UIBarButtonItem *refreshButton ;
    
    
    IBOutlet UITextView *networkNotificationtextView;
    
    
    IBOutlet UIProgressView *fileDownloadProgressView;
    IBOutlet UIButton *fullvideobutton;
    IBOutlet UIView *fullvideoView;
    IBOutlet UIView *signupviews;
    
    
    
     IBOutlet UIActivityIndicatorView *activityindicators;
    IBOutlet UILabel *lblCompleted;
    Workout *selectedWorkout;
    WorkoutDB *workoutDB;
    
     ASINetworkQueue  *myQueue;
    
  
    NSMutableArray *workouts;
    
    NSString *dataPath;
    NSString *purchaseMode;
  
    UIImageView *imageView;
    
    int UserID;
    int count;
 
}

@property (assign,nonatomic)int UserID;
@property (assign,nonatomic)UIActivityIndicatorView *activityIndicator;
@property (assign,nonatomic)UIView *signUpView;
@property (assign,nonatomic)UITableView *tableview;
@property (nonatomic,retain) ASINetworkQueue *myQueue;

-(IBAction)navigateToHome;
-(IBAction)unlockOne;
-(IBAction)unlockAll;

-(void)ListExcersices;

-(IBAction)fullVideoDownload:(id)sender;

-(IBAction)later:(id)sender;

@end

@protocol ListWorkoutsDelegate <NSObject>
@required
- (void)reloadData;
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
