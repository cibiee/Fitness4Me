//
//  CustomWorkoutIntermediateViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 05/12/12.
//
//

#import "CustomWorkoutIntermediateViewController.h"
#include "ExcersicePlayViewController.h"
#include "CustomizedWorkoutPlayViewController.h"

@interface CustomWorkoutIntermediateViewController ()

@end

@implementation CustomWorkoutIntermediateViewController

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
    

    finished=0;
    totalCount=0;
    
    stopz=0;
    [self InitializeView];
    urlPath =[NSString GetURlPath];
    self.view.transform = CGAffineTransformConcat(self.view.transform,
                                                  CGAffineTransformMakeRotation(M_PI_2));
    

    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    self.UserID =[userinfo stringForKey:@"UserID"];
    self.userlevel =[userinfo stringForKey:@"Userlevel"];
    [userinfo setObject:@"false" forKey:@"shouldExit"];
    
    [self UnlockVideos];
    [letsgoButton setEnabled:NO];
    [letsgoButton setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [letsgoButton setEnabled:NO];
    [letsgoButton setHidden:YES];
    if (self.navigateBack) {
        [backButton setHidden:NO];
    }
    else
    {
        [backButton setHidden:YES];
    }

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    [letsgoButton setEnabled:NO];
    [letsgoButton setHidden:YES];
    if (self.navigateBack) {
        [backButton setHidden:NO];
    }
    else
    {
        [backButton setHidden:YES];
    }
    [self getUserDetails];
}


- (void)viewDidUnload
{
    [self setDurationLabel:nil];
    [self setScrollView:nil];
    [self setFocusLabel:nil];
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
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
            //Create Folder
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
        NSString  *storeURL= [dataPath stringByAppendingPathComponent :[self.workout ImageName]];
        // Check If File Does Exists if not download the video
        if (![[NSFileManager defaultManager] fileExistsAtPath:storeURL]){
            NSURL * imageURL = [NSURL URLWithString:[self. workout ImageUrl]];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            excersiceImageHolder.image = [UIImage imageWithData:imageData];
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[workout ImageUrl]]];
            [request setDownloadDestinationPath:storeURL];
            [request setDelegate:self];
            [request startAsynchronous];
        }else {
            UIImage *im =[[UIImage alloc]initWithContentsOfFile:storeURL];
            excersiceImageHolder.image=im;
        }
    }else{
        NSString  *storeURL= [dataPath stringByAppendingPathComponent :[self.workout ImageName]];
        // Check If File Does Exists if not download the video
        if ([[NSFileManager defaultManager] fileExistsAtPath:storeURL]){
            UIImage *im =[[UIImage alloc]initWithContentsOfFile:storeURL];
            excersiceImageHolder.image=im;
                   }else{
            UIImage *im =[UIImage imageNamed:@"dummyimg.png"];
            excersiceImageHolder.image =im;
        }
    }
}

-(void)InitializeView
{
    [self showWorkoutImage];
	
    descriptionTextview.text =[self.workout Focus];
    [descriptionTextview sizeToFit];
    titleLabel.text=[self.workout Name];
    if ([[self.workout Props] length]>0) {
        propsLabel.text=[self.workout Props];
        [propsLabel sizeToFit];
    }else{
        propsLabel.text=@"None";
        [propsLabel sizeToFit];
    }
    
    if ([[self.workout Focus] length]>0) {
        self.focusLabel.text=[self.workout Focus];
        [self.focusLabel sizeToFit];
    }else{
       // propLabel.hidden =YES;
    }
    
    NSString *duration=[[workout Duration] stringByAppendingString:@" Minutes"];
   [self.durationLabel setText:duration];
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setObject:workout.Name forKey:@"WorkoutName"];
    // add continue button
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 58, 30);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn_with_text.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationBar.leftBarButtonItem = backBtn;

}



-(void)startActivity
{
    [signUpView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [signUpView addSubview:pleaseWait];
    [activityIndicator setHidden:NO];
    if([signUpView superview]!=nil){
        [self.view addSubview:signUpView];
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
    
  
    
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        
        int  selectedlang=[Fitness4MeUtils getApplicationLanguage] ;
        NSString *requestString =[NSString stringWithFormat:@"%@customvideos=yes&custom_workout_id=%@&user_level=%@&lang=%i&user_id=%@",urlPath,[self.workout WorkoutID],userlevel,selectedlang,userID];
        NSURL *url =[NSURL URLWithString:requestString];
        
        ASIFormDataRequest   *request = [ASIFormDataRequest   requestWithURL:url];
        [request setTimeOutSeconds:15];
        [request startSynchronous];
        
        NSError *error = [request error];
        if (!error){
           
            NSString *response = [request responseString];
            //NSLog(response);
            NSMutableArray *object = [response JSONValue];
            excersices = [[NSMutableArray alloc]init];
            [self getWorkoutVideoData:object];
            [self deleteExcersices];
            [self insertExcersices];
            [self getExcersices];
        }else{
            [self getExcersices];
        }
    }
    
    else{
        
        if([signUpView superview]!=nil){
            [signUpView removeFromSuperview];
        }
      
        [self getExcersices];
    }
    
   
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
    
    
}

-(void)ShowVideounAvaialableMessage
{
    
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"fitness4.me" message:NSLocalizedString(@"VideoUnavailable", nil)
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertview show];
    
    
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
    [excersiceDB deleteCustomExcersice:workouts];
    
}

//
// called for getting User Details
//
-(void)getUserDetails
{
    UserDB *userDB =[[UserDB alloc]init];
    [userDB setUpDatabase];
    [userDB createDatabase];
    user =[[User alloc]init];
    user= userDB.getUser;
    
}


//method to insert the records related to a workout
-(void)insertExcersices
{
    [self initilaizeDatabase];
    [excersiceDB insertCustomExcersices:excersices];
    
}


//method to get Excersices related to a workout
-(void)getExcersices
{
    [self.view addSubview:signUpView];
    [letsgoButton setEnabled:NO];
    [letsgoButton setHidden:YES];
    
    excersicesList = [[NSMutableArray alloc]init];
    [self initilaizeDatabase];
    NSString *workoutID =[self.workout WorkoutID];
    int workouts =[workoutID intValue];
    [excersiceDB getCustomExcersices:workouts];
    
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
        
}


//method to start Download videos related to a workout
-(void)startDownload
{
    
    [self getCount];
    NSString *videoPath=[NSString getVideoPath];
    
    [fileDownloadProgressView setHidden:YES];
        
    for (int i=0; i<[excersicesList count]; i++) {
       
        NSString *PosterUrl= [videoPath stringByAppendingString:[[excersicesList objectAtIndex: i] valueForKey: @"PosterUrl"]];
        NSString *PosterName= [[excersicesList objectAtIndex: i] valueForKey: @"PosterName"];
        [self downloadVideos:PosterUrl:PosterName];
         
        

        NSString *videoUrl = [videoPath stringByAppendingString:[[excersicesList objectAtIndex: i] valueForKey: @"VideoUrl"]];
        NSString *Name =  [[excersicesList objectAtIndex: i] valueForKey: @"Name"];
        [self downloadVideos:videoUrl:Name];
        
                
        
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
         
    }
       
}


//method to start Download videos related to a workout
-(void)getCount
{
    
   [fileDownloadProgressView setHidden:YES];
    
    for (int i=0; i<[excersicesList count]; i++) {
        
       
        NSString *PosterName= [[excersicesList objectAtIndex: i] valueForKey: @"PosterName"];
        if ([PosterName length]>0) {
            [self getExcersiceCount];
        }
        NSString *Name =  [[excersicesList objectAtIndex: i] valueForKey: @"Name"];
        if ([Name length]>0) {
            [self getExcersiceCount];
        }
        NSString *othersidePosterName= [[excersicesList objectAtIndex: i] valueForKey: @"OthersidePosterName"];
        if ([othersidePosterName length]>0) {
            [self getExcersiceCount];
        }
        NSString *othersideName= [[excersicesList objectAtIndex: i] valueForKey: @"OthersideName"];
        if ([othersideName length]>0) {
            [self getExcersiceCount];
        }
        
    }
    
}

-(void)getExcersiceCount
{
    totalCount++;
}


int stopz=0;
//method to Download videos related to a workout
-(void)downloadVideos:(NSString *)url:(NSString*)name{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath1 = [documentsDirectory stringByAppendingPathComponent:@"MyFolder"];
    NSString  *filepath =[dataPath1 stringByAppendingPathComponent :name];
   
    BOOL isReachable =[Fitness4MeUtils isReachable];
    
    if (isReachable){
        
        // Check If File Does Exists if not download the video
        if (![[NSFileManager defaultManager] fileExistsAtPath:filepath]){
           
            self.myQueue = [ASINetworkQueue queue]; 
            [self.myQueue setDelegate:self];
            [self.myQueue setShowAccurateProgress:YES];
            [self.myQueue setRequestDidFinishSelector:@selector(requestDidFinish:)];
            [self.myQueue setRequestDidFailSelector:@selector(requestDidFail:)];
            downloadrequest =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
            [downloadrequest setDownloadDestinationPath:filepath];
            [downloadrequest setTimeOutSeconds:100];
            [downloadrequest shouldContinueWhenAppEntersBackground];
            //[downloadrequest startAsynchronous];
            [myQueue addOperation:downloadrequest];
            [myQueue go];

        }else {
                        finished=finished+1;
            [self didfinishedWorkout:finished :totalCount];
            }
        
    }
    else {
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:filepath]){
            //
            
            stopz=stopz+1;
            if (stopz==1) {
                
                
                [letsgoButton setEnabled:NO];
                [letsgoButton setHidden:YES];
                
                [self performSelectorOnMainThread:@selector(navigateToHome)
                                       withObject:nil
                                    waitUntilDone:YES];
                return;
                
            }
            
        }
        else {
            finished=finished+1;
            [self didfinishedWorkout:finished :totalCount];
        }
    }
}


- (void)didfinishedWorkout:(int)countCompleted:(int)totalcount
{
    
        
    
    if (countCompleted>0) {
        [fileDownloadProgressView setHidden:NO];
    }

    [signUpView addSubview:lblCompleted];
    NSString *s= [NSString stringWithFormat:@"%i / %i",countCompleted,totalcount];
    NSLog(s);
    
    lblCompleted.text =s;
    if (countCompleted ==totalCount) {
        [UIView transitionWithView:signUpView duration:1
                           options:UIViewAnimationOptionTransitionCurlUp animations:^{
                               [signUpView setAlpha:0.0];
                               
                           }
                        completion:^(BOOL finished)
         {
             [signUpView removeFromSuperview];
             [letsgoButton setEnabled:YES];
             [letsgoButton setHidden:NO];
         }];
        
        
    }
    
    else
    {
        [letsgoButton setEnabled:NO];
        [letsgoButton setHidden:YES];
    }
    
      
    fileDownloadProgressView.progress = ((float)countCompleted / (float) totalCount);
        
}


#pragma mark -ASIHTTPRequest delegate methods

- (void)requestDidFinish:(ASIHTTPRequest *)queue
{
    
    finished=finished+1;
    [self didfinishedWorkout:finished:totalCount];
    
        if (finished==totalCount) {
          [myQueue setDelegate:nil];
           [myQueue cancelAllOperations];

          [self resetRequest];
        }
    
}

- (void)resetRequest
{
    totalCount=0;
    finished=0;
}


- (void)requestDidFail:(ASINetworkQueue *)queue
{
    
    [myQueue setDelegate:nil];
    [myQueue cancelAllOperations];
    [signUpView removeFromSuperview];
    [letsgoButton setEnabled:NO];
    [letsgoButton setHidden:YES];
    }


-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}

// Method to either make a free purchase or in app purchase;
-(void)UnlockVideos
{
    [self getUnlockedExcersices];
    [self startActivity];
    [NSThread detachNewThreadSelector:@selector(parseExcersiceDetails) toTarget:self withObject:nil];
    
}

-(void)NavigateToWorkoutList
{
   
 
}


#pragma mark -Instance Methods


-(IBAction)NavigateToMoviePlayer:(id)sender{
    
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    
    int applicationUsedCount =[userinfo integerForKey:@"applicationLaunchCount"];
    applicationUsedCount =applicationUsedCount+1;
    [userinfo setInteger:applicationUsedCount  forKey:@"applicationLaunchCount"];
    
    CustomizedWorkoutPlayViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[CustomizedWorkoutPlayViewController alloc]initWithNibName:@"CustomizedWorkoutPlayViewController" bundle:nil];
    }
    else{
        viewController =[[CustomizedWorkoutPlayViewController alloc]initWithNibName:@"CustomizedWorkoutPlayViewController_iPad" bundle:nil];
    }
    
    NSString *workoutID =[self.workout WorkoutID];
    int workouts =[workoutID intValue];
    viewController.userID =userID;
    viewController.WorkoutID =workouts;
    viewController.workout=workout;
    [self.navigationController pushViewController:viewController animated:YES];
    
}


-(IBAction)onClickBack:(id)sender{
    [self cancelDownload];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)cancelDownload {
    
//    
//    for (ASIHTTPRequest *req in ASIHTTPRequest.sharedQueue.operations)
//    {
//        [req cancel];
//        [req setDelegate:nil];
//        [req clearDelegatesAndCancel];
//    }
    [myQueue setDelegate:nil];
    [myQueue cancelAllOperations];
    
    totalCount=0;
    
    finished=0;
    
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
