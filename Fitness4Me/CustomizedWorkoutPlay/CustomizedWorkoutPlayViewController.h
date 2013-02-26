//
//  CustomizedWorkoutPlayViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 06/12/12.
//
//

#import <UIKit/UIKit.h>
#import "Excersice.h"
#import "ASIHTTPRequest.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Excersice.h"
#import "ExcersiceDB.h"
#import "Workout.h"
#import "AVFoundation/AVFoundation.h"
#import "ListWorkoutsViewController.h"
#import "CustomWokoutPostplayViewController.h"
#import "ASIFormDataRequest.h"
#import "Statistics.h"
#import "StatisticsDB.h"
#import "GADBannerView.h"

@interface CustomizedWorkoutPlayViewController : UIViewController
{
    
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UIButton *quitbutton;
    IBOutlet UIImageView *bgImageview;
    IBOutlet UIView *subview;
    IBOutlet UIView *subview5;
    
    GADBannerView *bannerView_;
    CGRect screenBounds;
    NSString *storeURL;
    NSString *duration;
    MPMoviePlayerController __strong *moviePlayer;
    NSMutableArray *arr;
    NSMutableArray *aras;
    NSMutableArray * excersices;
    Excersice *fitness;
    Workout * workout;
    ExcersiceDB *excersiceDB;
    StatisticsDB *statisticsDB;
    int WorkoutID;
    NSString *userID;
    Boolean *stayup;
}


@property(retain, nonatomic)  NSMutableArray *excersices;
@property (assign,nonatomic)int WorkoutID;
@property (retain,nonatomic)Workout *workout;
@property(retain,nonatomic)NSString *userID;
@property(strong,nonatomic)NSString *workoutType;

-(void)initializPlayer;
-(void)getExcersices;
-(void)MakeArrayforViewing;
-(IBAction)onClickBack:(id)sender;


@end
