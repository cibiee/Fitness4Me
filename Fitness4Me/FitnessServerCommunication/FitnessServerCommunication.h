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
#import "ASINetworkQueue.h"
#import "Fitness4MeUtils.h"
#import "SBJson.h"
#import "SBJsonParser.h"
#import "Workout.h"
#import "WorkoutDB.h"
#import "ExcersiceDB.h"
#import "Excersice.h"
#import "EquipmentDB.h"
#import "Equipments.h"
#import "Focus.h"
#import "FocusDB.h"
#import "ExcersicePlay.h"



typedef void (^WMLoginResponseBlock)(NSString *responseString);
typedef void (^ResponseBlock)(NSString *isExist);
typedef void (^ResponseVoidBlock)(void );
typedef void (^errorBlock)(NSString *errorString);

@protocol FitnessServerCommunicationDelegate;

@interface FitnessServerCommunication : NSObject
{
    
    int stop;
    
    NSMutableArray *workouts;
      
    NSURLConnection *connection;
    
    WorkoutDB *workoutDB;
    ExcersiceDB *excersiceDB;
    EquipmentDB *equipmentDB;
    FocusDB *focusDB;
    
    ASIHTTPRequest   *downloadrequest ;
    ASINetworkQueue  *myQueue;
    ASINetworkQueue  *imageQueue;
    
    
    id<FitnessServerCommunicationDelegate> delegate;
    
    
}

@property (nonatomic,retain) id<FitnessServerCommunicationDelegate> delegate;
@property (nonatomic,retain) NSMutableArray *workouts;
@property (nonatomic,retain) ASINetworkQueue *myQueue;
@property (nonatomic,retain) ASINetworkQueue *imageQueue;

@property (nonatomic,retain) NSMutableArray *ExcersiceList;


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

- (void)listEquipments:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock;

- (void)listfocus:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock;

- (void)saveCustomWorkout:(Workout*)workout  userID:(NSString*)userID userLevel:(NSString *)userLevel language:(int )selectedlanguage  activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock;

- (void)deleteCustomWorkout:(NSString*)workoutID   userID:(int)userID   activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock;


-(void)parseCustomFitnessDetails:(int)userID onCompletion:(ResponseBlock)completionBlock onError:(NSError*)errorBlock ;


- (void)setWorkoutfavourite:(NSString*)workoutID UserID:(int)userID Status:(NSString*)status  activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock;


-(int)saveUserWithRequestString:(NSString*)requestString activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView;



#pragma mark SELF MADE WORKOUT LIST SERVICES


/*-------------------------SELF MADE WORKOUT LIST SERVICES---------------------------------------------------*/

-(void)parseSelfMadeFitnessDetails:(int)userID  trail:(NSString*)trail onCompletion:(ResponseBlock)completionBlock onError:(NSError*)errorBlock;

- (void)listExcersiceWithequipments:(NSString*)equipments focus:(NSString*)focus  activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock;


- (void)saveSelfMadeWorkout:(NSString*)workoutName workoutCollection:(NSString*)workoutCollection workoutID:(NSString*)workoutID   userID:(NSString*)userID userLevel:(NSString *)userLevel language:(int )selectedlanguage focus:(NSString *)focus equipments:(NSString *)equipments activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock;

- (void)deleteSelfMadeWorkout:(NSString*)workoutID  userID:(int)userID   activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock;

- (void)setSelfMadeWorkoutfavourite:(NSString*)workoutID UserID:(int)userID Status:(NSString*)status  activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock;

- (void)listExcersiceFwithworkoutID:(NSString*)workoutIDs   activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock;

- (void)GetUserTypeWithactivityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock;


/*--------------------------SELF MADE WORKOUT LIST SERVICES---------------------------------------------------*/



#pragma mark-
-(void)downloadVideos:(NSString *)url:(NSString*)name;
-(void)getFreePurchaseCount:(int)UserID ;
-(void)getAllvideos;
-(void)cancelDownload;
-(void)getFreevideos;

@end
@protocol FitnessServerCommunicationDelegate <NSObject>


@optional
- (void)didRecieveWorkoutList;
@optional

- (void)didfinishedWorkout:(int)countCompleted:(int)totalCount;
@optional
- (void)didfinishedDownloadImage;
@end