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
    
    FitnessServerCommunication *fitness;
    WorkoutDB *workoutDB;
    ASINetworkQueue  *myQueue;
    Workout *selectedWorkout;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
}
@property(strong,nonatomic)NSString *workoutType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (nonatomic,retain) ASINetworkQueue *myQueue;
-(IBAction)onClickEdit:(id)sender;
-(IBAction)onClickBack:(id)sender;
-(IBAction)onClickAdd:(id)sender;

@end
