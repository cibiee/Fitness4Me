//
//  FitnessServer.h
//  Fitness4Me
//
//  Created by Ciby  on 17/12/12.
//
//

#import <Foundation/Foundation.h>
#import "NSString+Config.h"
#import "Reachability.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "Fitness4MeUtils.h"
#import "SBJson.h"
#import "SBJsonParser.h"
#include "Membership.h"
#include "MembershipDB.h"

typedef void (^Responseblock)(NSString *response);
typedef void (^errorblock)(NSString *errorString);

@interface FitnessServer : NSObject{
    NSMutableArray *parsedArray;
    MembershipDB *membershipDB;
}
+ (FitnessServer *)sharedState;

- (void)parseMembership:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(Responseblock)completionBlock onError:(NSError*)errorBlock;

- (void)membershipPlanUser:(NSString*)membershipPlanID activityIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(Responseblock)completionBlock onError:(NSError*)errorBlock;

- (void)storeRecipt:(NSString*)recipt activitIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(Responseblock)completionBlock onError:(NSError*)errorBlock;

- (void)verifyReciptwithPlanID:(NSString*)planID activitIndicator:(UIActivityIndicatorView*)activityIndicator progressView:(UIView*)signUpView onCompletion:(Responseblock)completionBlock onError:(NSError*)errorBlock;

@end
NSMutableArray *GlobalArray;