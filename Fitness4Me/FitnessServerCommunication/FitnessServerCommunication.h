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

typedef void (^WMLoginResponseBlock)(NSString *responseString);
typedef void (^ResponseBlock)(NSString *isExist);
typedef void (^ResponseVoidBlock)(void );
typedef void (^errorBlock)(NSString *errorString);

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
    ASINetworkQueue  *imageQueue;
    UIProgressView *myProgressIndicator;

    NSURLConnection *connection;
    
   id<FitnessServerCommunicationDelegate> delegate;
   

}

@property (nonatomic,retain) id<FitnessServerCommunicationDelegate> delegate;
@property (nonatomic,retain) NSMutableArray *workouts;
@property (nonatomic,retain) ASINetworkQueue *myQueue;
@property (nonatomic,retain) ASINetworkQueue *imageQueue;




+ (FitnessServerCommunication *)sharedState;
-(void)parseWorkoutVideos;
-(void)parseFitnessDetails:(int)UserID ;


- (void)login:(NSString *)username password:(NSString *)password activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock ;

- (void)isValidEmail:(NSString *)email andActivityIndicator:(UIActivityIndicatorView*)activityIndicator onCompletion:(ResponseBlock)completionBlock onError:(NSError*)errorBlock;

- (void)isValidUsername:(NSString *)username andActivityIndicator:(UIActivityIndicatorView*)activityIndicator onCompletion:(ResponseBlock)completionBlock onError:(NSError*)errorBlock;

- (void)registerDeviceWithUserID:(int)userId andSignUpView:(UIView*)signUpView onCompletion:(ResponseVoidBlock)completionBlock onError:(NSError*)errorBlock;

- (void)sendFeedback:(NSString *)feedback byUser:(NSString*)username email:(NSString*)email  onCompletion:(ResponseBlock)completionBlock onError:(NSError*)errorBlock;

- (void)updateUserWithName:(NSString *)name surname:(NSString*)surname email:(NSString*)email userLevel:(NSString*)userLevel userID:(NSString*)userID activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView  onCompletion:(ResponseBlock)completionBlock onError:(NSError*)errorBlock;

- (void)UpdateServerWithPurchaseStatus:(NSString *)purchaseStatus hasMadefullpurchase:(NSString*)purchaseAll workoutID:(NSString*)workoutID  userID:(NSString*)userID  activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(ResponseBlock)completionBlock onError:(NSError*)errorBlock;

-(void)parserExcersiceDetailsForWorkoutID:(NSString *)workoutID userLevel:(NSString *)userLevel  language:(int )selectedlanguage activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock ;





-(void)getFreePurchaseCount:(int)UserID ;
-(void)getAllvideos;
-(void)cancelDownload;
-(void)getFreevideos;
-(int)saveUserWithRequestString:(NSString*)requestString activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView;

@end
@protocol FitnessServerCommunicationDelegate <NSObject>


@optional
- (void)didRecieveWorkoutList;
@optional

- (void)didfinishedWorkout:(int)countCompleted:(int)totalCount;
@optional
- (void)didfinishedDownloadImage;
@end