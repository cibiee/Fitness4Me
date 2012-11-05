//
//  FitnessServerCommunication.h
//  Fitness4Me
//
//  Created by Ciby K Jose on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Config.h"
#import "Reachability.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "SBJsonParser.h"
#import "Workout.h"
#import "WorkoutDB.h"
#import "Fitness4MeUtils.h"
#import "ASINetworkQueue.h"
#import "ExcersiceDB.h"

@protocol FitnessServerCommunicationDelegate;

@interface FitnessServerCommunication : NSObject
{
     NSMutableArray *workouts;
     NSMutableArray *workoutVideoLists;
    
    
     WorkoutDB *workoutDB;
     ExcersiceDB *excersiceDB;
    
     int stop;
    
    ASIHTTPRequest   *downloadrequest ;
    ASINetworkQueue  *myQueue;
    
    UIProgressView *myProgressIndicator;

    NSURLConnection *connection;
    
   id<FitnessServerCommunicationDelegate> delegate;
   

}

@property (nonatomic,retain) id<FitnessServerCommunicationDelegate> delegate;
@property (nonatomic,retain) NSMutableArray *workouts;
@property (nonatomic,retain) ASINetworkQueue *myQueue;



+ (FitnessServerCommunication *)sharedState;

-(void)parseFitnessDetails:(int)UserID ;
-(void)parseWorkoutVideos;

-(void)getFreePurchaseCount:(int)UserID ;
-(void)getAllvideos;
-(void)cancelDownload;
-(void)getFreevideos;
-(int)saveUserWithRequestString:(NSString*)requestString activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView;
-(NSString*)isValidUserWitName:(NSString*)userName urlPath:(NSString*)urlPaths andActivityIndicator:(UIActivityIndicatorView*)activityIndicator;

//-(void)getAllImages;
@end
@protocol FitnessServerCommunicationDelegate <NSObject>


@optional
- (void)didRecieveWorkoutList;
- (void)didfinishedWorkout:(int)countCompleted:(int)totalCount;

@end