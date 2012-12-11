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

@interface CustomWorkoutIntermediateViewController : UIViewController
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

IBOutlet UIActivityIndicatorView *activityIndicator;
IBOutlet UITextView *pleaseWait;
IBOutlet UIView *signUpView;
IBOutlet UIButton *letsgoButton;
IBOutlet UILabel *titleLabel;
//IBOutlet UIBarButtonItem *backButton ;
IBOutlet UITextView *propsLabel;
IBOutlet UILabel *propLabel;
IBOutlet UIView *slownetView;
IBOutlet UIButton *slownetButton;
    UIButton *backButton;

ASIHTTPRequest   *downloadrequest ;
ASINetworkQueue  *myQueue;

ExcersiceDB *excersiceDB;
WorkoutDB *workoutDB;
Workout * workout;
User *user;
}
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

-(void)downloadVideos:(NSString *)url:(NSString*)name;
-(void)parseExcersiceDetails;
-(void)startDownload;
-(void)getExcersices;
-(void)getUnlockedExcersices;

-(IBAction)onClickOK:(id)sender;
-(IBAction)NavigateToMoviePlayer:(id)sender;
-(IBAction)onClickBack:(id)sender;



@end
