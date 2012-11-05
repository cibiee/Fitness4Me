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


+(void)showAlert:(NSString*)message;
+(BOOL) validUsername:(NSString*) username;
+(BOOL) validEmail:(NSString*) emailString;
+(void)setViewMovedUp:(BOOL)movedUp:(UIView*)view :(BOOL)stayup:(int)offset;
+(void)showAdMob:(UIViewController*)viewController;
+(void)showAdMobLandscape:(UIViewController*)viewController;
+(void)showAdMobPrelogin:(UIViewController*)viewController;
+(void)navigateToHomeView:(UIViewController*)selfViewController;
+(NSBundle*)getBundle;
+(void)registerDevice :(UIView *)signUpView;
+(int)getuserLevel;
+(BOOL)isReachable;

+ (NSString *)path;

+ (int)getApplicationLanguage;
@end
