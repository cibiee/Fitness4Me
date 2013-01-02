//
//  CustomWorkoutEditViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 06/12/12.
//
//

#import <UIKit/UIKit.h>
#import "CustomCellContentController.h"

#import "CustomWorkoutAddViewController.h"
#import "CustomWorkoutIntermediateViewController.h"
#import "WorkoutDB.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "SBJsonParser.h"
#import "Workout.h"
#import "Fitness4MeViewController.h"
#import "FitnessServerCommunication.h"
#import <QuartzCore/QuartzCore.h>
@interface CustomWorkoutEditViewController : UIViewController
{
    int UserID;
    int count;
    
    NSString *dataPath;
    NSString *purchaseMode;
    
    
    NSMutableArray *searchArray;
    
    
     IBOutlet UIActivityIndicatorView *activityIndicator;
    WorkoutDB *workoutDB;
    ASINetworkQueue  *myQueue;
    Workout *selectedWorkout;
}
    @property(strong,nonatomic)NSString *workoutType;
    @property (weak, nonatomic) IBOutlet UITableView *tableView;
    @property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
    @property (nonatomic,retain) ASINetworkQueue *myQueue;
   
    -(IBAction)onClickBack:(id)sender;
-(IBAction)onClickdelete:(id)sender;
    


@end
