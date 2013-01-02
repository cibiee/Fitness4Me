//
//  Fitness4MeAppDelegate.m
//  Fitness4Me
//
//  Created by Ciby K Jose on 05/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Fitness4MeAppDelegate.h"


@implementation Fitness4MeAppDelegate
@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize fitness4MeViewController =_fitness4MeViewController;
@synthesize navigationController=_navigationController;
int userID;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self getUserDetails];
    
    userID = [user UserID];
    if (userID>0) {
        application.applicationIconBadgeNumber = 0;
        [self saveUserDefaults];
        [self navigateToHome];
        FitnessServerCommunication *fitnessserverCommunication =[[FitnessServerCommunication alloc]init];
        [fitnessserverCommunication parseFitnessDetails:userID];
    }else {
        [self navigateToInitalLaunchScreen];
        [self saveUserPreferences];
    }
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
#if !TARGET_IPHONE_SIMULATO
    NSString *devToken = [NSString stringWithFormat:@"%@" ,deviceToken];
    NSString *token= [[[devToken stringByReplacingOccurrencesOfString:@"<"withString:@""]
                       stringByReplacingOccurrencesOfString:@">" withString:@""]
                      stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setObject:token forKey:@"deviceToken"];
    
#endif
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    
#if !TARGET_IPHONE_SIMULATOR
	NSLog(@"Failed to get token, error: %@", error);
#endif
}


/**
 * Remote Notification Received while application was open.
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

#if !TARGET_IPHONE_SIMULATOR
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    int UserID =[userinfo integerForKey:@"UserID"];
    if(UserID >0){
        NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
        if( application.applicationIconBadgeNumber<4){
            [userinfo setObject:[apsInfo objectForKey:@"badge"]  forKey:@"Userlevel"];
        }
        if (application.applicationIconBadgeNumber==1) {
            [self updateUserDetails:@"1"];
            [self navigateToHomeScreen];
        }else if (application.applicationIconBadgeNumber==2) {
            [self updateUserDetails:@"2"];
            [self navigateToHomeScreen];
            
        }else if (application.applicationIconBadgeNumber==3) {
            [self updateUserDetails:@"3"];
            [self navigateToHomeScreen];
        }else if (application.applicationIconBadgeNumber==4) {
            NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
            int unlockcount =[userinfo integerForKey:@"freePurchaseCount"];
            if (unlockcount<2) {
                [userinfo setInteger:unlockcount+1 forKey:@"freePurchaseCount"];
            }
        }else if (application.applicationIconBadgeNumber==5) {
            NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
            [userinfo setObject:@"true" forKey:@"hasMadeFullPurchase"];
            [userinfo setObject:@"true" forKey:@"hasUpdations"];
        }else {
            [userinfo setObject:@"true" forKey:@"hasUpdations"];
        }
        [self updateData];
        application.applicationIconBadgeNumber = 0;
    }
#endif
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    Fitness4MeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UIViewController *topView = appDelegate.navigationController.topViewController;
    if ([topView isKindOfClass:[ListWorkoutsViewController class]]) {
        exit(0);
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self updateData];
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}



- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark-
#pragma mark Hidden Instance Methods

- (void)saveUserPreferences
{
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setInteger:0  forKey:@"UserID"];
    [userinfo setObject:@"true" forKey:@"showDownload"];
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    NSString *fullVideoDownloadlater=[userinfo stringForKey:@"fullVideoDownloadlater"];
    NSString *showSyncView=[userinfo stringForKey:@"showSyncView"];
    
    if ([fullVideoDownloadlater isEqualToString:@"true"]) {
        
    }
    else{
        [userinfo setObject:@"false" forKey:@"fullVideoDownloadlater"];
    }
    
    if ([showSyncView isEqualToString:@"false"]) {
        
    }
    else{
        [userinfo setObject:@"true" forKey:@"showSyncView"];
    }
}


-(void)navigateToHomeScreen{
    
    Fitness4MeViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        viewController =[[Fitness4MeViewController alloc]initWithNibName:@"Fitness4MeViewController" bundle:nil];
    else
        viewController =[[Fitness4MeViewController alloc]initWithNibName:@"Fitness4MeViewController_iPad" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
}

- (void)navigateToHome
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.fitness4MeViewController = [[Fitness4MeViewController alloc] initWithNibName:@"Fitness4MeViewController_iPad" bundle:nil];
        self.navigationController =[[UINavigationController alloc]initWithRootViewController:_fitness4MeViewController];
    }
    
    else{
        self.fitness4MeViewController = [[Fitness4MeViewController alloc] initWithNibName:@"Fitness4MeViewController" bundle:nil];
        self.navigationController =[[UINavigationController alloc]initWithRootViewController:_fitness4MeViewController];
    }
}

- (void)navigateToInitalLaunchScreen
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        self.viewController = [[InitialAppLaunchViewController alloc] initWithNibName:@"InitialAppLaunchViewController" bundle:nil];
        self.navigationController =[[UINavigationController alloc]initWithRootViewController:_viewController];
    }
    else {
        self.viewController = [[InitialAppLaunchViewController alloc] initWithNibName:@"InitialAppLaunchViewController_iPad" bundle:nil];
        self.navigationController =[[UINavigationController alloc]initWithRootViewController:_viewController];
    }
}

- (void)saveUserDefaults
{
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setObject:[user Name] forKey:@"Name"];
    [userinfo setObject:[user Username] forKey:@"Username"];
    [userinfo setInteger:userID  forKey:@"UserID"];
    [userinfo setObject:user.Userlevel  forKey:@"Userlevel"];
}

-(void)dealloc
{
    [super dealloc];
    
    [_navigationController release];
    [_fitness4MeViewController release];
    [_viewController release];
    [user release];
}



-(void)getUserDetails
{
    
    UserDB *userDB =[[UserDB alloc]init];
    [userDB setUpDatabase];
    [userDB createDatabase];
    user =[[[User alloc]init]autorelease];
    user= userDB.getUser;
    [userDB release];
}


-(void)updateUserDetails:(NSString*)userlevel
{
    UserDB *userDB =[[UserDB alloc]init];
    [userDB setUpDatabase];
    [userDB createDatabase];
    [userDB updateUser:userlevel];
    [userDB release];
}


-(void)updateData
{
    [self getUserDetails];
    
    userID = [user UserID];
    
    if (userID>0){
        [self updateFavouritesToServer];
        FitnessServerCommunication *fitnessserverCommunication =[[FitnessServerCommunication alloc]init];
        [fitnessserverCommunication parseFitnessDetails:userID];
        [fitnessserverCommunication listEquipments:nil progressView:nil
                                      onCompletion:^(NSString *responseString) {
                                          if (responseString>0) {
                                              
                                          }
                                      } onError:^(NSError *error) {
                                          
                                      }];
        
        [fitnessserverCommunication listfocus:nil progressView:nil
                                 onCompletion:^(NSString *responseString) {
                                     if (responseString>0) {
                                         
                                     }
                                 } onError:^(NSError *error) {
                                     
                                 }];
        
        
        
        [fitnessserverCommunication parseCustomFitnessDetails:userID onCompletion:^(NSString *responseString){
            
        } onError:^(NSError *error) {
            // [self getExcersices];
        }];
        
        
        [fitnessserverCommunication parseSelfMadeFitnessDetails:userID onCompletion:^(NSString *responseString){
            
        } onError:^(NSError *error) {
            // [self getExcersices];
        }];
        
         [self updateStatisticsToServer];
         [self updateCustomStatisticsToServer];
        Fitness4MeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        UIViewController *topView = appDelegate.navigationController.topViewController;
        if ([topView isKindOfClass:[ListWorkoutsViewController class]]||[topView isKindOfClass:[CustomWorkoutsViewController class]]||[topView isKindOfClass:[CustomWorkoutEditViewController class]]) {
            [self navigateToHomeScreen];
        }
    }
    
}


-(void)updateStatisticsToServer
{
   NSMutableArray *offlineworkouts =[self getStatistics];
    NSString *workouts = [[NSString alloc]init];
    NSString *tdurations  = [[NSString alloc]init];
    if ([offlineworkouts count]>0) {
        
        for (Statistics *obj in offlineworkouts) {
            Statistics* item = obj;
          
            if ([workouts length]==0) {
                workouts =[workouts stringByAppendingString:item.WorkoutID];
                tdurations =[tdurations stringByAppendingString:[NSString stringWithFormat:@"%f",item.Duration]];
            }
            else{
                workouts=[workouts stringByAppendingString:@","];
                workouts =[workouts stringByAppendingString:item.WorkoutID];
                                tdurations=[tdurations stringByAppendingString:@","];
                tdurations =[tdurations stringByAppendingString:[NSString stringWithFormat:@"%f",item.Duration]];
            }
            
            
        };
      
    }
    
    if ([workouts length]>0) {
        BOOL isReachable = [Fitness4MeUtils isReachable];
        if (isReachable) {
            NSString *UrlPath= [NSString GetURlPath];
            NSString *requestString = [NSString stringWithFormat:@"%@stats=yes&userid=%i&workoutid=%@&duration=%@",UrlPath,userID,workouts,tdurations];
            NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            __block ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
            [requests setCompletionBlock:^{
                // Use when fetching text data
                NSString *responseString =[requests responseString];
                if ([responseString length]>0) {
                [self deleteStatistics];
                }
            }];
            [requests setFailedBlock:^{
                
            }];
            [requests startAsynchronous];
        }
    }
}

-(NSMutableArray*)getStatistics
{
    NSMutableArray * offlineWorkouts= [[NSMutableArray alloc]init];
    StatisticsDB  *statisticsDB =[[StatisticsDB alloc]init];
    [statisticsDB setUpDatabase];
    [statisticsDB createDatabase];
    offlineWorkouts=  [statisticsDB  getWorkouts];
    return offlineWorkouts;
}

-(void)deleteStatistics
{
    
    StatisticsDB  *statisticsDB =[[StatisticsDB alloc]init];
    [statisticsDB setUpDatabase];
    [statisticsDB createDatabase];
    [statisticsDB  deleteStatistics];
    
}


-(void)updateCustomStatisticsToServer
{
    NSMutableArray *offlineworkouts =[self getCustomStatistics];
    NSString *workouts = [[NSString alloc]init];
    NSString *tdurations  = [[NSString alloc]init];
    if ([offlineworkouts count]>0) {
        
        for (Statistics *obj in offlineworkouts) {
            Statistics* item = obj;
            
            if ([workouts length]==0) {
                workouts =[workouts stringByAppendingString:item.WorkoutID];
                tdurations =[tdurations stringByAppendingString:[NSString stringWithFormat:@"%f",item.Duration]];
            }
            else{
                workouts=[workouts stringByAppendingString:@","];
                workouts =[workouts stringByAppendingString:item.WorkoutID];
                tdurations=[tdurations stringByAppendingString:@","];
                tdurations =[tdurations stringByAppendingString:[NSString stringWithFormat:@"%f",item.Duration]];
            }
            
            
        };
        
    }
    
    if ([workouts length]>0) {
        BOOL isReachable = [Fitness4MeUtils isReachable];
        if (isReachable) {
            NSString *UrlPath= [NSString GetURlPath];
            NSString *requestString = [NSString stringWithFormat:@"%@customstats=yes&userid=%i&workoutid=%@&duration=%@",UrlPath,userID,workouts,tdurations];
            NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            __block ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
            [requests setCompletionBlock:^{
                // Use when fetching text data
                NSString *responseString =[requests responseString];
                if ([responseString length]>0) {
                    [self deleteCustomStatistics];
                }
            }];
            [requests setFailedBlock:^{
                
            }];
            [requests startAsynchronous];
        }
    }
}

-(NSMutableArray*)getCustomStatistics
{
    NSMutableArray * offlineWorkouts= [[NSMutableArray alloc]init];
    StatisticsDB  *statisticsDB =[[StatisticsDB alloc]init];
    [statisticsDB setUpDatabase];
    [statisticsDB createDatabase];
    offlineWorkouts=  [statisticsDB  getWorkouts];
    return offlineWorkouts;
}

-(void)deleteCustomStatistics
{
    
    StatisticsDB  *statisticsDB =[[StatisticsDB alloc]init];
    [statisticsDB setUpDatabase];
    [statisticsDB createDatabase];
    [statisticsDB  deleteStatistics];
    
}


-(void)updateFavouritesToServer
{
    NSMutableArray *offlineworkouts =[self getFavourites];
    NSString *workouts = [[NSString alloc]init];
    NSString *tdurations  = [[NSString alloc]init];
    if ([offlineworkouts count]>0) {
        
        for (Favourite *obj in offlineworkouts) {
            Favourite* item = obj;
            
            if ([workouts length]==0) {
                workouts =[workouts stringByAppendingString:item.workoutID];
                tdurations =[tdurations stringByAppendingString:[NSString stringWithFormat:@"%i",item.status]];
            }
            else{
                workouts=[workouts stringByAppendingString:@","];
                workouts =[workouts stringByAppendingString:item.workoutID];
                tdurations=[tdurations stringByAppendingString:@","];
                tdurations =[tdurations stringByAppendingString:[NSString stringWithFormat:@"%i",item.status]];
            }
            
            
        };
        
    }
    
    if ([workouts length]>0) {
        BOOL isReachable = [Fitness4MeUtils isReachable];
        if (isReachable) {
            NSString *UrlPath= [NSString GetURlPath];
            NSString *requestString = [NSString stringWithFormat:@"%@customfav=yes&user_id=%i&custom_workout_id=%@&fav_status=%@",UrlPath,userID,workouts,tdurations];
            NSURL *url =[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            __block ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
            [requests setCompletionBlock:^{
                // Use when fetching text data
                NSString *responseString =[requests responseString];
                if ([responseString length]>0) {
                    [self deletefavourites];
                }
            }];
            [requests setFailedBlock:^{
                
            }];
            [requests startAsynchronous];
        }
    }
}

-(NSMutableArray*)getFavourites
{
    NSMutableArray * offlineWorkouts= [[NSMutableArray alloc]init];
    CustomFavourites  *customFavourites =[[CustomFavourites alloc]init];
    [customFavourites setUpDatabase];
    [customFavourites createDatabase];
    offlineWorkouts=  [customFavourites  getWorkouts];
    return offlineWorkouts;
}

-(void)deletefavourites
{
    
    CustomFavourites  *customFavourites =[[CustomFavourites alloc]init];
    [customFavourites setUpDatabase];
    [customFavourites createDatabase];
    [customFavourites  deletefavourite];
    
}











@end
