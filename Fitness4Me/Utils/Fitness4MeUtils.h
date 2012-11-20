//
//  Fitness4MeUtils.h
//  Fitness4Me
//
//  Created by Ciby on 07/08/12.
//
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface Fitness4MeUtils : UIViewController
{
    
    Reachability* internetReachable;
    Reachability* hostReachable;
}

+(int)getuserLevel;
+(int)getApplicationLanguage;

+(BOOL)isReachable;
+(BOOL) validUsername:(NSString*) username;
+(BOOL) validEmail:(NSString*) emailString;


+(void)showAlert:(NSString*)message;
+(void)setViewMovedUp:(BOOL)movedUp:(UIView*)view :(BOOL)stayup:(int)offset;

+(void)navigateToHomeView:(UIViewController*)selfViewController;


+(NSString *)path;
+(NSBundle*)getBundle;

@end
