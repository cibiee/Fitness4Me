//
//  CustomWorkoutsViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 28/11/12.
//
//

#import <UIKit/UIKit.h>
#import "CustomCellContentController.h"
#import "CustomWorkoutAddViewController.h"
#import "CustomWorkoutIntermediateViewController.h"
#import "CustomWorkoutEditViewController.h"
#import "WorkoutDB.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "SBJsonParser.h"
#import "Workout.h"
#import "Fitness4MeViewController.h"
#import "FitnessServerCommunication.h"
#import <QuartzCore/QuartzCore.h>

@interface CustomWorkoutsViewController : UIViewController
{
    int UserID;
    int count;
    
    NSString *dataPath;
    NSString *purchaseMode;
    NSUserDefaults *userinfo;
    NSMutableArray *searchArray;
    NSString *canCreate;
   
    FitnessServerCommunication *fitness;
    WorkoutDB *workoutDB;
    ASINetworkQueue  *myQueue;
    Workout *selectedWorkout;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
}
- (IBAction)onClickskipToPurchase:(id)sender;
- (IBAction)onClickOk:(id)sender;
- (IBAction)onClickClose:(id)sender;
-(IBAction)onClickEdit:(id)sender;
-(IBAction)onClickBack:(id)sender;
-(IBAction)onClickAdd:(id)sender;
-(IBAction)onClickContinueTrial:(id)sender;
@property (strong, nonatomic) NSString *canCreatetrial;
@property (weak, nonatomic) IBOutlet UITextView *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *memberView;
@property(strong,nonatomic)NSString *workoutType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (nonatomic,retain) ASINetworkQueue *myQueue;

@end
