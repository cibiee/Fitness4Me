//
//  ExcersicePostPlayViewController.m
//  Fitness4Me
//
//  Created by Ciby K Jose on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "ExcersicePostPlayViewController.h"
#import "ListWorkoutsViewController.h"
#import "ShareFitness4MeViewController.h"
#import "MemberPromoViewController.h"

@implementation ExcersicePostPlayViewController

@synthesize Excersice,workout,userID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
     self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.view.transform = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeRotation(M_PI_2));
    
    
    [self initializeView];
    
    [upgradeView removeFromSuperview];
    [signUpView removeFromSuperview];
    
}



-(void)initializeView
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyFolder"];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    {
        //Create Folder
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
        
    }
    
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
    
    NSString  *storeURL= [dataPath stringByAppendingPathComponent :[self.workout ImageName]];
    
    
    
    // Check If File Does Exists if not download the video
    if (![[NSFileManager defaultManager] fileExistsAtPath:storeURL])
    {
        
        NSURL * imageURL = [NSURL URLWithString:[self. workout ImageUrl]];
        
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        
        excersiceImageHolder.image = [UIImage imageWithData:imageData]; 
        
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[workout ImageUrl]]];
        
        [request setDownloadDestinationPath:storeURL];
        
        [request setDelegate:self];
        
        [request startAsynchronous];
        
    }
    
    
    else {
        
        UIImage *im =[[UIImage alloc]initWithContentsOfFile:storeURL];
        
        excersiceImageHolder.image=im;
        
             }
        
    }
    
    else {
        
         NSString  *storeURL= [dataPath stringByAppendingPathComponent :[self.workout ImageName]];
        // Check If File Does Exists if not download the video
        if ([[NSFileManager defaultManager] fileExistsAtPath:storeURL])
        {
            UIImage *im =[[UIImage alloc]initWithContentsOfFile:storeURL];
            
            excersiceImageHolder.image=im;
        }
        
        else
        {
            UIImage *im =[UIImage imageNamed:@"dummyimg.png"];
            excersiceImageHolder.image =im;

        }
    }
	
    excersiceImageHolder .image =nil;
    excersiceImageHolder.hidden=YES;
    
    
    [self showAdMobs];
    
}


-(void)showAdMobs{
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    
    NSString *hasMadeFullPurchase= [userinfo valueForKey:@"isMember"];
    
    
    if ([hasMadeFullPurchase isEqualToString:@"true"]) {
        
    }
    
    else {
        
        [self performSelector:@selector(showUpgradeView) withObject:nil afterDelay:2];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            
            bannerView_ = [[GADBannerView alloc]
                           initWithFrame:CGRectMake(0,self.view.frame.size.width-40,
                                                    self.view.frame.size.height-10,
                                                     self.view.frame.size.width)];
            
        }
        else {
            bannerView_ = [[GADBannerView alloc]
                           initWithFrame:CGRectMake(0,self.view.frame.size.width-70,
                                                    self.view.frame.size.height-10,
                                                    90)];
            
        }
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        bannerView_.adUnitID = @"a1506940e575b91";
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView_.rootViewController = self;
        [self.view addSubview:bannerView_];
        
        // Initiate a generic request to load it with an ad.
        [bannerView_ loadRequest:[GADRequest request]];
        
    }
}


#pragma mark -navigateToListView

 -(void)showUpgradeView
{
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setObject:@"QuickWorkouts" forKey:@"workoutType"];
    MemberPromoViewController *viewController;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController = [[MemberPromoViewController alloc]initWithNibName:@"MemberPromoViewController" bundle:nil];
    }
    else {
        viewController = [[MemberPromoViewController alloc]initWithNibName:@"MemberPromoViewController" bundle:nil];
    }
    
    [viewController setNavigateTo:@"NotList"];
    viewController.workout =self.workout;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)navigateToListView:(id)sender{
    
    ListWorkoutsViewController *viewController;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        viewController = [[ListWorkoutsViewController alloc]initWithNibName:@"ListWorkoutsViewController" bundle:nil];
        
    }
    else {
        viewController = [[ListWorkoutsViewController alloc]initWithNibName:@"ListWorkoutsViewController_iPad" bundle:nil];
    }
    

    [self.navigationController pushViewController:viewController animated:YES];
}



   
-(IBAction)navigateToShareAppView:(id)sender{
    
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setObject:@"QuickWorkouts" forKey:@"workoutType"];
    ShareFitness4MeViewController *viewController;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        viewController = [[ShareFitness4MeViewController alloc]initWithNibName:@"ShareFitness4MeViewController" bundle:nil];
        
    }
    else {
        viewController = [[ShareFitness4MeViewController alloc]initWithNibName:@"ShareFitness4MeViewController_iPad" bundle:nil];
    }
    
    viewController.imageUrl =[self.workout ImageUrl];
    viewController.imageName =[self.workout ImageName];
    viewController.workoutType=@"QuickWorkouts";
    [self.navigationController pushViewController:viewController animated:YES];
    

    
}

-(IBAction)removeUpgardeView:(id)sender
{
    [upgradeView removeFromSuperview];
}

-(IBAction)startActivity
{

    [upgradeView removeFromSuperview];
    
    [activityIndicator startAnimating];
    [activityIndicator setHidden:NO];
    
    
        [self.view addSubview:signUpView];
   
    
    [NSThread detachNewThreadSelector:@selector(purchaseProUpgrade) toTarget:self withObject:nil];
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
    
        productIdentifier = @"com.fitness4me.Fitness4Me.PurchaseAll";
   
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
        // update the server with the purchased details
        [self UpdateServer:@"true"];
        transaction =nil;
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
        [signUpView removeFromSuperview];
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        [userinfo setObject:@"false" forKey:@"fullVideoDownloadlater"];
    }
    else{
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
        [signUpView removeFromSuperview];
    }
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

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    
   
   // NSLog(@"failedTransaction : %@", [transaction.error localizedDescription]);
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
        [signUpView removeFromSuperview];

    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        [signUpView removeFromSuperview];

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
                [self failedTransaction:transaction];
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
    
}


//
//  updated server with the video informations
//
-(void)UpdateServer:(NSString *)purchaseStatus;
{
    
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        
        
        NSString *status ;
        NSString *requestString;
        urlPath =[NSString GetURlPath];
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        self.UserID =[userinfo stringForKey:@"UserID"];
        
       requestString=  [NSString stringWithFormat:@"%@unlockiphone=yes&userid=%@&workoutid=%@&purchase_status=%@&type=all",urlPath,userID,@"''",purchaseStatus];
               
        NSURL *url =[NSURL URLWithString:requestString];
        ASIFormDataRequest   *request = [ASIFormDataRequest   requestWithURL:url];
        [request startSynchronous];
        NSError *error = [request error];
        
        if (!error){
            NSString *response = [request responseString];
            NSMutableArray *object = [response JSONValue];
            NSMutableArray *itemsarray =[object valueForKey:@"items"];
            for (int i=0; i<[itemsarray count]; i++) {
                status = [[itemsarray objectAtIndex:i] valueForKey:@"status"];
            }
        }
        else{
            
            [Fitness4MeUtils showAlert:NSLocalizedString(@"NoInternetMessage", nil)];
        }
        
        if ([status isEqualToString:@"success"]) {
           
                NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
                [userinfo setObject:@"true" forKey:@"hasMadeFullPurchase"];
                [self updateWorkout:@"false"];
            }
    }
    
    else
    {
        [Fitness4MeUtils showAlert:NSLocalizedString(@"NoInternetMessage", nil)];

    }
}

-(void)updateWorkout:(NSString *)purchaseStatus
{
     workoutDB =[[WorkoutDB alloc]init];
    [workoutDB setUpDatabase];
    [workoutDB createDatabase];
    
    [workoutDB updateWorkout:@"All":purchaseStatus];
    
    
}




- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(BOOL)shouldAutorotate {
    return NO;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
