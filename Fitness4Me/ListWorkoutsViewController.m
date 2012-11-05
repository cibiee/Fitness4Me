//
//  ListWorkoutsViewController.m
//  Fitness4Me
//
//  Created by Ciby on 02/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListWorkoutsViewController.h"
#import "NSString+Config.h"
#import "Fitness4MeUtils.h"


@implementation ListWorkoutsViewController

@synthesize UserID,activityIndicator,signUpView,tableview,myQueue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
        myQueue=[[ASINetworkQueue alloc]init];
    }
    return self;
}


#pragma mark - private methods


-(void)setBackround
{
    tableview.rowHeight =90;
    tableview.separatorColor =[UIColor clearColor];
    [Fitness4MeUtils showAdMob:self];
    networkNotificationtextView.hidden=YES;
    [networkNotificationtextView setBackgroundColor:UIColorFromRGBWithAlpha(0xde1818,1)];
    [offerView setBackgroundColor:UIColorFromRGBWithAlpha(0xf6f6f6,1)];
    
}


-(void)getUnlockedExcersices
{
    
    workoutDB =[[WorkoutDB alloc]init];
    [workoutDB setUpDatabase];
    [workoutDB createDatabase];
    [workoutDB selectWorkout];
    count= [workoutDB temp];
    [workoutDB release];
    
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    int Unlockcount =[userinfo integerForKey:@"freePurchaseCount"];
    
    if (Unlockcount<count)
        Unlockcount=count;
    [userinfo setInteger:Unlockcount forKey:@"freePurchaseCount"];
    
    if (Unlockcount<2) {
        
        NSString *msg;
        
        if(Unlockcount ==1){
            msg =@"Unlock your remaining one free 10 Minute Exercise program now !!";
        }
        else{
            msg =@"Now choose your two free 10 Minute Exercise program";
        }
        
        [Fitness4MeUtils showAlert:msg];
        
    }
    
}



-(void)getExcersices{
    
    [activityIndicator startAnimating];
    [NSThread detachNewThreadSelector:@selector(ListExcersices) toTarget:self withObject:nil];
}


- (void)groupWorkoutdata:(NSMutableArray *)object {
    NSMutableArray *itemsarray =[object valueForKey:@"items"];
    
    [itemsarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* item = obj;
        [workouts addObject:[[Workout alloc]initWithData:[item objectForKey:@"id"]:[item objectForKey:@"name"]:[item objectForKey:@"rate"]:[item objectForKey:@"image_android"]:[item objectForKey:@"image_name"]:[item objectForKey :@"islocked"]:[item objectForKey:@"description"]:[item objectForKey:@"description_big"]:nil:[item objectForKey:@"description_big"]:[item objectForKey :@"image_thumb"]:[item objectForKey:@"props"]]];
    }];
    
}

- (ASIFormDataRequest *)getWorkoutList:(NSString *)UrlPath {
    
     int  selectedlang=[Fitness4MeUtils getApplicationLanguage] ;
    NSString *requestString = [NSString stringWithFormat:@"%@listapps=yes&userid=%i&duration=10&lang=%i",UrlPath, UserID,selectedlang];
    NSURL *url =[NSURL URLWithString:requestString];
    
    ASIFormDataRequest   *request = [ASIFormDataRequest   requestWithURL:url];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    return request;
}

-(void)parseFitnessDetails{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *UrlPath= [NSString GetURlPath];
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
    
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        self.UserID =[userinfo integerForKey:@"UserID"];
    
        ASIFormDataRequest *request;
        request = [self getWorkoutList:UrlPath];
        [request setTimeOutSeconds:15];
        NSError *error = [request error];
        if (!error){
           
            NSString *response = [request responseString];
            if ([response length]>0) {
                
                NSMutableArray *object = [response JSONValue];
                workouts = [[NSMutableArray alloc]init];
                [self groupWorkoutdata:object];
                
                if ([workouts count]>0) {
                    [self insertExcersices];
                }
                
            }
            else {
                [self terminateActivity];
            }
        }
        else {
            
            [self terminateActivity];
            [self performSelectorOnMainThread:@selector(navigateToHome) withObject:nil waitUntilDone:NO];
        }
    }
    
    else{
        [self ListExcersices];
    }
    [pool drain];
    
}

-(void)terminateActivity
{
    [Fitness4MeUtils showAlert:NSLocalizedString(@"NoInternetMessage", nil)];
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}

-(void)didRecieveWorkoutList
{
    [tableview reloadData];
}


-(void)insertExcersices
{
     workoutDB =[[WorkoutDB alloc]init];
    [workoutDB setUpDatabase];
    [workoutDB createDatabase];
    [workoutDB insertWorkouts:workouts];
    [workoutDB release];
    [self ListExcersices];
}


-(IBAction)fullVideoDownload:(id)sender{
    
    
    
    [fullvideoView  removeFromSuperview];
    [self.view addSubview:signupviews];
    [activityindicators startAnimating];
     NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setObject:@"true" forKey:@"fullVideoDownloadlater"];
    [NSThread detachNewThreadSelector:@selector(startDownload) toTarget:self withObject:nil];
    
    
}

-(void)startDownload
{
     FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
    [fitness setDelegate:self];
    [fitness getAllvideos];
    fileDownloadProgressView.progress = ((float)0 / (float) 100);
    
       
}

-(IBAction)later:(id)sender
{
    
    [fullvideoView  removeFromSuperview];
    [signupviews removeFromSuperview];
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setObject:@"true" forKey:@"fullVideoDownloadlater"];
    [userinfo setObject:@"true" forKey:@"showDownload"];
    [Fitness4MeUtils showAlert:NSLocalizedString(@"workoutsthroughsettingsmsg", nil)];

    
}

- (void)didfinishedWorkout:(int)countCompleted:(int)totalCount
{
    [signupviews addSubview:lblCompleted];
    NSString *s= [NSString stringWithFormat:@"%i / %i",countCompleted,totalCount];
    lblCompleted.text =s;
    if (countCompleted ==totalCount) {
        [signupviews removeFromSuperview];
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        [userinfo setObject:@"false" forKey:@"showDownload"];
    }
    fileDownloadProgressView.progress = ((float)countCompleted / (float) totalCount);
}

 

-(IBAction)cancelDownloas:(id)sender
{
    
    [signupviews removeFromSuperview];
     NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setObject:@"true" forKey:@"fullVideoDownloadlater"];
    [userinfo setObject:@"true" forKey:@"showDownload"];
     FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
    [fitness cancelDownload];
    [lblCompleted removeFromSuperview];

}



-(void)ListExcersices
{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    workoutDB =[[WorkoutDB alloc]init];
    [workoutDB setUpDatabase];
    [workoutDB createDatabase];
    [workoutDB getWorkouts];
    
    if ([workoutDB.Workouts count]>0) {
        
        workouts = workoutDB.Workouts;
        [tableview reloadData];
        [activityIndicator stopAnimating];
        [activityIndicator setHidesWhenStopped:YES];
        
    }
    
    else {
        
        BOOL isReachable =[Fitness4MeUtils isReachable];
        if (isReachable){
            [NSThread detachNewThreadSelector:@selector(parseFitnessDetails) toTarget:self withObject:nil];
        }
        else {
            
            networkNotificationtextView.hidden=NO;
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            
            return;
        }
    }
    
    [workoutDB release];
    
    if([workouts count] >2){
        [self getUnlockedExcersices];
    }
    
    tableview.separatorStyle =UITableViewStylePlain;
    [pool drain];
}

-(void)navigateToHome{
    
    [Fitness4MeUtils navigateToHomeView:self];
}



#pragma mark - view overload methods


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self setBackround];
    [offerView removeFromSuperview];
    [fullvideoView removeFromSuperview];
    [signupviews removeFromSuperview];
    
    fullvideoView.layer.cornerRadius =14;
    fullvideoView.layer.borderWidth = 2;
    fullvideoView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    signupviews.layer .cornerRadius =14;
    signupviews.layer.borderWidth = 2;
    signupviews.layer.borderColor = [UIColor whiteColor].CGColor;


    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    NSString *hasMadeFullPurchase= [userinfo valueForKey:@"hasMadeFullPurchase"];
    NSString *fullvideoDownload= [userinfo valueForKey:@"fullVideoDownloadlater"];
    
    if ([hasMadeFullPurchase isEqualToString:@"true"]) {
        
        if ([fullvideoDownload isEqualToString:@"false"]) {
            [self.view addSubview:fullvideoView];
            [activityIndicator setHidden:NO];
            [activityIndicator startAnimating];
            [NSThread detachNewThreadSelector:@selector(parseFitnessDetails) toTarget:self withObject:nil];
        }
        
    }
}

- (void)showRating {
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    int applicationUsedCount =[userinfo integerForKey:@"applicationLaunchCount"];
    RatingViewController *viewControllers;
    if (applicationUsedCount==5) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            
        }
        
        else {
            
            viewControllers =[[RatingViewController alloc]initWithNibName:@"RatingViewController" bundle:nil];
            [self.navigationController pushViewController:viewControllers animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self showRating];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    self.UserID =[userinfo integerForKey:@"UserID"];
    [self getExcersices];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [workouts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    CellContentController *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[CellContentController alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:MyIdentifier];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_item.png"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_item.png"]];
        
    }
    
    cell.backgroundColor =[UIColor clearColor];
    
    Workout *workout = [[[Workout alloc]init]autorelease];
    workout = [workouts objectAtIndex:indexPath.row];
    cell.TitleLabel.text = [workout Name];
    cell.DescriptionLabel.text = [workout Description];
    if ([[workout IsLocked] isEqualToString :@"true"]) {
       // cell.RateLabel.text =[[workout Rate] stringByAppendingString:@"$"];
    }
    else {
        [cell.RateLabel removeFromSuperview];
    }
    
    cell.ExcersiceImage.image = [self imageForRowAtIndexPath:workout inIndexPath:indexPath];
    //[self mainImageForRowAtIndexPath:workout];
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    int Unlockcount =[userinfo integerForKey:@"freePurchaseCount"];
    
    if (Unlockcount==1) {
        [cell.LockedImage setHidden:NO];
        [cell.LockedImage setImage:[UIImage imageNamed:[workout LockImageUrl]]];
    }
    
    else {
        if ([[workout IsLocked] isEqualToString :@"true"]) {
            
            [cell.LockedImage setHidden:NO];
            [cell.LockedImage setImage:[UIImage imageNamed:[workout LockImageUrl]]];
        }
        
        else{
            [cell.LockedImage setHidden:NO];
            [cell.LockedImage setImage:[UIImage imageNamed:[workout LockImageUrl]]];
        }
    }
    return cell;
    
}


- (UIImage *)imageForRowAtIndexPath:(Workout *)workout inIndexPath:(NSIndexPath *)indexPath
{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyFolder/Thumbs"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        //Create Folder
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString  *storeURL= [dataPath stringByAppendingPathComponent :[workout ImageName]];
    UIImageView *excersiceImageHolder =[[[UIImageView alloc]init]autorelease];
    // Check If File Does Exists if not download the video
    if (![[NSFileManager defaultManager] fileExistsAtPath:storeURL]){
        UIImage *im =[UIImage imageNamed:@"dummyimg.png"];
         excersiceImageHolder.image =im;
        [self.myQueue setDelegate:self];
        [self.myQueue setShowAccurateProgress:YES];
        [self.myQueue setRequestDidFinishSelector:@selector(requestFinisheds:)];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[workout ThumbImageUrl]]];
        [request setDownloadDestinationPath:storeURL];
        [request setDelegate:self];
        [request startAsynchronous];
        [myQueue addOperation:[request copy]];
        [myQueue go];
    }else {
        UIImage *im =[[UIImage alloc]initWithContentsOfFile:storeURL];
        excersiceImageHolder.image=im;
        [im release];
    }
	
    return excersiceImageHolder.image;
    
}


- (void)mainImageForRowAtIndexPath:(Workout *)workout
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyFolder"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        //Create Folder
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString  *storeURL= [dataPath stringByAppendingPathComponent :[workout ImageName ]];
    // Check If File Does Exists if not download the video
    if (![[NSFileManager defaultManager] fileExistsAtPath:storeURL]){
        [self.myQueue setDelegate:self];
        [self.myQueue setShowAccurateProgress:YES];
        [self.myQueue setRequestDidFinishSelector:@selector(requestFinisheds:)];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[workout ImageUrl]]];
        [request setDownloadDestinationPath:storeURL];
        [request setDelegate:self];
        [request startAsynchronous];
        [myQueue addOperation:[request copy]];
        [myQueue go];
    }    
}



- (void)requestFinisheds:(ASINetworkQueue *)queue
{
    [tableview reloadData];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Workout *workout = [workouts objectAtIndex:indexPath.row];
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setObject:workout.Name forKey:@"WorkoutName"];
    if ([[workout IsLocked] isEqualToString :@"false"]) {
        ExcersiceIntermediateViewController *viewController;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            viewController =[[ExcersiceIntermediateViewController alloc]initWithNibName:@"ExcersiceIntermediateViewController" bundle:nil];
        }
        else{
            viewController =[[ExcersiceIntermediateViewController alloc]initWithNibName:@"ExcersiceIntermediateViewController_iPad" bundle:nil];
        }
        viewController.workout =workout;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }else {
        selectedWorkout =workout;
        [self .view addSubview:offerView];
    }
}


#pragma mark - Instance Methods

-(IBAction)snycData
{
    
    [activityIndicator setHidden:NO];
    [activityIndicator startAnimating];
    [NSThread detachNewThreadSelector:@selector(parseFitnessDetails) toTarget:self withObject:nil];
    
}


-(IBAction)unlockOne
{
    
//    BOOL isReachable =[Fitness4MeUtils isReachable];
//    if (isReachable){
//
//        [offerView removeFromSuperview];
//        
//        ExcersiceIntermediateViewController *viewController;
//        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
//            viewController =[[ExcersiceIntermediateViewController alloc]initWithNibName:@"ExcersiceIntermediateViewController" bundle:nil];
//        }
//        else{
//            viewController =[[ExcersiceIntermediateViewController alloc]initWithNibName:@"ExcersiceIntermediateViewController_iPad" bundle:nil];
//        }
//        
//        viewController.purchaseAll =@"false";
//        viewController.workout =selectedWorkout;
//        
//        [self.navigationController pushViewController:viewController animated:YES];
//        
//        [viewController release];
//    }
//    else {
//        
//        [offerView removeFromSuperview];
//        [Fitness4MeUtils showAlert:NSLocalizedString(@"NoInternetMessage", nil)];
//        
//    }
}


-(IBAction)cancelTransaction
{
    [offerView removeFromSuperview];
    selectedWorkout=nil;
    
}

-(IBAction)unlockAll
{
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        
        [offerView removeFromSuperview];
        ExcersiceIntermediateViewController *viewController;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            viewController =[[ExcersiceIntermediateViewController alloc]initWithNibName:@"ExcersiceIntermediateViewController" bundle:nil];
        }else{
            viewController =[[ExcersiceIntermediateViewController alloc]initWithNibName:@"ExcersiceIntermediateViewController_iPad" bundle:nil];
        }
        
        viewController.purchaseAll =@"true";
        viewController.workout =selectedWorkout;
        [self.navigationController pushViewController:viewController animated:YES];
        
        [viewController release];
    }else {
        
        [offerView removeFromSuperview];
        [Fitness4MeUtils showAlert:NSLocalizedString(@"NoInternetMessage", nil)];
    }
    
}

- (void)didPresentView:(UIView *)View
{
    // UIAlertView in landscape mode
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.0];
    offerView.transform = CGAffineTransformRotate(offerView.transform, 0);
    [UIView commitAnimations];
}



-(BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
