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
+(BOOL)validUsername:(NSString*) username;
+(BOOL)validEmail:(NSString*) emailString;
+(void)getImageAtPath:(NSString *)imageUrl toDestination:( NSString *)storeURL setDelegate:(UIViewController*)viewController;
+(void)showAlert:(NSString*)message;
+(void)setViewMovedUp:(BOOL)movedUp:(UIView*)view :(BOOL)stayup:(int)offset;
+(void)showAdMob:(UIViewController*)viewController;
+(void)showAdMobLandscape:(UIViewController*)viewController;
+(void)showAdMobPrelogin:(UIViewController*)viewController;
+(void)navigateToHomeView:(UIViewController*)selfViewController;
+(void) createDirectoryatPath:(NSString *)dataPath;
+(NSString *)path;
+(NSBundle*)getBundle;

@end
