//
//  Fitness4MeViewController.m
//  Fitness4Me
//
//  Created by Ciby K Jose on 05/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Fitness4MeViewController.h"
#import "Fitness4MeUtils.h"
#import "FitnessServerCommunication.h"
#import "ExcersiceListViewController.h"
#import "CustomInitialLaunchViewController.h"
#include <sys/xattr.h>
#include "FitnessServer.h"
@implementation Fitness4MeViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        
        
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated{
  
    [self .navigationController setNavigationBarHidden:YES animated:NO];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
        }
        if(result.height == 568)
        {
            buttonContainerView.frame=CGRectMake(20, 280, 280, 235);
            ladyImageView.frame=CGRectMake(20, 80, 275, 150);
        }
    }

    [super viewWillAppear:animated];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SyncView removeFromSuperview];
    SyncView.layer.cornerRadius =14;
    SyncView.layer.borderWidth = 2;
    SyncView.layer.borderColor = [UIColor whiteColor].CGColor;
    [fileDownloadProgressView setHidden:NO];
    fileDownloadProgressView.progress = (0 / 100);
    [self freeVideoDownload];
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    NSString *membershipPurchase =[userinfo objectForKey:@"yearly"];
   
    if ([membershipPurchase isEqualToString:@"Subscribe"]) {
      
           [self showAlertwithMsg:NSLocalizedStringWithDefaultValue(@"membershipExpired", nil,[Fitness4MeUtils getBundle], nil, nil)]; 
        
    }
    NSArray *VideoArray =[NSArray arrayWithObjects:@"completed_exercise_de.mp4",@"completed_exercise.mp4",@"next_exercise_de.mp4",@"next_exercise.mp4",@"otherside_exercise_de.mp4",@"otherside_exercise.mp4",@"recovery_15_de.mp4",@"recovery_15.mp4",@"recovery_30_de.mp4",@"recovery_30.mp4",@"stop_exercise_de.mp4",@"stop_exercise.mp4",nil];
    
    
    BOOL success;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    dataPath= [documentsDirectory stringByAppendingPathComponent:@"MyFolder"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        //Create Folder
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    NSURL *pathURL= [NSURL fileURLWithPath:dataPath];
    
    [self addSkipBackupAttributeToItemAtURL:pathURL];
    
    for (NSString *name in VideoArray) {
        NSString *datapath1=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:name];
        NSString *datapath2=[dataPath stringByAppendingPathComponent:name];
        NSFileManager *filemanager =[NSFileManager defaultManager];
        success =[filemanager  fileExistsAtPath:datapath1];
        if(success){
            if (![[NSFileManager defaultManager] fileExistsAtPath:datapath2]){
                [filemanager copyItemAtPath:datapath1 toPath:datapath2 error:nil];
            }
        }
    }
     

       
}



-(void)checkPurchasedItems
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}//You Call This Function

//Then this delegate Funtion Will be fired




- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    if (&NSURLIsExcludedFromBackupKey == nil) { // iOS <= 5.0.1
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    } else { // iOS >= 5.1
        
       // NSLog(@"%d",[URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil]);
        return [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
    }
}


-(void)freeVideoDownload{
    
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    NSString *showSyncView= [userinfo valueForKey:@"showSyncView"];
    
    if ([showSyncView isEqualToString:@"true"]) {
        [self.view addSubview:SyncView];
        [activityindicators startAnimating];
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        [userinfo setObject:@"false" forKey:@"showSyncView"];
        [NSThread detachNewThreadSelector:@selector(startDownload) toTarget:self withObject:nil];
    }
    
}

-(void)startDownload
{
    
    
    FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
    [fitness setDelegate:self];
    [fitness listEquipments:nil progressView:nil
               onCompletion:^(NSString *responseString) {
                   if (responseString>0) {
                       
                   }
               } onError:^(NSError *error) {
                   
               }];
    [fitness listfocus:nil progressView:nil
          onCompletion:^(NSString *responseString) {
              if (responseString>0) {
                  
              }
          } onError:^(NSError *error) {
              
          }];
    
    [fitness parseWorkoutVideos];
    [fitness getFreevideos];
    fileDownloadProgressView.progress = ((float)0 / (float) 100);
}


- (void)didfinishedWorkout:(int)countCompleted :(int)totalCount
{
    [SyncView addSubview:lblCompleted];
    NSString *s= [NSString stringWithFormat:@"%i / %i",countCompleted,totalCount];
    lblCompleted.text =s;
    if (countCompleted ==totalCount) {
        [UIView transitionWithView:SyncView duration:1
                           options:UIViewAnimationOptionTransitionCurlUp animations:^{
                               [SyncView setAlpha:0.0];
                               
                           }
                        completion:^(BOOL finished)
         {
             [SyncView removeFromSuperview];
             NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
             int UserID =[userinfo integerForKey:@"UserID"];
             FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
             [fitness parseCustomFitnessDetails:UserID onCompletion:^(NSString *responseString){
                 
             } onError:^(NSError *error) {
                 // [self getExcersices];
             }];
             
         }];
    }
    fileDownloadProgressView.progress = ((float)countCompleted / (float) totalCount);
   
}




- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self purchaseProUpgrade];
    }
    else {
        exit(0);
    }
}


-(void)showAlertwithMsg:(NSString*)message
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"fitness4.me" message:message
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
    
    
}




-(IBAction)navigateToWorkoutListView:(id)sender{
    
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setObject:@"QuickWorkouts" forKey:@"workoutType"];
    ListWorkoutsViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[ListWorkoutsViewController alloc]initWithNibName:@"ListWorkoutsViewController" bundle:nil];
    }else {
        viewController =[[ListWorkoutsViewController alloc]initWithNibName:@"ListWorkoutsViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}



-(IBAction)navigateToAboutView:(id)sender{
    
    AboutViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
    }else {
        viewController =[[AboutViewController alloc]initWithNibName:@"AboutViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    FitnessServerCommunication *fitness =[[FitnessServerCommunication alloc]init];
    [fitness getAllvideos];
}


-(IBAction)navigateToSettingsView:(id)sender{
    
    SettingsViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
    }else {
        viewController =[[SettingsViewController alloc]initWithNibName:@"SettingsViewController_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
}


-(IBAction)navigateToHintstView:(id)sender{
    
    
    HintsViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[HintsViewController alloc]initWithNibName:@"HintsViewController" bundle:nil];
    }else {
        viewController =[[HintsViewController alloc]initWithNibName:@"HintsViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController release];
    
    
}

-(IBAction)navigateToCustomWorkoutListView:(id)sender
{
    CustomWorkoutsViewController *viewController =nil;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[CustomWorkoutsViewController alloc]initWithNibName:@"CustomWorkoutsViewController" bundle:nil];
    }else {
        viewController =[[CustomWorkoutsViewController alloc]initWithNibName:@"CustomWorkoutsViewController_iPad" bundle:nil];
    }
    
    [viewController setWorkoutType:@"Custom"];
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setObject:@"Custom" forKey:@"workoutType"];
    [userinfo setObject:@"" forKey:@"SelectedWorkouts"];
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController release];
    
}


- (IBAction)onclickSelfMadeworkout:(id)sender {
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    NSString *isDontShow =[userinfo stringForKey:@"DontShow"];
    
    if ([isDontShow isEqualToString:@"true"]) {
        
        
        CustomWorkoutsViewController *viewController = nil;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            viewController =[[CustomWorkoutsViewController alloc]initWithNibName:@"CustomWorkoutsViewController" bundle:nil];
        }else {
            viewController =[[CustomWorkoutsViewController alloc]initWithNibName:@"CustomWorkoutsViewController_iPad" bundle:nil];
        }
        
        [userinfo setObject:@"SelfMade" forKey:@"workoutType"];
        [userinfo setObject:@"" forKey:@"SelectedWorkouts"];
        [viewController setWorkoutType:@"SelfMade"];
        GlobalArray=nil;
        GlobalArray=[[NSMutableArray alloc]init];
        [self.navigationController pushViewController:viewController animated:YES];
        
        [viewController release];
    }
    else{
        CustomInitialLaunchViewController *viewController=nil;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            viewController =[[CustomInitialLaunchViewController alloc]initWithNibName:@"CustomInitialLaunchViewController" bundle:nil];
        }else {
            viewController =[[CustomInitialLaunchViewController alloc]initWithNibName:@"CustomInitialLaunchViewControllerView_iPad" bundle:nil];
        }
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        [userinfo setObject:@"SelfMade" forKey:@"workoutType"];
        [userinfo setObject:@"" forKey:@"SelectedWorkouts"];
        //  [viewController setWorkoutType:@"SelfMade"];
        [self.navigationController pushViewController:viewController animated:YES];
        
        [viewController release];
    }
}

-(IBAction)cancelDownloas:(id)sender
{
    [UIView transitionWithView:SyncView duration:1
                       options:UIViewAnimationOptionTransitionCurlUp animations:^{
                           [SyncView setAlpha:0.0];
                           
                       }
                    completion:^(BOOL finished)
     {
         [SyncView removeFromSuperview];
      
         
     }];
    FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
    [fitness cancelDownload];
    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate {
    return NO;
}



#pragma   mark In App purchase methods
#pragma   loadStore
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}


//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}


//
// kick off the upgrade transaction
//
- (void)purchaseProUpgrade
{
    [self loadStore];
    [self canMakePurchases];
    
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    NSString *MembershipPlan =[userinfo stringForKey:@"MembershipPlan"];
    if ([MembershipPlan isEqualToString:@"1"]) {
        productIdentifier =@"fitness4.me.monthly";
    }
    else
    {
        productIdentifier =@"fitness4.me.yearly";
         NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        [userinfo setObject:@"100" forKey:@"updatedMembershipPlan"];
        
    }
   
    // SKProduct *validProduct=productIdentifier;
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:productIdentifier])
    {
        
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
      BOOL s=[self verifyReceipt:transaction];
    if (s==YES) {
        
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:productIdentifier])
    {
        // enable the pro features
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
     NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful){
        
        // [self sendMembership];
        // update the server with the purchased details
          NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        
        [userinfo setObject:@"true" forKey:@"showDownload"];
        [userinfo setObject:@"dontSubscribe" forKey:@"yearly"];
        NSString *MembershipPlan =[userinfo stringForKey:@"MembershipPlan"];
        [self sendMembershipPlanID:MembershipPlan membershipStatus:@"true" msg:NSLocalizedStringWithDefaultValue(@"premiumsucessfull", nil,[Fitness4MeUtils getBundle], nil, nil)];
        transaction =nil;
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
        
        
    }
    else{
        
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

-(void)sendMembershipPlanID:(NSString*)planID membershipStatus:(NSString*)membershipStatus msg:(NSString*)message{
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    FitnessServer *fitness =[FitnessServer sharedState];
    [fitness membershipPlanUser:planID activityIndicator:nil progressView:nil onCompletion:^(NSString *status) {
        if ([status length]>0) {
            if ([status isEqualToString:@"success"]) {
               
                [userinfo setObject:membershipStatus forKey:@"isMember"];
                [userinfo setObject:planID forKey:@"MembershipPlan"];
                
                [Fitness4MeUtils showAlert:message];
            }
        }
    }  onError:^(NSError *error) {
        
    }];
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}


- (BOOL)verifyReceipt:(SKPaymentTransaction *)transaction {
    
    __block BOOL isValid;
    NSString *jsonObjectString = [self encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length];
    FitnessServer *fitness= [FitnessServer sharedState];
    [fitness storeRecipt:jsonObjectString activitIndicator:nil progressView:nil onCompletion:^(NSString *response) {
        isValid =YES;
    } onError:^(NSError *error) {
        
    }];
    
    return isValid;
}

- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length {
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    
    NSLog(@"failedTransaction : %@", [transaction.error localizedDescription]);
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
        
    }
    else
    {
        
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        //[self sendMembershipPlanID:@"0" membershipStatus:@"false" msg:NSLocalizedStringWithDefaultValue(@"cancelPayment", nil,[Fitness4MeUtils getBundle], nil, nil)];
       //  NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
       // [userinfo setObject:@"dontSubscribe" forKey:@"yearly"];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
               // [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}


-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *validProduct = nil;
    
    int counts = [response.products count];
    
    
    if (counts>0) {
        
        validProduct = [response.products objectAtIndex:0];
        //SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"appUpdate1"];
        // [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        // [[SKPaymentQueue defaultQueue] addPayment:payment]; // <-- KA CHING!
        // NSLog (@"payment proccessed I think");
    }
    
}


@end
