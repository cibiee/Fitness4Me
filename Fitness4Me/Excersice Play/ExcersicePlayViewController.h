//
//  ExcersicePlayViewController.h
//  Fitness4Me
//
//  Created by Ciby K Jose on 06/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
#import "ExcersicePostPlayViewController.h"
#import "ASIFormDataRequest.h"
#import "Statistics.h"
#import "StatisticsDB.h"
#import "GADBannerView.h"

#define kOFFSET_FOR_KEYBOARD 80;


@interface ExcersicePlayViewController : UIViewController
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

-(void)initializPlayer;
-(void)getExcersices;
-(void)MakeArrayforViewing;

-(IBAction)onClickBack:(id)sender;

@end
