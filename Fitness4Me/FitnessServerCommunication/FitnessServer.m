//
//  FitnessServer.m
//  Fitness4Me
//
//  Created by Ciby  on 17/12/12.
//
//

#import "FitnessServer.h"

@implementation FitnessServer

static FitnessServer *sharedState;

#pragma mark -
#pragma mark FitnessServerCommunication singleton method

+ (FitnessServer *)sharedState {
    
    @synchronized(self) {
        if (sharedState == nil)
            sharedState = [[self alloc] init];
        
    }
    return sharedState;
}


- (void)parseMembership:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(Responseblock)completionBlock onError:(NSError*)errorBlock {
    
    NSString *UrlPath= [NSString GetURlPath];
    int  selectedLanguage=[Fitness4MeUtils getApplicationLanguage];
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        
        NSString *requestString =[NSString stringWithFormat:@"%@membership=yes&currency=1&lang=%i",UrlPath,selectedLanguage];
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            if ([responseString length]>0) {
                [self parseWorkoutList:responseString];
                if (completionBlock) completionBlock(responseString);
            }else{
                [self terminateActivities:NSLocalizedStringWithDefaultValue(@"slowdata", nil,[Fitness4MeUtils getBundle], nil, nil):activityIndicator:signUpView];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            [self terminateActivities:NSLocalizedStringWithDefaultValue(@"requestError", nil,[Fitness4MeUtils getBundle], nil, nil):activityIndicator:signUpView];
        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedStringWithDefaultValue(@"NoInternetMessage", nil,[Fitness4MeUtils getBundle], nil, nil):activityIndicator:signUpView];
    }
    
}


- (void)membershipPlanUser:(NSString*)membershipPlanID activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(Responseblock)completionBlock onError:(NSError*)errorBlock {
     __block NSString *status;
    NSString *UrlPath= [NSString GetURlPath];
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        int userID =[userinfo integerForKey:@"UserID"];
        NSString *requestString =[NSString stringWithFormat:@"%@usermembership=yes&user_id=%i&membership_id=%@",UrlPath,userID,membershipPlanID];
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            if ([responseString length]>0) {
                  status=[self parseStatus:responseString];
                if (completionBlock) completionBlock(status);
            }else{
                [self terminateActivities:NSLocalizedStringWithDefaultValue(@"slowdata", nil,[Fitness4MeUtils getBundle], nil, nil):activityIndicator:signUpView];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            [self terminateActivities:NSLocalizedStringWithDefaultValue(@"requestError", nil,[Fitness4MeUtils getBundle], nil, nil):activityIndicator:signUpView];
        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedStringWithDefaultValue(@"NoInternetMessage", nil,[Fitness4MeUtils getBundle], nil, nil):activityIndicator:signUpView];
    }
    
}



- (void)storeRecipt:(NSString*)recipt activitIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(Responseblock)completionBlock onError:(NSError*)errorBlock
{
    __block NSString *status;
    NSString *UrlPath= [NSString GetURlPath];
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        int userID =[userinfo integerForKey:@"UserID"];
        NSString *requestString =[NSString stringWithFormat:@"%@storeReceipt=yes&user_id=%i&receipt=%@",UrlPath,userID,recipt];
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            if ([responseString length]>0) {
               
                  status=[self parseStatus:responseString];
                if (completionBlock) completionBlock(status);
            }else{
                [self terminateActivities:NSLocalizedStringWithDefaultValue(@"slowdata", nil,[Fitness4MeUtils getBundle], nil, nil):activityIndicator:signUpView];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            [self terminateActivities:NSLocalizedStringWithDefaultValue(@"requestError", nil,[Fitness4MeUtils getBundle], nil, nil):activityIndicator:signUpView];
        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedStringWithDefaultValue(@"NoInternetMessage", nil,[Fitness4MeUtils getBundle], nil, nil):activityIndicator:signUpView];
    }
    

}


- (void)verifyReciptwithPlanID:(NSString*)planID activitIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(Responseblock)completionBlock onError:(NSError*)errorBlock;
{
    __block NSString *status;
    NSString *UrlPath= [NSString GetURlPath];
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        int userID =[userinfo integerForKey:@"UserID"];
        NSString *requestString =[NSString stringWithFormat:@"%@processReceipt=yes&user_id=%i&plan=%@",UrlPath,userID,planID];
        NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        __weak ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
        
        [requests setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString =[requests responseString];
            if ([responseString length]>0) {
                status=[self parseStatus:responseString];
                
                if (completionBlock) completionBlock(status);
            }else{
                [self terminateActivities:NSLocalizedStringWithDefaultValue(@"slowdata", nil,[Fitness4MeUtils getBundle], nil, nil):activityIndicator:signUpView];
            }
        }];
        [requests setFailedBlock:^{
            //NSError *error = [requests error];
            [self terminateActivities:NSLocalizedStringWithDefaultValue(@"requestError", nil,[Fitness4MeUtils getBundle], nil, nil):activityIndicator:signUpView];
        }];
        [requests startAsynchronous];
    }else{
        [self terminateActivities:NSLocalizedStringWithDefaultValue(@"NoInternetMessage", nil,[Fitness4MeUtils getBundle], nil, nil):activityIndicator:signUpView];
    }
    
    
}




- (NSString *)parseStatus:(NSString *)responseString
{
    NSLog(responseString);
    NSString *status;
    NSMutableArray *object = [responseString JSONValue];
    NSMutableArray *itemsarray =[object valueForKey:@"items"];
    for (int i=0; i<[itemsarray count]; i++) {
        status=[[itemsarray objectAtIndex:i] valueForKey:@"status"];
    }
    return status;
}

-(void)parseWorkoutList:(NSString*)responseString
{
    NSMutableArray *object = [responseString JSONValue];
    parsedArray = [[NSMutableArray alloc]init];
    NSMutableArray *itemsarray =[object valueForKey:@"items"];
    
    [itemsarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* item = obj;
        Membership *membership=[[Membership alloc]init];
        membership.membershipID=[item objectForKey:@"membership_id"];
        membership.rate=[item objectForKey:@"rate"];
        membership.discount=[item objectForKey:@"discount"];
        membership.free=[item objectForKey:@"free"];
        membership.advanceMonths=[item objectForKey:@"advance_months"];
        membership.description=[item objectForKey :@"desc"];
        membership.name=[item objectForKey:@"name"];
        membership.currency=[item objectForKey:@"currency"];
        int membershipID= [[membership membershipID]intValue];
        NSString *appleID;
        
         switch (membershipID) {
            case 1:
                
                appleID =@"Full.fitness4.me.monthly";
                break;
            case 2:
                
                appleID =@"Full.fitness4.me.supersaver1";
                break;
            case 3:
                
                appleID =@"Full.fitness4.me.supersaver2";
                break;
            case 4:
                
                appleID =@"Full.fitness4.me.supersaver3";
                break;
                            
            default:
                break;
        }
        membership.appleID =appleID;
        [parsedArray addObject:membership];
    }];
    
    if ([parsedArray count]>0) {
        [self insertMembership];
    }
    
}


- (void)setupDB
{
    membershipDB =[[MembershipDB alloc]init];
    [membershipDB setUpDatabase];
    [membershipDB createDatabase];
}



-(void)insertMembership
{
    [self setupDB];
    [membershipDB insertMemberships:parsedArray];
}



-(void)terminateActivities:(NSString*)message :(UIActivityIndicatorView*)activityIndicator :(UIView*)signUpView{
    
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
