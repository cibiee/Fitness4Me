//
//  CustomWorkoutIntermediateViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 05/12/12.
//
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
#import "GADBannerView.h"

@interface CustomWorkoutIntermediateViewController : UIViewController<ASIHTTPRequestDelegate>
{
BOOL isConected;
int count;

   


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

IBOutlet UIActivityIndicatorView *activityIndicator;
IBOutlet UITextView *pleaseWait;
IBOutlet UIView *signUpView;
IBOutlet UIButton *letsgoButton;
IBOutlet UILabel *titleLabel;
    IBOutlet UIProgressView *fileDownloadProgressView;

    IBOutlet UILabel *lblCompleted;
//IBOutlet UIBarButtonItem *backButton ;
IBOutlet UITextView *propsLabel;
IBOutlet UILabel *propLabel;
IBOutlet UIView *slownetView;
IBOutlet UIButton *slownetButton;
    UIButton *backButton;

ASIHTTPRequest   *downloadrequest ;
ASINetworkQueue  *myQueue;
int finished;
int totalCount;
ExcersiceDB *excersiceDB;
WorkoutDB *workoutDB;
Workout * workout;
User *user;
}

@property(nonatomic)BOOL navigateBack;
@property (weak, nonatomic) IBOutlet UITextView *durationLabel;
@property (weak, nonatomic) IBOutlet UITextView *focusLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain,nonatomic)Workout *workout;
@property (retain,nonatomic)NSString *purchaseAll;
@property(retain,nonatomic)NSString *userlevel;
@property(retain,nonatomic)NSString *userID;
@property(retain,nonatomic)NSString *productIdentifier;
@property (nonatomic,retain) ASINetworkQueue *myQueue;
@property(strong,nonatomic)NSString *workoutType;
-(void)downloadVideos:(NSString *)url :(NSString*)name;
-(void)parseExcersiceDetails;
- (IBAction)onClickWorkouts:(id)sender;
-(void)startDownload;
-(void)getExcersices;
-(void)getUnlockedExcersices;

-(IBAction)onClickOK:(id)sender;
-(IBAction)NavigateToMoviePlayer:(id)sender;
-(IBAction)onClickBack:(id)sender;



@end
