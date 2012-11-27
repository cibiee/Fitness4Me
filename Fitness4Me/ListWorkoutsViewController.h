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

@interface ListWorkoutsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    int UserID;
    int count;
    
    NSString *dataPath;
    NSString *purchaseMode;
    
    NSMutableArray *workouts;
    NSMutableArray *searchArray;
    
    UIImageView *imageView;
    
    WorkoutDB *workoutDB;
    ASINetworkQueue  *myQueue;
    Workout *selectedWorkout;

   
    IBOutlet UIBarButtonItem *refreshButton ;
    IBOutlet UINavigationBar *navigationBars;
    IBOutlet UITextView *networkNotificationtextView;
    IBOutlet UIProgressView *fileDownloadProgressView;
    IBOutlet UIActivityIndicatorView *activityindicators;
    __unsafe_unretained  IBOutlet UIView *signUpView;
    __unsafe_unretained IBOutlet UITableView *tableview;
    __unsafe_unretained  IBOutlet UIActivityIndicatorView *activityIndicator;
    
    
    
    IBOutlet UISearchBar *searchBar;
    BOOL searching;
    BOOL letUserSelectRow;
    

}

@property (assign,nonatomic)int UserID;
@property (assign,nonatomic)UIView *signUpView;
@property (assign,nonatomic)UITableView *tableview;
@property (nonatomic,retain) ASINetworkQueue *myQueue;
@property (assign,nonatomic)UIActivityIndicatorView *activityIndicator;


-(void)ListExcersices;

-(IBAction)navigateToHome;

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
