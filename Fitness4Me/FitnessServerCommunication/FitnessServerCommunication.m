//
//  FitnessServerCommunication.m
//  Fitness4Me
//
//  Created by Ciby K Jose on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FitnessServerCommunication.h"
#import "SBJson.h"
#import "SBJsonParser.h"
#import "ExcersicePlay.h"
#import "Excersice.h"


@interface FitnessServerCommunication ()
{
}

@end

@implementation FitnessServerCommunication

static FitnessServerCommunication *sharedState;
@synthesize delegate,workouts,myQueue;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        downloadrequest = [[ASIHTTPRequest alloc] initWithURL:Nil];
        myQueue =[[ASINetworkQueue alloc]init];
        
    }
    
    return self;
}


#pragma mark -
#pragma mark FitnessServerCommunication singleton method

+ (FitnessServerCommunication *)sharedState {
    
    @synchronized(self) {
        if (sharedState == nil)
            sharedState = [[self alloc] init];
        
    }
    return sharedState;
    
    
}

#pragma mark -
#pragma mark Instance method

-(void)parseFitnessDetails:(int)userID {
    
    
    NSString *urlPath= [NSString GetURlPath];
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        
        int  selectedLanguage=[Fitness4MeUtils getApplicationLanguage] ;
        
        NSString *requestString = [NSString stringWithFormat:@"%@listapps=yes&userid=%i&duration=10&lang=%i",urlPath, userID,selectedLanguage];
        
        NSURL *url =[NSURL URLWithString:requestString];
        
        ASIFormDataRequest   *request = [ASIFormDataRequest   requestWithURL:url];
        [request setTimeOutSeconds:10];
        [request setDelegate:self];
        [request startAsynchronous];
    }
}


-(void)parseWorkoutVideos{
    
    
    NSString *urlPath= [NSString GetURlPath];
    int  selectedLanguage=[Fitness4MeUtils getApplicationLanguage] ;
    int  userlevel=[Fitness4MeUtils getuserLevel] ;
    
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        
        NSString *requestString = [NSString stringWithFormat:@"%@allworkouts=yes&duration=10&user_level=%i&lang=%i",urlPath, userlevel,selectedLanguage];
        NSURL *url =[NSURL URLWithString:requestString];
        
        ASIFormDataRequest   *request = [ASIFormDataRequest   requestWithURL:url];
        [request setTimeOutSeconds:10];
        [request setDelegate:self];
        [request startAsynchronous];
    }
}


-(int)saveUserWithRequestString:(NSString*)requestString activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView
{
    NSString *userID=@"";
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
        
        //NSURL *url=[NSURL URLWithString:requestString];
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
        ASIFormDataRequest   *request = [ASIFormDataRequest   requestWithURL:url];
        [request startSynchronous];
        
        NSError *error = [request error];
        
        if (!error)
        {
            NSString *response = [request responseString];
            if ([response length]>0)
            {
                
                NSMutableArray *object = [response JSONValue];
                NSMutableArray *itemsarray =[object valueForKey:@"items"];
                for (int i=0; i<[itemsarray count]; i++)
                {
                    userID=[[itemsarray objectAtIndex:i] valueForKey:@"userid"];
                }
            }
            else
            {
                
                [self terminateActivities:NSLocalizedString(@"slowdata", nil):activityIndicator:signUpView];            }
        }
        else
        {
            [self terminateActivities:NSLocalizedString(@"requestError", nil):activityIndicator:signUpView];
        }
    }
    else
    {
        [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):activityIndicator:signUpView];
    }
    
    return [userID intValue];
}

-(void)terminateActivities:(NSString*)message:(UIActivityIndicatorView*)activityIndicator:(UIView*)signUpView{
    
    [Fitness4MeUtils showAlert:message];
    [self removeActivity:activityIndicator];
    [self  removeSignupView:signUpView];
}



-(void)removeActivity:(UIActivityIndicatorView*)activityIndicator;
{
    [activityIndicator setHidden:YES];
    [activityIndicator stopAnimating];
}



-(void)removeSignupView:(UIView*)signUpView{
    [signUpView removeFromSuperview];
}

-(NSString*)isValidUserWitName:(NSString*)userName urlPath:(NSString*)urlPaths andActivityIndicator:(UIActivityIndicatorView*)activityIndicator{

  BOOL isReachable =[Fitness4MeUtils isReachable];
    NSString *IsExist;

 if(isReachable){
    
    NSString *requestString =[NSString stringWithFormat: @"%@checkusername=yes&username=%@",urlPaths, userName];
    NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:
                                      NSUTF8StringEncoding]];
    
    ASIFormDataRequest   *request = [ASIFormDataRequest   requestWithURL:url];
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error){
        
        NSString *response = [request responseString];
        
        if ([response length]>0){
            
            NSMutableArray *object = [response JSONValue];
            NSMutableArray *itemsarray =[object valueForKey:@"items"];
                        for (int i=0; i<[itemsarray count]; i++){
                IsExist=[[itemsarray objectAtIndex:i] valueForKey:@"status"];
            }
        }
        else{
            [self terminateActivities:NSLocalizedString(@"slowdata", nil):nil:activityIndicator];
            
        }
    }
    else{
        [self terminateActivities:NSLocalizedString(@"requestError", nil):nil:activityIndicator];
    }
}
else {
    [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):nil:activityIndicator];
}

    return IsExist;
}


-(NSString*)isValidUserWitEmail:(NSString*)email urlPath:(NSString*)urlPaths andActivityIndicator:(UIActivityIndicatorView*)activityIndicator{
    
    NSString *IsExist;
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        
        
        NSString *requestString =[NSString stringWithFormat: @"%@checkemail=yes&email=%@", urlPaths,email];
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
        
        ASIFormDataRequest   *request = [ASIFormDataRequest   requestWithURL:url];
        [request startSynchronous];
        [request setTimeOutSeconds:10];
        NSError *error = [request error];
        if (!error)
        {
            
            NSString *response = [request responseString];
            if ([response length]>0) {
                
                NSMutableArray *object = [response JSONValue];
                NSMutableArray *itemsarray =[object valueForKey:@"items"];
                for (int i=0; i<[itemsarray count]; i++) {
                    IsExist=[[itemsarray objectAtIndex:i] valueForKey:@"status"];
                }
            }
            else{
                [self terminateActivities:NSLocalizedString(@"slowdata", nil):nil:activityIndicator];
            }
        }
        else{
            [self terminateActivities:NSLocalizedString(@"requestError", nil):nil:activityIndicator];
        }
    }
    else {
        [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):nil:activityIndicator];
    }
    
    return IsExist;
}




-(void)getFreePurchaseCount:(int)UserID {
    
    
    NSString *urlPath= [NSString GetURlPath];
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        UserID =[userinfo integerForKey:@"UserID"];
        
        NSString *requestString = [NSString stringWithFormat:@"%@freecount=yes&user_id=%i",urlPath, UserID];
        NSURL *url =[NSURL URLWithString:requestString];
        
        ASIFormDataRequest   *request = [ASIFormDataRequest   requestWithURL:url];
        [request setTimeOutSeconds:15];
        [request setDelegate:self];
        [request startAsynchronous];
    }
}



-(void)getAllvideos {
    
    
    NSString *UrlPath= [NSString GetURlPath];
    totalcount=0,excersiceIntroCount=0,excersiceMainCount=0,excersiceOtherCount=0,finished=0;
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        int  selectedLanguage=[Fitness4MeUtils getApplicationLanguage] ;
        int  userlevel=[Fitness4MeUtils getuserLevel] ;
        NSString *requestString = [NSString stringWithFormat:@"%@allvideos=yes&duration=10&user_level=%i&lang=%i",UrlPath, userlevel,selectedLanguage];
        NSURL *url =[NSURL URLWithString:requestString];
        
        ASIFormDataRequest   *request = [ASIFormDataRequest   requestWithURL:url];
        [request setTimeOutSeconds:15];
        [request setDelegate:self];
        [request startAsynchronous];
    }
}

-(void)getFreevideos {
    
    
    NSString *UrlPath= [NSString GetURlPath];
    totalcount=0,excersiceIntroCount=0,excersiceMainCount=0,excersiceOtherCount=0,finished=0;
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        int  selectedlang=[Fitness4MeUtils getApplicationLanguage] ;
        int  userlevel=[Fitness4MeUtils getuserLevel] ;
        
        
        NSString *requestString = [NSString stringWithFormat:@"%@freevideos=yes&duration=10&user_level=%i&lang=%i",UrlPath, userlevel,selectedlang];
        NSURL *url =[NSURL URLWithString:requestString];
        
        ASIFormDataRequest   *request = [ASIFormDataRequest   requestWithURL:url];
        [request setTimeOutSeconds:15];
        [request setDelegate:self];
        [request startAsynchronous];
    }
}





#pragma mark ASIHTTP delegate methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *keyValue;
    NSData *responseData = [request responseData];
    NSMutableDictionary *object = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    NSArray *keyArray =[object allKeys];
    if ([keyArray count]>0) {
        
        keyValue =[NSString stringWithFormat:@"%@",[keyArray objectAtIndex:0]];
    }
    
    if ([keyValue isEqualToString:@"items"]) {
        
        
        // Use when fetching text data
        NSString *responseString = [request responseString];
        if ([responseString length]>0) {
            [self parseWorkoutList:responseString];
        }
    }
    else if ([keyValue isEqualToString:@"freepurchase"]){
        
        NSArray *unlockWorkout =[object objectForKey:@"freepurchase"];
        int unlockcount=[[[unlockWorkout objectAtIndex:0]valueForKey:@"count"]intValue];
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        [userinfo setInteger:unlockcount forKey:@"freePurchaseCount"];
        
        
    }
    else if ([keyValue isEqualToString:@"video"]){
        NSString *responseString = [request responseString];
        [self parseVideoList:responseString];
    }
    
    
    else if ([keyValue isEqualToString:@"workoutvideos"]){
        NSString *responseString = [request responseString];
        [self parseWorkoutVideoList:responseString];
    }
    
    //    else if ([keyValue isEqualToString:@"images"]){
    //        NSString *responseString = [request responseString];
    //        [self parseImageList:responseString];
    //    }
}




- (void)requestFailed:(ASIHTTPRequest *)request
{
    //NSError *error = [request error];
    
}


#pragma mark Hidden Instance method

-(void)cancelDownload {
    
    
    for (ASIHTTPRequest *req in ASIHTTPRequest.sharedQueue.operations)
    {
        [req cancel];
        [req setDelegate:nil];
        [req clearDelegatesAndCancel];
    }
    [myQueue setDelegate:nil];
    [myQueue cancelAllOperations];
    
    totalcount=0;
    excersiceIntroCount=0;
    excersiceMainCount=0;
    excersiceOtherCount=0;
    finished=0;
    
}



-(void)insertExcersices
{
    workoutDB =[[WorkoutDB alloc]init];
    [workoutDB setUpDatabase];
    [workoutDB createDatabase];
    [workoutDB insertWorkouts:workouts];
}


//-(void)parseImageList:(NSString*)responseString
//{
//    NSMutableArray *object = [responseString JSONValue];
//    workouts = [[NSMutableArray alloc]init];
//    NSMutableArray *itemsarray =[object valueForKey:@"images"];
//
//    [itemsarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSDictionary* item = obj;
//        [self downloadImages:[item objectForKey:@"imageUrl"] :[item objectForKey:@"imageName"]];
//    }];
//
//}

-(void)parseWorkoutList:(NSString*)responseString
{
    NSMutableArray *object = [responseString JSONValue];
    workouts = [[NSMutableArray alloc]init];
    NSMutableArray *itemsarray =[object valueForKey:@"items"];
    
    [itemsarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* item = obj;
        [workouts addObject:[[Workout alloc]initWithData:[item objectForKey:@"id"]:[item objectForKey:@"name"]:[item objectForKey:@"rate"]:[item objectForKey:@"image_android"]:[item objectForKey:@"image_name"]:[item objectForKey :@"islocked"]:[item objectForKey:@"description"]:[item objectForKey:@"description_big"]:nil:[item objectForKey:@"description_big"]:[item objectForKey :@"image_thumb"]:[item objectForKey:@"props"]]];
    }];
    
    if ([workouts count]>0) {
        
        [self insertExcersices];
    }
    
    [self.delegate didRecieveWorkoutList];
    
    
}




int totalcount;
int excersiceIntroCount=0,excersiceMainCount=0,excersiceOtherCount=0;

-(void)parseVideoList:(NSString*)responseString
{
    NSDictionary *object = [responseString JSONValue];
    workouts = [[NSMutableArray alloc]init];
    NSMutableArray *itemsarray =[object objectForKey:@"video"];
    
    [itemsarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* item = obj;
        [workouts addObject:[[ExcersicePlay alloc]initWithData:[item objectForKey:@"intro"]:[item objectForKey:@"intro_name"]:[item objectForKey:@"main"]:[item objectForKey:@"main_name"]:[item objectForKey:@"main_other"]:[item objectForKey :@"main_other_name"]]];
    }];
    
    totalcount=0;
    finished=0;
    
    if ([workouts count]>0) {
        
        
        for (ExcersicePlay *excersice in workouts) {
            
            
            if([excersice.intro length]>0)
            {
                excersiceIntroCount=excersiceIntroCount+1;
                [self downloadVideos:excersice.intro  :excersice.intro_name];
                
            }
            
            if([excersice.main length]>0)
            {
                excersiceMainCount=excersiceMainCount+1;
                [self downloadVideos:excersice.main:excersice.main_name];
            }
            
            if([excersice.main_other length]>0)
            {
                excersiceOtherCount=excersiceOtherCount+1;
                [self downloadVideos:excersice.main_other:excersice.main_other_name];
                
            }
            
        }
        totalcount= excersiceIntroCount+excersiceMainCount+excersiceOtherCount;
        [self.delegate didfinishedWorkout:finished:totalcount];
        
    }
}


-(void)parseWorkoutVideoList:(NSString*)responseString
{
    NSDictionary *object = [responseString JSONValue];
    
    NSMutableArray *itemsarray =[object valueForKey:@"workoutvideos"];
    
    
    for (int i=0; i<[itemsarray count]; i++) {
        
        [self insertWorkoutVideos :[itemsarray objectAtIndex:i]];
    }
}


//method to  initialize database for  database operations
-(void)initilaizeDatabase
{
    excersiceDB =[[ExcersiceDB alloc]init];
    [excersiceDB setUpDatabase];
    [excersiceDB createDatabase];
}




//method to insert the records related to a workout
-(void)insertWorkoutVideos:(NSMutableArray *)excersices
{
    [self initilaizeDatabase];
    [excersiceDB insertWorkoutExcersices:excersices];
    
}

-(void)downloadVideos:(NSString *)url:(NSString*)name{
    
    if ([url length]>0 && [name length]>0) {
        
        
        // Get documents folder
        NSString *dataPath1 =  [Fitness4MeUtils path];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath1]){
            //Create Folder
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath1 withIntermediateDirectories:YES attributes:nil error:nil];
            
        }
        NSString  *filepath =[dataPath1 stringByAppendingPathComponent :name];
        
        NSString *UrlPath=[[NSString getVideoPath] stringByAppendingString:url];
        
        BOOL isReachable =[Fitness4MeUtils isReachable];
        if (isReachable){
            // Check If File Does Exists if not download the video
            if (![[NSFileManager defaultManager] fileExistsAtPath:filepath]){
                
                //   [self.myQueue cancelAllOperations];
                
                [self.myQueue setDelegate:self];
                [self.myQueue setShowAccurateProgress:YES];
                [self.myQueue setRequestDidFinishSelector:@selector(requestDidFinish:)];
                [self.myQueue setRequestDidFailSelector:@selector(requestDidFail:)];
                downloadrequest =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:UrlPath]];
                [downloadrequest setDownloadDestinationPath:filepath];
                [downloadrequest setTimeOutSeconds:100];
                [downloadrequest shouldContinueWhenAppEntersBackground];
                // [downloadrequest startAsynchronous];
                [myQueue addOperation:[downloadrequest copy]];
                [myQueue go];
            }
            
            else
            {
                finished=finished+1;
                [self.delegate didfinishedWorkout:finished:totalcount];
            }
            
        }
        else{
            [self.delegate didfinishedWorkout:0:0];
        }
        
    }
}


//- (void)downloadImages:(NSString *)url:(NSString*)name
//{
//
//
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
//    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyFolder"];
//
//    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
//        //Create Folder
//        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
//
//    }
//
//    NSString  *storeURL= [dataPath stringByAppendingPathComponent :name];
//
//
//    // Check If File Does Exists if not download the video
//    if (![[NSFileManager defaultManager] fileExistsAtPath:storeURL]){
//
//        [self.myQueue setDelegate:self];
//        [self.myQueue setShowAccurateProgress:YES];
//        [self.myQueue setRequestDidFailSelector:@selector(requestDidFail:)];
//        [self.myQueue setRequestDidReceiveResponseHeadersSelector:@selector(requestDidrec:)];;
//        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
//        [request setDownloadDestinationPath:storeURL];
//         [request setTimeOutSeconds:200];
//        [request setDelegate:self];
//       // [request startAsynchronous];
//
//        [myQueue addOperation:[request copy]];
//
//        [myQueue go];
//    }
//}







int finished=0;
- (void)requestDidFinish:(ASINetworkQueue *)queue
{
    finished=finished+1;
    [self.delegate didfinishedWorkout:finished:totalcount];
    
    if (finished==totalcount) {
        [myQueue setDelegate:nil];
        [myQueue cancelAllOperations];
        
        totalcount=0;
        excersiceIntroCount=0;
        excersiceMainCount=0;
        excersiceOtherCount=0;
        finished=0;
        
        
    }
    
}


- (void)requestDidFail:(ASINetworkQueue *)queue
{
    
    [self.delegate didfinishedWorkout:0:0];
    
    
    [myQueue setDelegate:nil];
    [myQueue cancelAllOperations];
    
    totalcount=0;
    excersiceIntroCount=0;
    excersiceMainCount=0;
    excersiceOtherCount=0;
    finished=0;
    
    
    
    
}

@end
