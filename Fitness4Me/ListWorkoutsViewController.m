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

    networkNotificationtextView.hidden=YES;
    [networkNotificationtextView setBackgroundColor:UIColorFromRGBWithAlpha(0xde1818,1)];
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
    
    tableview.separatorStyle =UITableViewStylePlain;
    [pool drain];
}

-(void)navigateToHome{
    
    [Fitness4MeUtils navigateToHomeView:self];
}

- (void)showRating {
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    int applicationUsedCount =[userinfo integerForKey:@"applicationLaunchCount"];
    RatingViewController *viewControllers;
    if (applicationUsedCount==5) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
             viewControllers =[[RatingViewController alloc]initWithNibName:@"RatingViewControllerView_iPad" bundle:nil];
        }
        
        else {
            
            viewControllers =[[RatingViewController alloc]initWithNibName:@"RatingViewController" bundle:nil];
            
        }
        
        [self.navigationController pushViewController:viewControllers animated:YES];
    }
}

- (void)requestFinisheds:(ASINetworkQueue *)queue
{
    [tableview reloadData];
}

#pragma mark - view overload methods


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self setBackround];
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
    [cell.RateLabel removeFromSuperview];
    cell.ExcersiceImage.image = [self imageForRowAtIndexPath:workout inIndexPath:indexPath];
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Workout *workout = [workouts objectAtIndex:indexPath.row];
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setObject:workout.Name forKey:@"WorkoutName"];
    
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
    
}


#pragma mark - Instance Methods

-(IBAction)snycData
{
    [activityIndicator setHidden:NO];
    [activityIndicator startAnimating];
    [NSThread detachNewThreadSelector:@selector(parseFitnessDetails) toTarget:self withObject:nil];
}



-(BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
