//
//  FitnessServerCommunication.m
//  Fitness4Me
//
//  Created by Ciby K Jose on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FitnessServerCommunication.h"


@interface FitnessServerCommunication ()
{
}

@end

@implementation FitnessServerCommunication
int finished=0;
static FitnessServerCommunication *sharedState;
@synthesize delegate,workouts,myQueue,imageQueue;
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

- (void)login:(NSString *)username password:(NSString *)password activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock 

{
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
        NSString *UrlPath= [NSString GetURlPath];
        NSString *requestString =[NSString stringWithFormat:@"%@login=yes&username=%@&password=%@",UrlPath,username,password];
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            if ([responseString length]>0) {
                if (completionBlock) completionBlock(responseString);
            }else{
                [self terminateActivities:NSLocalizedString(@"slowdata", nil):activityIndicator:signUpView];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            [self terminateActivities:NSLocalizedString(@"requestError", nil):activityIndicator:signUpView];
        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):activityIndicator:signUpView];
    }
}


- (void)isValidEmail:(NSString *)email andActivityIndicator:(UIActivityIndicatorView*)activityIndicator onCompletion:(ResponseBlock)completionBlock onError:(NSError*)errorBlock

{
    __block NSString *IsExist;
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
        NSString *UrlPath= [NSString GetURlPath];
        NSString *requestString =[NSString stringWithFormat: @"%@checkemail=yes&email=%@", UrlPath,email];
              NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
           
            if ([responseString length]>0) {
                IsExist = [self Isvalid:responseString];
                if (completionBlock) completionBlock(IsExist);
            }else{
                [self terminateActivities:NSLocalizedString(@"slowdata", nil):activityIndicator:nil];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            [self terminateActivities:NSLocalizedString(@"requestError", nil):activityIndicator:nil];
        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):activityIndicator:nil];
    }
}


- (void)isValidUsername:(NSString *)username andActivityIndicator:(UIActivityIndicatorView*)activityIndicator onCompletion:(ResponseBlock)completionBlock onError:(NSError*)errorBlock

{
    __block NSString *IsExist;
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
        NSString *UrlPath= [NSString GetURlPath];
        NSString *requestString =[NSString stringWithFormat: @"%@checkusername=yes&username=%@",UrlPath, username];
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            
            if ([responseString length]>0) {
                IsExist = [self Isvalid:responseString];
                if (completionBlock) completionBlock(IsExist);
            }else{
                [self terminateActivities:NSLocalizedString(@"slowdata", nil):activityIndicator:nil];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            [self terminateActivities:NSLocalizedString(@"requestError", nil):activityIndicator:nil];
        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):activityIndicator:nil];
    }
}


- (void)registerDeviceWithUserID:(int)userId andSignUpView:(UIView*)signUpView onCompletion:(ResponseVoidBlock)completionBlock onError:(NSError*)errorBlock

{
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
        NSString *devToken;
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        devToken =[userinfo stringForKey:@"deviceToken"];
        UIDevice *dev = [UIDevice currentDevice];
        NSString *deviceUuid = dev.uniqueIdentifier;
        NSString *requestUrl =[NSString stringWithFormat:@"%@iphone_register.php?deviceregister=yes&userid=%i&devicetoken=%@&deviceuid=%@",[NSString getDeviceRegisterPath],userId,devToken,deviceUuid];
        NSURL *urlrequest =[NSURL URLWithString:requestUrl];
        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:urlrequest];
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            if ([responseString length]>0) {
                
            }else{
                [self terminateActivities:NSLocalizedString(@"slowdata", nil):nil:signUpView];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            [self terminateActivities:NSLocalizedString(@"requestError", nil):nil:signUpView];
        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):nil:signUpView];
    }
}




- (void)sendFeedback:(NSString *)feedback byUser:(NSString*)username email:(NSString*)email  onCompletion:(ResponseBlock)completionBlock onError:(NSError*)errorBlock

{
    __block NSString *IsExist;
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
       // NSString *UrlPath= [NSString GetURlPath];
        NSString *requestString =[NSString stringWithFormat:@"http://fitness4metesting.com/mobile/testjson.php?user_name=%@&user_email=%@&feedback=%@",username,email,feedback];
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];

        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            
            if ([responseString length]>0) {
                IsExist = [self Isvalid:responseString];
                if (completionBlock) completionBlock(IsExist);
            }else{
                [self terminateActivities:NSLocalizedString(@"slowdata", nil):nil:nil];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            [self terminateActivities:NSLocalizedString(@"requestError", nil):nil:nil];
        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):nil:nil];
    }
}



- (void)updateUserWithName:(NSString *)name surname:(NSString*)surname email:(NSString*)email userLevel:(NSString*)userLevel userID:(NSString*)userID  activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(ResponseBlock)completionBlock onError:(NSError*)errorBlock

{
    __block NSString *IsExist;
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
        NSString *UrlPath= [NSString GetURlPath];
        NSString *requestString =[NSString stringWithFormat:@"%@user_setting=yes&user_name=%@&user_surname=%@&user_email=%@&user_level=%@&user_id=%@",UrlPath,name,@"",email,userLevel,userID];
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
        
        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        [requests setCompletionBlock:^{
            NSString *responseString =[requests responseString];
            
            if ([responseString length]>0) {
                IsExist = [self IsUpdated:responseString];
                if (completionBlock) completionBlock(IsExist);
            }else{
                [self terminateActivities:NSLocalizedString(@"slowdata", nil):activityIndicator:signUpView];
            }
        }];
        [requests setFailedBlock:^{
            [self terminateActivities:NSLocalizedString(@"requestError", nil):activityIndicator:signUpView];

        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):activityIndicator:signUpView];

    }
}


- (void)UpdateServerWithPurchaseStatus:(NSString *)purchaseStatus hasMadefullpurchase:(NSString*)purchaseAll workoutID:(NSString*)workoutID  userID:(NSString*)userID  activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(ResponseBlock)completionBlock onError:(NSError*)errorBlock

{
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        __block NSString *IsExist;
        NSString *UrlPath= [NSString GetURlPath];
        NSString *requestString;
        if( [purchaseAll isEqualToString:@"true"]){
            requestString=  [NSString stringWithFormat:@"%@unlockiphone=yes&userid=%@&workoutid=%@&purchase_status=%@&type=all",UrlPath,userID,@"''",purchaseStatus];
        }else {
            requestString =[NSString stringWithFormat:@"%@unlockiphone=yes&userid=%@&workoutid=%@&purchase_status=%@&type=single",UrlPath,userID, workoutID,purchaseStatus];
        }

        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        [requests setCompletionBlock:^{
            NSString *responseString =[requests responseString];
            
            if ([responseString length]>0) {
                IsExist = [self Isvalid:responseString];
                if (completionBlock) completionBlock(IsExist);
            }else{
                [self terminateActivities:NSLocalizedString(@"slowdata", nil):nil:signUpView];
            }
        }];
        [requests setFailedBlock:^{
            [self terminateActivities:NSLocalizedString(@"requestError", nil):nil:signUpView];
            
        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):nil:signUpView];
        
    }
}

- (void)parserExcersiceDetailsForWorkoutID:(NSString *)workoutID userLevel:(NSString *)userLevel  language:(int )selectedlanguage activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock {
   
    NSString *UrlPath= [NSString GetURlPath];

    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        
        NSString *requestString =[NSString stringWithFormat:@"%@videos=yes&workoutid=%@&userlevel=%@&lang=%i",UrlPath,workoutID,userLevel,selectedlanguage];
         NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            if ([responseString length]>0) {
                if (completionBlock) completionBlock(responseString);
            }else{
                [self terminateActivities:NSLocalizedString(@"slowdata", nil):activityIndicator:signUpView];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            [self terminateActivities:NSLocalizedString(@"requestError", nil):activityIndicator:signUpView];
        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):activityIndicator:signUpView];
    }

}

- (void)listEquipments:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock

{
    int  selectedLanguage=[Fitness4MeUtils getApplicationLanguage] ;

    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
        NSString *UrlPath= [NSString GetURlPath];
        NSString *requestString =[NSString stringWithFormat:@"%@listequipment=yes&lang=%i",UrlPath,selectedLanguage];
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            if ([responseString length]>0) {
                [self parseEquipments:responseString];
                if (completionBlock) completionBlock(responseString);
            }else{
              //  [self terminateActivities:NSLocalizedString(@"slowdata", nil):activityIndicator:signUpView];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
           // [self terminateActivities:NSLocalizedString(@"requestError", nil):activityIndicator:signUpView];
        }];
        [requests startAsynchronous];
    }else{
       // [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):activityIndicator:signUpView];
    }
}


- (void)listfocus:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock

{
    int  selectedLanguage=[Fitness4MeUtils getApplicationLanguage] ;

    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
        NSString *UrlPath= [NSString GetURlPath];
        NSString *requestString =[NSString stringWithFormat:@"%@listmuscles=yes&lang=%i",UrlPath,selectedLanguage];
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            if ([responseString length]>0) {
                [self parseFocus:responseString];
                if (completionBlock) completionBlock(responseString);
            }else{
               // [self terminateActivities:NSLocalizedString(@"slowdata", nil):activityIndicator:signUpView];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
          //  [self terminateActivities:NSLocalizedString(@"requestError", nil):activityIndicator:signUpView];
        }];
        [requests startAsynchronous];
    }else{
        //[self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):activityIndicator:signUpView];
    }
}

- (void)saveCustomWorkout:(Workout*)workout  userID:(NSString*)userID userLevel:(NSString *)userLevel language:(int )selectedlanguage  activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock

{
    __block NSString *workoutID;
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
        if ([[workout Props]length]>0) {
            
        }
        else
        {
            [workout setProps:@" "];
        }
        
        NSString *UrlPath= [NSString GetURlPath];
        NSString *requestString;
        if ([[workout WorkoutID]intValue]>0) {
           requestString =[NSString stringWithFormat:@"%@editcustom=yes&user_id=%@&user_level=%@&customname=%@&duration=%@&equipment=%@&focus=%@&lang=%i&custom_workout_id=%@",UrlPath,userID,userLevel,[workout Name],[workout Duration],[workout Props],[workout Focus],selectedlanguage,[workout WorkoutID]];
        }
        else{
         requestString =[NSString stringWithFormat:@"%@createcustom=yes&user_id=%@&user_level=%@&customname=%@&duration=%@&equipment=%@&focus=%@&lang=%i",UrlPath,userID,userLevel,[workout Name],[workout Duration],[workout Props],[workout Focus],selectedlanguage];
        }
      //  NSLog(requestString);
        
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            if ([responseString length]>0) {
                workoutID =[self parseWorkoutID:responseString];
                if (completionBlock) completionBlock(workoutID);
            }else{
                [self terminateActivities:NSLocalizedString(@"slowdata", nil):activityIndicator:signUpView];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            [self terminateActivities:NSLocalizedString(@"requestError", nil):activityIndicator:signUpView];
        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):activityIndicator:signUpView];
    }
}

- (void)deleteCustomWorkout:(NSString*)workoutID  userID:(int)userID   activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock

{
     __block NSString *IsExist;

    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
        NSString *UrlPath= [NSString GetURlPath];
        NSString *requestString;
       
        requestString =[NSString stringWithFormat:@"%@deletecustom=yes&user_id=%i&custom_workout_ids=%@",UrlPath,userID,workoutID];
        
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            if ([responseString length]>0) {
                IsExist=[self Isvalid:responseString];
                if (completionBlock) completionBlock(IsExist);
            }else{
                [self terminateActivities:NSLocalizedString(@"slowdata", nil):activityIndicator:signUpView];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            [self terminateActivities:NSLocalizedString(@"requestError", nil):activityIndicator:signUpView];
        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):activityIndicator:signUpView];
    }
}



-(void)parseCustomFitnessDetails:(int)userID onCompletion:(ResponseBlock)completionBlock onError:(NSError*)errorBlock {
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
        NSString *UrlPath= [NSString GetURlPath];
        int  selectedLanguage=[Fitness4MeUtils getApplicationLanguage] ;
        
        NSString *requestString = [NSString stringWithFormat:@"%@listcustom=yes&user_id=%i&lang=%i",UrlPath, userID,selectedLanguage];
        
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            if ([responseString length]>0) {
             //   NSLog(responseString);
                [self parseCustomWorkoutList:responseString];
                if (completionBlock) completionBlock(responseString);
            }else{
               // [self terminateActivities:NSLocalizedString(@"slowdata", nil):nil:nil];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            //[self terminateActivities:NSLocalizedString(@"requestError",nil):nil:nil];
            
        }];
        [requests startAsynchronous];
    }else{
      //  [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):nil:nil];
        
    }
}


#pragma mark SELF MADE WORKOUT 

-(void)parseSelfMadeFitnessDetails:(int)userID onCompletion:(ResponseBlock)completionBlock onError:(NSError*)errorBlock {
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
        NSString *UrlPath= [NSString GetURlPath];
        int  selectedLanguage=[Fitness4MeUtils getApplicationLanguage] ;
        
        NSString *requestString = [NSString stringWithFormat:@"%@selfmadelist=yes&userid=%i&lang=%i",UrlPath, userID,selectedLanguage];
        
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            if ([responseString length]>0) {
              //  NSLog(responseString);
                [self parseSelfMadeWorkoutList:responseString];
                if (completionBlock) completionBlock(responseString);
            }else{
                // [self terminateActivities:NSLocalizedString(@"slowdata", nil):nil:nil];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            //[self terminateActivities:NSLocalizedString(@"requestError",nil):nil:nil];
            
        }];
        [requests startAsynchronous];
    }else{
        //  [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):nil:nil];
        
    }
}


- (void)listExcersiceWithequipments:(NSString*)equipments focus:(NSString*)focus  activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock

{
   
    int selectedLang=[Fitness4MeUtils getApplicationLanguage];
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
        NSString *UrlPath= [NSString GetURlPath];
        NSString *requestString =[NSString stringWithFormat:@"%@listexercises=yes&equipment=%@&focus=%@&lang=%i",UrlPath,equipments,focus,selectedLang];
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
      //  NSLog(url);
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            if ([responseString length]>0) {
                
                if (completionBlock) completionBlock(responseString);
            }else{
                [self terminateActivities:NSLocalizedString(@"slowdata", nil):activityIndicator:signUpView];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            [self terminateActivities:NSLocalizedString(@"requestError", nil):activityIndicator:signUpView];
        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):activityIndicator:signUpView];
    }
}


- (void)saveSelfMadeWorkout:(NSString*)workoutName workoutCollection:(NSString*)workoutCollection workoutID:(NSString*)workoutID   userID:(NSString*)userID userLevel:(NSString *)userLevel language:(int )selectedlanguage focus:(NSString *)focus equipments:(NSString *)equipments activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock

{
    __block NSString *workoutsID;
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
        
        NSString *UrlPath= [NSString GetURlPath];
        NSString *requestString;
        if ([workoutID intValue]>0) {
            //           requestString =[NSString stringWithFormat:@"%@editcustom=yes&user_id=%@&user_level=%@&customname=%@&duration=%@&equipment=%@&focus=%@&lang=%i&custom_workout_id=%@",UrlPath,userID,userLevel,[workout Name],[workout Duration],[workout Props],[workout Focus],selectedlanguage,[workout WorkoutID]];
        }
        else{
            
            requestString =[NSString stringWithFormat:@"%@createselfmade=yes&userid=%@&user_level=%@&selfmadename=%@&collection=%@&lang=%i&focus=%@&equip=%@",UrlPath,userID,userLevel,workoutName,workoutCollection,selectedlanguage,focus,equipments];
            
        }
      //  NSLog(requestString);
        
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            if ([responseString length]>0) {
               // NSLog(responseString);
                  workoutsID =[self parseWorkoutID:responseString];
                if (completionBlock) completionBlock(workoutsID);
            }else{
                [self terminateActivities:NSLocalizedString(@"slowdata", nil):activityIndicator:signUpView];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            [self terminateActivities:NSLocalizedString(@"requestError", nil):activityIndicator:signUpView];
        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):activityIndicator:signUpView];
    }
}


- (void)deleteSelfMadeWorkout:(NSString*)workoutID  userID:(int)userID   activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock

{
    __block NSString *IsExist;
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
        NSString *UrlPath= [NSString GetURlPath];
        NSString *requestString;
        
        requestString =[NSString stringWithFormat:@"%@deleteself=yes&user_id=%i&self_workout_ids=%@",UrlPath,userID,workoutID];
       
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            if ([responseString length]>0) {
                IsExist=[self Isvalid:responseString];
                if (completionBlock) completionBlock(IsExist);
            }else{
                [self terminateActivities:NSLocalizedString(@"slowdata", nil):activityIndicator:signUpView];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            [self terminateActivities:NSLocalizedString(@"requestError", nil):activityIndicator:signUpView];
        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):activityIndicator:signUpView];
    }
}


- (void)setWorkoutfavourite:(NSString*)workoutID UserID:(int)userID Status:(NSString*)status  activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock

{
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    userID =[userinfo integerForKey:@"UserID"];
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
        
        NSString *UrlPath= [NSString GetURlPath];
        NSString *requestString =[NSString stringWithFormat:@"%@customfav=yes&user_id=%i&fav_status=%@&custom_workout_id=%@",UrlPath,userID,status,workoutID];
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
       // NSLog(requestString);
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            if ([responseString length]>0) {
                
                if (completionBlock) completionBlock(responseString);
            }else{
                [self terminateActivities:NSLocalizedString(@"slowdata", nil):activityIndicator:signUpView];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            [self terminateActivities:NSLocalizedString(@"requestError", nil):activityIndicator:signUpView];
        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):activityIndicator:signUpView];
    }
}



- (void)setSelfMadeWorkoutfavourite:(NSString*)workoutID UserID:(int)userID Status:(NSString*)status  activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(WMLoginResponseBlock)completionBlock onError:(NSError*)errorBlock

{
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    userID =[userinfo integerForKey:@"UserID"];

    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable)
    {
      
        NSString *UrlPath= [NSString GetURlPath];
        NSString *requestString =[NSString stringWithFormat:@"%@selffav=yes&user_id=%i&fav_status=%@&self_workout_id=%@",UrlPath,userID,status,workoutID];
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   //     NSLog(requestString);
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            if ([responseString length]>0) {
                
                if (completionBlock) completionBlock(responseString);
            }else{
                [self terminateActivities:NSLocalizedString(@"slowdata", nil):activityIndicator:signUpView];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            [self terminateActivities:NSLocalizedString(@"requestError", nil):activityIndicator:signUpView];
        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):activityIndicator:signUpView];
    }
}





-(void) getImageAtPath:(NSString *)imageUrl toDestination:( NSString *)storeURL setDelegate:(UIViewController*)viewController
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    [request setDownloadDestinationPath:storeURL];
    [request setDelegate:viewController];
    [request startAsynchronous];
}

-(void)parseFitnessDetails:(int)userID {
    
    
    NSString *urlPath= [NSString GetURlPath];
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        
        int  selectedLanguage=[Fitness4MeUtils getApplicationLanguage] ;
        
        NSString *requestString = [NSString stringWithFormat:@"%@listapps=yes&userid=%i&duration=10&lang=%i&bridgetest=1",urlPath, userID,selectedLanguage];
        
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
            }else
            {
                [self terminateActivities:NSLocalizedString(@"slowdata", nil):activityIndicator:signUpView];            }
        }else
        {
            [self terminateActivities:NSLocalizedString(@"requestError", nil):activityIndicator:signUpView];
        }
    }else
    {
        [self terminateActivities:NSLocalizedString(@"NoInternetMessage", nil):activityIndicator:signUpView];
    }
    
    return [userID intValue];
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
 
    if ([object count]>0) {
        
    NSArray *keyArray =[object allKeys];
    if ([keyArray count]>0) {
        
        keyValue =[NSString stringWithFormat:@"%@",[keyArray objectAtIndex:0]];
    }
    
    if ([keyValue isEqualToString:@"items"]) {
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
        }
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
    [self setupWorkoutDB];
    [workoutDB insertWorkouts:workouts];
}


-(void)insertCustomExcersices
{
    [self setupWorkoutDB];
    [workoutDB insertCustomWorkouts:workouts];
}


-(void)insertSelfMadeExcersices
{
    [self setupWorkoutDB];
    [workoutDB insertSelfMadeWorkouts:workouts];
}

-(void)deleteCustomWorkouts
{
    [self setupWorkoutDB];
    [workoutDB deleteCustomWorkout];
}

-(void)deleteSelfMadeWorkouts
{
    [self setupWorkoutDB];
    [workoutDB deleteSelfMadeWorkout];
}

- (void)setupWorkoutDB
{
    workoutDB =[[WorkoutDB alloc]init];
    [workoutDB setUpDatabase];
    [workoutDB createDatabase];
}




-(void)insertEquipments:(NSMutableArray*)equipments
{
    equipmentDB =[[EquipmentDB alloc]init];
    [equipmentDB setUpDatabase];
    [equipmentDB createDatabase];
    [equipmentDB insertEquipments:equipments];
}



-(void)insertFocus:(NSMutableArray*)muscles
{
    focusDB =[[FocusDB alloc]init];
    [focusDB setUpDatabase];
    [focusDB createDatabase];
    [focusDB insertFocusArea:muscles];
}



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


- (void)praseworkoutArray:(NSString *)responseString
{
    NSMutableArray *object = [responseString JSONValue];
    workouts = [[NSMutableArray alloc]init];
    NSMutableArray *itemsarray =[object valueForKey:@"items"];
    [itemsarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* item = obj;
        
        [workouts addObject:[[Workout alloc]initWithCustomData:[item objectForKey:@"id"]:[item objectForKey:@"name"]:[item objectForKey:@"rate"]:[item objectForKey:@"image_android"]:[item objectForKey:@"image_name"]:[item objectForKey :@"isFav"]:[item objectForKey:@"description"]:[item objectForKey:@"description_big"]:nil:[item objectForKey:@"description_big"]:[item objectForKey :@"image_thumb"]:[item objectForKey:@"equipment"]:[item objectForKey:@"duration"]:[item objectForKey:@"focus"]]];
    }];
}

-(void)parseCustomWorkoutList:(NSString*)responseString
{
    [self praseworkoutArray:responseString];
    
    [self deleteCustomWorkouts];
    
    if ([workouts count]>0) {
        
        [self insertCustomExcersices];
    }
}


-(void)parseSelfMadeWorkoutList:(NSString*)responseString
{
    [self praseworkoutArray:responseString];
    
    [self deleteSelfMadeWorkouts];
    
    if ([workouts count]>0) {
        
        [self insertSelfMadeExcersices];
    }
}



-(void)parseEquipments:(NSString*)responseString
{
    NSMutableArray *object = [responseString JSONValue];
    NSMutableArray *equipments = [[NSMutableArray alloc]init];
    NSMutableArray *itemsarray =[object valueForKey:@"equipments"];
    [itemsarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* item = obj;
        Equipments *equipment = [[Equipments alloc]init];
        [equipment setEquipmentID:[item objectForKey:@"equipment_id"]];
        [equipment setEquipmentName:[item objectForKey:@"equipment_name"]];
        [equipments addObject:equipment];
    }];
    
    if ([equipments count]>0) {
        
        [self insertEquipments:equipments];
    }
}

-(void)parseFocus:(NSString*)responseString
{
    NSMutableArray *object = [responseString JSONValue];
    NSMutableArray *muscles = [[NSMutableArray alloc]init];
    NSMutableArray *itemsarray =[object valueForKey:@"muscles"];
    
    [itemsarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* item = obj;
        Focus *focus = [[Focus alloc]init];
        [focus setMuscleID:[item objectForKey:@"muscle_id"]];
        [focus setMuscleName:[item objectForKey:@"muscle_name"]];
        [muscles addObject:focus];
    }];
    
    if ([muscles count]>0) {
        
        [self insertFocus:muscles];
    }
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
            if([excersice.intro length]>0){
                excersiceIntroCount=excersiceIntroCount+1;
                [self downloadVideos:excersice.intro  :excersice.intro_name];
            }
            
            if([excersice.main length]>0){
                excersiceMainCount=excersiceMainCount+1;
                [self downloadVideos:excersice.main:excersice.main_name];
            }
            
            if([excersice.main_other length]>0){
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
                [self.myQueue setDelegate:self];
                [self.myQueue setShowAccurateProgress:YES];
                [self.myQueue setRequestDidFinishSelector:@selector(requestDidFinish:)];
                [self.myQueue setRequestDidFailSelector:@selector(requestDidFail:)];
                downloadrequest =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:UrlPath]];
                [downloadrequest setDownloadDestinationPath:filepath];
                [downloadrequest setTimeOutSeconds:100];
                [downloadrequest shouldContinueWhenAppEntersBackground];
                [myQueue addOperation:[downloadrequest copy]];
                [myQueue go];
            }
            else{
                finished=finished+1;
                [self.delegate didfinishedWorkout:finished:totalcount];
            }
        }
        else{
            [self.delegate didfinishedWorkout:0:0];
        }
    }
}

- (void)resetRequest
{
    totalcount=0;
    excersiceIntroCount=0;
    excersiceMainCount=0;
    excersiceOtherCount=0;
    finished=0;
}

- (void)requestDidFinish:(ASINetworkQueue *)queue
{
    finished=finished+1;
    [self.delegate didfinishedWorkout:finished:totalcount];
    
    if (finished==totalcount) {
        [myQueue setDelegate:nil];
        [myQueue cancelAllOperations];
        
        [self resetRequest];
    }
    
}


- (void)downloadImageDidfinish:(ASINetworkQueue *)queue
{
        [self.delegate didfinishedDownloadImage];
        [myQueue setDelegate:nil];
        [myQueue cancelAllOperations];
}


- (void)requestDidFail:(ASINetworkQueue *)queue
{
    [self.delegate didfinishedWorkout:0:0];
    [myQueue setDelegate:nil];
    [myQueue cancelAllOperations];
    [self resetRequest];
}


- (NSString *)Isvalid:(NSString *)responseString
{
    NSString *IsExist;
    NSMutableArray *object = [responseString JSONValue];
    NSMutableArray *itemsarray =[object valueForKey:@"items"];
    for (int i=0; i<[itemsarray count]; i++) {
        IsExist=[[itemsarray objectAtIndex:i] valueForKey:@"status"];
    }
    return IsExist;
}

- (NSString *)IsUpdated:(NSString *)responseString
{
    NSString *IsExist;
    NSMutableArray *object = [responseString JSONValue];
    NSMutableArray *itemsarray =[object valueForKey:@"items"];
    for (int i=0; i<[itemsarray count]; i++) {
        IsExist=[[itemsarray objectAtIndex:i] valueForKey:@"message"];
    }
    return IsExist;
}

- (NSString *)parseWorkoutID:(NSString *)responseString
{
    NSString *workoutID;
    NSMutableArray *object = [responseString JSONValue];
    NSMutableArray *itemsarray =[object valueForKey:@"items"];
    for (int i=0; i<[itemsarray count]; i++) {
        workoutID=[[itemsarray objectAtIndex:i] valueForKey:@"custom_workout_id"];
    }
    return workoutID;
}


-(void)terminateActivities:(NSString*)message:(UIActivityIndicatorView*)activityIndicator:(UIView*)signUpView{
    
    [Fitness4MeUtils showAlert:message];
    [self removeActivity:activityIndicator];
    [self removeSignupView:signUpView];
}

-(void)removeActivity:(UIActivityIndicatorView*)activityIndicator;
{
    [activityIndicator setHidden:YES];
    [activityIndicator stopAnimating];
}

-(void)removeSignupView:(UIView*)signUpView{
    [signUpView removeFromSuperview];
}


@end
