//
//  ExcersiceIntermediateViewController.m
//  Fitness4Me
//
//  Created by Ciby K Jose on 06/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExcersiceIntermediateViewController.h"
#import "ExcersicePlayViewController.h"
#import "NSString+Config.h"
#import "Fitness4MeUtils.h"

@implementation ExcersiceIntermediateViewController

@synthesize workout,userlevel,purchaseAll,userID,productIdentifier,myQueue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark - View Overloaded methods

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [slownetView removeFromSuperview];
     slownetView.layer .cornerRadius =14;
    
    [descriptionTextview.layer setBorderColor:[[UIColor greenColor]CGColor]];
    [descriptionTextview.layer setBorderWidth:2];
    
    stop =0;
    stopz=0;
    [self InitializeView];
    urlPath =[NSString GetURlPath];
    self.view.transform = CGAffineTransformConcat(self.view.transform,
                                                  CGAffineTransformMakeRotation(M_PI_2));
    [Fitness4MeUtils showAdMob:self];
        
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    self.UserID =[userinfo stringForKey:@"UserID"];
    self.userlevel =[userinfo stringForKey:@"Userlevel"];
    [userinfo setObject:@"false" forKey:@"shouldExit"];
    
    [signUpView removeFromSuperview];
    
    [self UnlockVideos];
    [letsgoButton setEnabled:NO];
    [letsgoButton setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    stopz=0;
    [super viewDidAppear:NO];
    [letsgoButton setEnabled:NO];
    [letsgoButton setHidden:YES];
    backButton.enabled =NO;
    [self getUserDetails];
}


- (void)viewDidUnload
{
 [super viewDidUnload];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}




#pragma mark - hidden instance methods
- (void)showWorkoutImage
{
 
    dataPath =[Fitness4MeUtils path];
    
    if ([Fitness4MeUtils isReachable]) {
        [Fitness4MeUtils createDirectoryatPath:dataPath];
         storeURL= [dataPath stringByAppendingPathComponent :[self.workout ImageName]];
        // Check If File Does Exists if not download the video
        if (![[NSFileManager defaultManager] fileExistsAtPath:storeURL]){
            
            NSURL * imageURL = [NSURL URLWithString:[self. workout ImageUrl]];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            excersiceImageHolder.image = [UIImage imageWithData:imageData];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[self.workout ImageUrl]]];
            [request setDownloadDestinationPath:storeURL];
            [request setDelegate:self];
            [request startAsynchronous];
        }else {
            UIImage *im =[[UIImage alloc]initWithContentsOfFile:storeURL];
            excersiceImageHolder.image=im;
        }
    }else{
        storeURL= [dataPath stringByAppendingPathComponent :[self.workout ImageName]];
        // Check If File Does Exists if not download the video
        if ([[NSFileManager defaultManager] fileExistsAtPath:storeURL]){
            UIImage *im =[[UIImage alloc]initWithContentsOfFile:storeURL];
            excersiceImageHolder.image=im;
            [im release];
        }else{
            UIImage *im =[UIImage imageNamed:@"dummyimg.png"];
            excersiceImageHolder.image =im;
        }
    }
}



- (void)downloadImageDidfinish:(ASINetworkQueue *)queue
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:storeURL]){
        UIImage *im =[[UIImage alloc]initWithContentsOfFile:storeURL];
        excersiceImageHolder.image=im;
        [im release];
    }else{
        UIImage *im =[UIImage imageNamed:@"dummyimg.png"];
        excersiceImageHolder.image =im;
    }
}

- (void)requestDidFails:(ASINetworkQueue *)queue
{
    
    
}



-(void)InitializeView
{
    [self showWorkoutImage];
	
    descriptionTextview.text =[self.workout DescriptionBig];
    [descriptionTextview sizeToFit];
    titleLabel.text=[self.workout Name];
    if ([[self.workout Props] length]>0) {
        propsLabel.text=[self.workout Props];
        [propsLabel sizeToFit];
    }else{
        propLabel.hidden =YES;
    }
}

-(void)startActivity
{
    [signUpView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [signUpView addSubview:pleaseWait];
    [activityIndicator setHidden:NO];
    [self.view addSubview:signUpView];

}


- (void)didfinishedDownloadImage
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:storeURL]){
        UIImage *im =[[UIImage alloc]initWithContentsOfFile:storeURL];
        excersiceImageHolder.image=im;
        [im release];
    }else{
        UIImage *im =[UIImage imageNamed:@"dummyimg.png"];
        excersiceImageHolder.image =im;
    }
}
//
//  updated server with the video informations
//
-(void)UpdateServer:(NSString *)purchaseStatus;
{
    FitnessServerCommunication *fitness= [FitnessServerCommunication sharedState];
    [fitness UpdateServerWithPurchaseStatus:purchaseStatus hasMadefullpurchase:[self purchaseAll] workoutID:[self.workout WorkoutID] userID:userID activityIndicator:nil progressView:signUpView
                               onCompletion:^(NSString *isExist) {
                                   if ([isExist isEqualToString:@"success"]) {
                                       if ([[self purchaseAll] isEqualToString:@"true"]){
                                           NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
                                           [userinfo setObject:@"true" forKey:@"hasMadeFullPurchase"];
                                       }
                                       
                                   }
                                   
                                   [self performSelector:@selector(NavigateToWorkoutList) withObject:nil afterDelay:5];
                                   
                               }
                                    onError:^(NSError *error) {
                                        
                                    }];
}


-(void)updateWorkout:(NSString *)purchaseStatus
{
    workoutDB =[[WorkoutDB alloc]init];
    [workoutDB setUpDatabase];
    [workoutDB createDatabase];
    if ([[self purchaseAll] isEqualToString:@"true"]) {
        [workoutDB updateWorkout:@"All":purchaseStatus];
        [workoutDB release];
    }
    else {
        [workoutDB updateWorkout:[self.workout WorkoutID]:purchaseStatus];
        [workoutDB release];
    }
}



- (void)getWorkoutVideoData:(NSMutableArray *)object {
    
    NSMutableArray *itemsarray =[object valueForKey:@"items"];
    NSString *workoutID =[self.workout WorkoutID];
    int workouts =[workoutID intValue];
    [itemsarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* item = obj;
        [excersices addObject: [[Excersice alloc]initWithData:workouts:[item objectForKey :@"poster_video"]:[item objectForKey:@"poster_name"]:[item objectForKey:@"poster_rep"]:[item objectForKey:@"main_video"]:[item objectForKey:@"video_name"]:[item objectForKey:@"main_rep"]:[item objectForKey:@"stop_video"]:[ item objectForKey:@"stop_name"]:[item objectForKey:@"stop_rep"]:[item objectForKey:@"otherside_poster"]:[item objectForKey:@"otherside_postername"]:[item objectForKey:@"otherside_posterrep"]:[item objectForKey:@"otherside_video"]:[item objectForKey:@"otherside_name"]:[item objectForKey:@"otherside_rep"]:[ item objectForKey:@"recovery_video"]:[ item objectForKey:@"recovery_video_name"]:[item objectForKey :@"next_video"]:[item objectForKey:@"next_name"]:[item objectForKey :@"next_rep"]:[item objectForKey:@"completed_video"]:[item objectForKey :@"completed_name"]:[ item valueForKey:@"completed_rep"]]];
    }];
    
    
}

-(void)parseExcersiceDetails{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        
         int  selectedlang=[Fitness4MeUtils getApplicationLanguage] ;
            FitnessServerCommunication *fitness= [FitnessServerCommunication sharedState];
            [fitness parserExcersiceDetailsForWorkoutID:[self.workout WorkoutID] userLevel:userlevel language:selectedlang activityIndicator:nil progressView:signUpView onCompletion:^(NSString *responseString) {
                NSMutableArray *object = [responseString JSONValue];
                excersices = [[NSMutableArray alloc]init];
                [self getWorkoutVideoData:object];
                [self deleteExcersices];
                [self insertExcersices];
                [self getExcersices];
            }onError:^(NSError *error) {
                [self getExcersices];
          }];
    }
    else{
        if([signUpView superview]!=nil){
            [signUpView removeFromSuperview];
        }
        [signUpView release];
        [self getExcersices];
    }
    
    [pool drain];
}


//method to  initialize database for  database operations
-(void)initilaizeDatabase
{
    excersiceDB =[[ExcersiceDB alloc]init];
    [excersiceDB setUpDatabase];
    [excersiceDB createDatabase];
}

-(void)navigateToHome
{
    
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"fitness4.me" message:NSLocalizedString(@"resumeDownload", nil)                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertview show];
    [alertview release];
    
}

-(void)ShowVideounAvaialableMessage
{
    
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"fitness4.me" message:NSLocalizedString(@"VideoUnavailable", nil)
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertview show];
    [alertview release];
    
}


- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
        [self NavigateToWorkoutList];
    }
    
}



//method to  delete the records from  so that it delete all the existing records
//related to a workout and insert new data
-(void)deleteExcersices
{
    [self initilaizeDatabase];
    NSString *workoutID =[self.workout WorkoutID];
    int workouts =[workoutID intValue];
    [excersiceDB deleteExcersice:workouts];
    [excersiceDB release];
}

//
// called for getting User Details
//
-(void)getUserDetails
{
    UserDB *userDB =[[UserDB alloc]init];
    [userDB setUpDatabase];
    [userDB createDatabase];
    user =[[[User alloc]init]autorelease];
    user= userDB.getUser;
    [userDB release];
}


//method to insert the records related to a workout
-(void)insertExcersices
{
    [self initilaizeDatabase];
    [excersiceDB insertExcersices:excersices];
    [excersices release];
}


//method to get Excersices related to a workout
-(void)getExcersices
{
    excersicesList = [[NSMutableArray alloc]init];
    [self initilaizeDatabase];
    NSString *workoutID =[self.workout WorkoutID];
    int workouts =[workoutID intValue];
    [excersiceDB getExcersices:workouts];
    
    if([excersiceDB.Excersices count]>0){
        excersicesList =excersiceDB.Excersices;
    }
    [NSThread detachNewThreadSelector:@selector(startDownload) toTarget:self withObject:nil];
}

// Get the number of Unlocked excersices
-(void)getUnlockedExcersices
{
    
    workoutDB =[[WorkoutDB alloc]init];
    [workoutDB setUpDatabase];
    [workoutDB createDatabase];
    [workoutDB selectWorkout];
    count = [workoutDB temp];
    [workoutDB release];
    
}


//method to start Download videos related to a workout
-(void)startDownload
{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *videoPath=[NSString getVideoPath];

    dataPath = [Fitness4MeUtils path];

    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        //Create Folder
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    for (int i=0; i<[excersicesList count]; i++) {
        NSString *PosterUrl= [videoPath stringByAppendingString:[[excersicesList objectAtIndex: i] valueForKey: @"PosterUrl"]];
        NSString *PosterName= [[excersicesList objectAtIndex: i] valueForKey: @"PosterName"];
        [self downloadVideos:PosterUrl:PosterName];
        
        NSString *videoUrl = [videoPath stringByAppendingString:[[excersicesList objectAtIndex: i] valueForKey: @"VideoUrl"]];
        NSString *Name =  [[excersicesList objectAtIndex: i] valueForKey: @"Name"];
        [self downloadVideos:videoUrl:Name];
        
        NSString *stopVideo= [videoPath stringByAppendingString:[[excersicesList objectAtIndex: i]  valueForKey: @"StopVideo"]];
        NSString *stopName= [[excersicesList objectAtIndex: i]  valueForKey: @"StopName"];
        if ([stopName length]>0) {
            [self downloadVideos:stopVideo:stopName];
        }
        
        NSString *otherSidePoster= [videoPath stringByAppendingString:[[excersicesList objectAtIndex: i] valueForKey: @"OtherSidePoster"]];
        NSString *othersidePosterName= [[excersicesList objectAtIndex: i] valueForKey: @"OthersidePosterName"];
        if ([othersidePosterName length]>0) {
            [self downloadVideos:otherSidePoster:othersidePosterName];
        }
        
        NSString *othersideVideo= [videoPath stringByAppendingString:[[excersicesList objectAtIndex: i] valueForKey: @"OthersideVideo"]];
        NSString *othersideName= [[excersicesList objectAtIndex: i] valueForKey: @"OthersideName"];
        if ([othersideName length]>0) {
            [self downloadVideos:othersideVideo:othersideName];
        }
        
        NSString *recoveryVideoUrl= [videoPath stringByAppendingString:[[excersicesList objectAtIndex: i] valueForKey: @"RecoveryVideoUrl"]];
        NSString *recoveryVideoName= [[excersicesList objectAtIndex: i] valueForKey: @"RecoveryVideoName"];
        if ([recoveryVideoName length]>0) {
            [self downloadVideos:recoveryVideoUrl:recoveryVideoName];
        }
        
        NSString *nextVideo= [videoPath stringByAppendingString:[[excersicesList objectAtIndex: i] valueForKey: @"NextVideo"]];
        NSString *nextName= [[excersicesList objectAtIndex: i] valueForKey: @"NextName"];
        if ([nextName length]>0) {
            [self downloadVideos:nextVideo:nextName];
        }
        
        NSString *completedVideo= [videoPath stringByAppendingString:[[excersicesList objectAtIndex: i] valueForKey: @"CompletedVideo"]];
        NSString *completedName= [[excersicesList objectAtIndex: i] valueForKey: @"CompletedName"];
        if ([completedName length]>0) {
            [self downloadVideos:completedVideo:completedName];
        }
        
    }
    stop=stop+1;
    if ([excersicesList count]>0){
        [letsgoButton setEnabled:YES];
        [letsgoButton setHidden:NO];
        [backButton  setEnabled:YES];
    }
    else {
        [self performSelectorOnMainThread:@selector(ShowVideounAvaialableMessage)
                               withObject:nil
                            waitUntilDone:YES];

    }
    
    if (stop==[excersicesList count]) {
        [signUpView removeFromSuperview];
        
    }
    
    [pool drain];
}


//method to Download videos related to a workout
-(void)downloadVideos:(NSString *)url:(NSString*)name{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath1 = [documentsDirectory stringByAppendingPathComponent:@"MyFolder"];
    NSString  *filepath =[dataPath1 stringByAppendingPathComponent :name];

    BOOL isReachable =[Fitness4MeUtils isReachable];
   
    if (isReachable){
      
        // Check If File Does Exists if not download the video
        if (![[NSFileManager defaultManager] fileExistsAtPath:filepath]){
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
            [request setDownloadDestinationPath:filepath];
            [request setDelegate:self];
            [request setTimeOutSeconds:15];
            [request startSynchronous];
        }else {
            stop=stop+1;
            if (stop==[excersicesList count]) {
                if([signUpView superview]!=nil){
                    [signUpView removeFromSuperview];
                }
                if ([excersicesList count]>0){
                    [letsgoButton setEnabled:YES];
                    [letsgoButton setHidden:NO];
                    [backButton setEnabled:YES];
                }
                
            }
        }
    }
    else {
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:filepath]){
          //

            stopz=stopz+1;
            if (stopz==1) {

                [letsgoButton setEnabled:NO];
                [letsgoButton setHidden:YES];
                [backButton setEnabled:NO];
                [self performSelectorOnMainThread:@selector(navigateToHome)
                                             withObject:nil
                                          waitUntilDone:YES];
               // [self navigateToHome];
                
                return;

            }
            
        }
        else {
            stop=stop+1;
            if (stop==[excersicesList count]) {
                if ([excersicesList count]>0){
                    [letsgoButton setEnabled:YES];
                    [letsgoButton setHidden:NO];
                    [backButton setEnabled:YES];
                }
            }
        }
    }
}




#pragma mark -ASIHTTPRequest delegate methods

- (void)requestDidFinish:(ASINetworkQueue *)queue
{
//    finished=finished+1;
//    [self.delegate didfinishedWorkout:finished:totalcount];
//    
//    if (finished==totalcount) {
//        [myQueue setDelegate:nil];
//        [myQueue cancelAllOperations];
//        
//        [self resetRequest];
//    }
    
}


- (void)requestDidFail:(ASINetworkQueue *)queue
{
    
    [myQueue setDelegate:nil];
    [myQueue cancelAllOperations];
    [signUpView removeFromSuperview];
    [letsgoButton setEnabled:NO];
    [letsgoButton setHidden:YES];
    [backButton setEnabled:YES];
}


-(void)requestFailed:(ASIHTTPRequest *)request
{
    stop=stop+1;
    if (stop==[excersicesList count]) {
        [signUpView removeFromSuperview];
    }
}

// Method to either make a free purchase or in app purchase;
-(void)UnlockVideos
{
    NSString *purchaseStatus;
    
    [self getUnlockedExcersices];
    
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    int unlockcount =[userinfo integerForKey:@"freePurchaseCount"];
    
    if (unlockcount >=2) {
        if ([[workout IsLocked] isEqualToString :@"true"]) {
            [self startActivity];
            [NSThread detachNewThreadSelector:@selector(purchaseProUpgrade) toTarget:self withObject:nil];
        }
        else {
            
            [self startActivity];
            [NSThread detachNewThreadSelector:@selector(parseExcersiceDetails) toTarget:self withObject:nil];
        }
    }
    
    else
    {
        NSString *workoutID= [userinfo stringForKey:@"WorkoutID"];
        if ([[workout WorkoutID] isEqualToString:workoutID]) {
            [self startActivity];
            [NSThread detachNewThreadSelector:@selector(parseExcersiceDetails)
                                     toTarget:self withObject:nil];
        }
        else
        {
            
            NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
            int unlockcount =[userinfo integerForKey:@"freePurchaseCount"];
            [userinfo setInteger:unlockcount+1 forKey:@"freePurchaseCount"];
            [userinfo setObject:[workout WorkoutID]   forKey:@"WorkoutID"];
            purchaseStatus =@"false";
            [self UpdateServer:purchaseStatus];
            [self startActivity];
            
            
        }
    }
}

-(void)NavigateToWorkoutList
{
    ListWorkoutsViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[ListWorkoutsViewController alloc]initWithNibName:@"ListWorkoutsViewController" bundle:nil];
    }else {
        viewController =[[ListWorkoutsViewController alloc]initWithNibName:@"ListWorkoutsViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController release];

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
    if ([[self purchaseAll] isEqualToString:@"true"]) {
        productIdentifier = @"Lite.fitness4.me.FullPurchase";
    }
    else {
        productIdentifier = [NSString stringWithFormat:@"Lite.fitness4.me.%@",
                             [workout WorkoutID]];
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
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        [userinfo setObject:@"true" forKey:@"hasMadeFullPurchase"];
        transaction =nil;
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
        

        [userinfo setObject:@"false" forKey:@"fullVideoDownloadlater"];
    }
    else{
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
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
    
    letsgoButton.enabled=NO;
    backButton.enabled=NO;
    letsgoButton.hidden=YES;
    NSLog(@"failedTransaction : %@", [transaction.error localizedDescription]);
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
        if([signUpView superview]!=nil)
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
    SKProduct *validProduct = nil;
    
    int counts = [response.products count];
    
    NSLog (@"count for in app purchases is %d", count);
    
    if (counts>0) {
        
        validProduct = [response.products objectAtIndex:0];
        //SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"appUpdate1"];
        //
       // [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
       // [[SKPaymentQueue defaultQueue] addPayment:payment]; // <-- KA CHING!
        
       // NSLog (@"payment proccessed I think");
    }
    
}


#pragma mark -Instance Methods


-(IBAction)NavigateToMoviePlayer:(id)sender{
    
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    
    int applicationUsedCount =[userinfo integerForKey:@"applicationLaunchCount"];
    applicationUsedCount =applicationUsedCount+1;
    [userinfo setInteger:applicationUsedCount  forKey:@"applicationLaunchCount"];
    
    ExcersicePlayViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[ExcersicePlayViewController alloc]initWithNibName:@"ExcersicePlayViewController" bundle:nil];
    }
    else{
        viewController =[[ExcersicePlayViewController alloc]initWithNibName:@"ExcersicePlayViewController_iPad" bundle:nil];
    }
    
    NSString *workoutID =[self.workout WorkoutID];
    int workouts =[workoutID intValue];
    viewController.userID =userID;
    viewController.WorkoutID =workouts;
    viewController.workout=workout;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}


-(IBAction)onClickBack:(id)sender{
    [self NavigateToWorkoutList];
}


-(IBAction)onClickOK:(id)sender{
    
    [slownetView removeFromSuperview];
    [self NavigateToWorkoutList];
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return NO;
}

@end
