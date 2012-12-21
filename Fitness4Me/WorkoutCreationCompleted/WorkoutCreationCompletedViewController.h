//
//  WorkoutCreationCompletedViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 05/12/12.
//
//

#import <UIKit/UIKit.h>
#import "ExcersiceDB.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "SBJSON.h"
#import "SBJsonParser.h"
#import "FitnessServerCommunication.h"
#import "WorkoutDB.h"

@interface WorkoutCreationCompletedViewController : UIViewController
{
    
    
    
    Workout *workout;
    
    ASIHTTPRequest   *downloadrequest ;
    ASINetworkQueue  *myQueue;
    ExcersiceDB *excersiceDB;
   
    
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
    
    
       
        
    int stopz;

}


-(IBAction)onClickBack:(id)sender;
- (IBAction)onClickLetsGo:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *creationCompleteLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic)Workout *workout;
@property (strong, nonatomic)NSString *workoutName;
@property (strong, nonatomic)NSString *collectionString;
@property (strong, nonatomic)NSString *workoutID;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UIView *progressView;

@end
