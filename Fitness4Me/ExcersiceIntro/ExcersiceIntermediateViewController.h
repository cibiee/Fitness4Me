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
#import "FitnessServerCommunication.h"
#import "GADBannerView.h"

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"
#define kInAppPurchaseProUpgradeProductId @"com.fitness4me.Fitness4Me"

@interface ExcersiceIntermediateViewController : UIViewController<ASIHTTPRequestDelegate,FitnessServerCommunicationDelegate>
{
    BOOL isConected;
    int count;
    int stop;
    NSString  *storeURL;
    NSString *purchaseAll;
    NSString *dataPath;
    NSString *urlPath;
    NSString *userlevel;
    NSString *userID;

      
    NSMutableArray *excersices;
    NSMutableArray *arr;
    NSMutableArray *excersicesList;

    GADBannerView *bannerView_;
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
    IBOutlet UIProgressView *fileDownloadProgressView;
    IBOutlet UILabel *lblCompleted;

    ASIHTTPRequest   *downloadrequest ;
    ASINetworkQueue  *myQueue;
    int finished;
    int totalCount;
    ExcersiceDB *excersiceDB;  
    WorkoutDB *workoutDB;
    Workout * workout;
    User *user;
    int stopz;
}

@property (retain,nonatomic)Workout *workout;
@property (retain,nonatomic)NSString *purchaseAll;
@property(retain,nonatomic)NSString *userlevel;
@property(retain,nonatomic)NSString *userID;

@property (nonatomic,retain) ASINetworkQueue *myQueue;
@property (nonatomic,retain) ASINetworkQueue *imageQueue;

-(void)downloadVideos:(NSString *)url :(NSString*)name;
-(void)parseExcersiceDetails;
-(void)startDownload;
-(void)getExcersices;

-(IBAction)onClickOK:(id)sender;
-(IBAction)NavigateToMoviePlayer:(id)sender;
-(IBAction)onClickBack:(id)sender;



@end
