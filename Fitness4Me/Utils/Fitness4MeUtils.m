//
//  Fitness4MeUtils.m
//  Fitness4Me
//
//  Created by Ciby on 07/08/12.
//
//

#import "Fitness4MeUtils.h"
#import "GADBannerView.h"
#import "Fitness4MeViewController.h"

@implementation Fitness4MeUtils

#define kOFFSET_FOR_KEYBOARD 80;
+(void)showAlert:(NSString*)message{
    
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"fitness4.me" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertview show];
    
}


#pragma mark - validUsername Regular Expression Method
+(BOOL) validUsername:(NSString*) username
{
    NSString *regExPattern = @"^[a-zA-Z0-9]{1,100}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:username options:0 range:NSMakeRange(0, [username length])];
    
    if (regExMatches == 0) {
        return NO;
    }
    else
        return YES;
}


+(BOOL) validEmail:(NSString*) emailString
{
    
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
    if (regExMatches == 0) {
        return NO;
    }
    else
        return YES;
}

+(void)setViewMovedUp:(BOOL)movedUp:(UIView*)view :(BOOL)stayup:(int)offset
{
    
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
        CGRect rect = view.frame;
        if (movedUp){
            if (rect.origin.y == 0 ) {
                rect.origin.y -= offset;
            }
        }
        else{
            if (stayup == NO) {
                rect.origin.y += offset;
            }
        }
        view.frame = rect;
        [UIView commitAnimations];
    
}

+(void)showAdMob:(UIViewController*)viewController{
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    NSString *hasMadeFullPurchase= [userinfo valueForKey:@"hasMadeFullPurchase"];
    GADBannerView *bannerView_;
    if ([hasMadeFullPurchase isEqualToString:@"true"]) {
        
    }
    else {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            
            bannerView_ = [[GADBannerView alloc]
                           initWithFrame:CGRectMake(0,viewController.view.frame.size.height-50,
                                                    viewController.view.frame.size.width,
                                                    50)];

        }
        else {
            bannerView_ = [[GADBannerView alloc]
                           initWithFrame:CGRectMake(0,viewController.view.frame.size.height-90,
                                                    viewController.view.frame.size.width,
                                                    100)];
        }
        bannerView_.adUnitID = @"a1506940e575b91";
        [bannerView_ setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
        bannerView_.rootViewController = viewController;
        [viewController.view addSubview:bannerView_];
        [bannerView_ loadRequest:[GADRequest request]];
    }
}


+(void)showAdMobPrelogin:(UIViewController*)viewController
{
    GADBannerView *bannerView_;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        bannerView_ = [[GADBannerView alloc]
                       initWithFrame:CGRectMake(0,viewController.view.frame.size.height-50,
                                                viewController.view.frame.size.width,
                                                50)];
        
    }
    else {
        bannerView_ = [[GADBannerView alloc]
                       initWithFrame:CGRectMake(0,viewController.view.frame.size.height-90,
                                                viewController.view.frame.size.width,
                                                100)];
        
    }
    bannerView_.adUnitID = @"a1506940e575b91";
    [bannerView_ setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    bannerView_.rootViewController = viewController;
    [viewController.view addSubview:bannerView_];
    [bannerView_ loadRequest:[GADRequest request]];
}

+(void)showAdMobLandscape:(UIViewController*)viewController{
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    NSString *hasMadeFullPurchase= [userinfo valueForKey:@"hasMadeFullPurchase"];
    GADBannerView *bannerView_;
    
    if ([hasMadeFullPurchase isEqualToString:@"true"]) {
        
    }
    
    else {
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            
            bannerView_ = [[GADBannerView alloc]
                           initWithFrame:CGRectMake(0,viewController.view.frame.size.height-50,
                                                    viewController.view.frame.size.width,
                                                    50)];
            
        }
        else {
            bannerView_ = [[GADBannerView alloc]
                           initWithFrame:CGRectMake(0,viewController.view.frame.size.width-70,
                                                    viewController.view.frame.size.height-10,
                                                    90)];
            
        }
        bannerView_.adUnitID = @"a1506940e575b91";
        [bannerView_ setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
        bannerView_.rootViewController = viewController;
        [viewController.view addSubview:bannerView_];
        [bannerView_ loadRequest:[GADRequest request]];
        
    }
}


+(void)navigateToHomeView:(UIViewController*)selfViewController
{
    Fitness4MeViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[Fitness4MeViewController alloc]initWithNibName:@"Fitness4MeViewController" bundle:nil];
    }
    else{
        viewController =[[Fitness4MeViewController alloc]initWithNibName:@"Fitness4MeViewController_iPad" bundle:nil];
    }
    [selfViewController.navigationController pushViewController:viewController animated:YES];
    
}







+(BOOL)isReachable
{
    BOOL isReachable;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        isReachable=YES;
    }
    else{
        isReachable=NO;
    }
    return isReachable;
}

+ (NSString *)path {
       
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    return [documentsDirectory stringByAppendingPathComponent:@"MyFolder"];
    
    
}


+ (int)getApplicationLanguage {
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    int  selectedlang=[userinfo integerForKey:@"lang"];
    return selectedlang;
}

+ (int)getuserLevel {
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    int  userlevel=[userinfo integerForKey:@"Userlevel"];
    return userlevel;
}


+ (NSBundle*)getBundle {
    int selectedLang = [Fitness4MeUtils getApplicationLanguage];
    
    if (selectedLang==0) {
        selectedLang=1;
    }
    NSString* path;
    NSBundle* languageBundle;
    if (selectedLang==1) {
        
        path= [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        
        languageBundle = [NSBundle bundleWithPath:path];
        
        // self = [[Fitness4MeViewController alloc] initWithNibName:@"Fitness4MeViewController" bundle:languageBundle];
    }
    else
    {
        path= [[NSBundle mainBundle] pathForResource:@"de" ofType:@"lproj"];
        
        languageBundle = [NSBundle bundleWithPath:path];
        
        
        
    }
    return languageBundle;
}



@end
