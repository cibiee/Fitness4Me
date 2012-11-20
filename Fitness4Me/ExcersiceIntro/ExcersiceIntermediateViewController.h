//
//  ExcersiceIntermediateViewController.h
//  Fitness4Me
//
//  Created by Ciby K Jose on 06/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"
#import "ExcersiceDB.h"
#import "WorkoutDB.h"
#import "ListWorkoutsViewController.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "SBJSON.h"
#import "SBJsonParser.h"
#import "User.h"
#import "UserDB.h"




@interface ExcersiceIntermediateViewController : UIViewController<ASIHTTPRequestDelegate>
{
    BOOL isConected;
    int count;
    int stop;
    
    NSString *purchaseAll;
    NSString *dataPath;
    NSString *urlPath;
    NSString *userlevel;
    NSString *userID;

       
    NSMutableArray *excersices;
    NSMutableArray *arr;
    NSMutableArray *excersicesList;

    
    IBOutlet UIImageView *excersiceImageHolder;
    IBOutlet UITextView  *descriptionTextview;
    IBOutlet  UINavigationBar *navigationBars;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITextView *pleaseWait;
    IBOutlet UIView *signUpView;
    IBOutlet UIButton *letsgoButton;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIBarButtonItem *backButton ;
    IBOutlet UITextView *propsLabel;
    IBOutlet UILabel *propLabel;
    IBOutlet UIView *slownetView;
    IBOutlet UIButton *slownetButton;
    
    ASIHTTPRequest   *downloadrequest ;
    ASINetworkQueue  *myQueue;
    
    ExcersiceDB *excersiceDB;  
    WorkoutDB *workoutDB;
    Workout * workout;
    User *user;
}

@property (retain,nonatomic)Workout *workout;
@property (retain,nonatomic)NSString *purchaseAll;
@property(retain,nonatomic)NSString *userlevel;
@property(retain,nonatomic)NSString *userID;
@property(retain,nonatomic)NSString *productIdentifier;
@property (nonatomic,retain) ASINetworkQueue *myQueue;

-(void)downloadVideos:(NSString *)url:(NSString*)name;
-(void)parseExcersiceDetails;
-(void)startDownload;
-(void)getExcersices;
-(void)getUnlockedExcersices;

-(IBAction)onClickOK:(id)sender;
-(IBAction)NavigateToMoviePlayer:(id)sender;
-(IBAction)onClickBack:(id)sender;



@end
