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

+(void)setViewMovedUp:(BOOL)movedUp :(UIView*)view :(BOOL)stayup :(int)offset
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
    NSString *isMember=[userinfo stringForKey:@"isMember"];
    GADBannerView *bannerView_;
    if ([isMember isEqualToString:@"true"]) {
        
    }
    else
    {
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
            bannerView_.adUnitID = @"a15074fa73f350f";
            [bannerView_ setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
            bannerView_.rootViewController = viewController;
            [viewController.view addSubview:bannerView_];
            [bannerView_ loadRequest:[GADRequest request]];
        }
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
    //a15074fa73f350f
    bannerView_.adUnitID = @"a150efb4cbe1a0a";
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
        bannerView_.adUnitID = @"a150efb4cbe1a0a";
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


+(void) createDirectoryatPath:(NSString *)dataPath
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        //Create Folder
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
}


+(void) getImageAtPath:(NSString *)imageUrl toDestination:( NSString *)storeURL setDelegate:(UIViewController*)viewController
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    [request setDownloadDestinationPath:storeURL];
    [request setDelegate:viewController];
    [request startAsynchronous];
}

+(BOOL)isReachable
{
    BOOL isReachable;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        isReachable=YES;
        return isReachable;
    }
    else{
        isReachable=NO;
        return isReachable;
    }
    return isReachable;
}

+ (NSString *)path {
       
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
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
    }
    else
    {
        path= [[NSBundle mainBundle] pathForResource:@"de" ofType:@"lproj"];
        languageBundle = [NSBundle bundleWithPath:path];
    }
    return languageBundle;
}


+(NSString*)displayTimeWithSecond:(NSInteger)seconds
{
    NSInteger remindMinute = seconds / 60;
    NSInteger remindHours = remindMinute / 60;
    
    NSInteger remindMinutes = seconds - (remindHours * 3600);
    NSInteger remindMinuteNew = remindMinutes / 60;
    
    NSInteger remindSecond = seconds - (remindMinuteNew * 60) - (remindHours * 3600);
    
    NSString *duration = [NSString stringWithFormat:@"%02i:%02i:%02i",remindHours,remindMinuteNew,remindSecond];
    
    return duration;
    
   
}

@end
