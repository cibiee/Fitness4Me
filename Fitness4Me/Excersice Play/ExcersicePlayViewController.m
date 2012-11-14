//
//  ExcersicePlayViewController.m
//  Fitness4Me
//
//  Created by Ciby K Jose on 06/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExcersicePlayViewController.h"
#import "NSString+Config.h"
#import "ExcersicePlay.h"

@implementation ExcersicePlayViewController

@synthesize excersices,WorkoutID,workout,userID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getExcersices];
    self.view.transform = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeRotation(M_PI_2));
    moviePlayer.view.backgroundColor =[UIColor  whiteColor];
    [self showAdMobs];
}


-(void)showAdMobs
{
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    NSString *hasMadeFullPurchase= [userinfo valueForKey:@"hasMadeFullPurchase"];
    [userinfo setObject:@"false" forKey:@"shouldExit"];
    if ([hasMadeFullPurchase isEqualToString:@"true"]) {
        
    }
    else {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            
            bannerView_ = [[GADBannerView alloc]
                           initWithFrame:CGRectMake(0,-7,
                                                    self.view.frame.size.width-70,
                                                    50)];
            
        }
        else {
            bannerView_ = [[GADBannerView alloc]
                           initWithFrame:CGRectMake(0,self.view.frame.size.width-70,
                                                    self.view.frame.size.height-10,
                                                    90)];
            
        }
        
        bannerView_.adUnitID = @"a1506940e575b91";
        bannerView_.rootViewController = self;
        [self.view addSubview:bannerView_];
        
        // Initiate a generic request to load it with an ad.
        [bannerView_ loadRequest:[GADRequest request]];
    }
}

-(void)getExcersices
{
    excersiceDB =[[ExcersiceDB alloc]init];
    [excersiceDB setUpDatabase];
    [excersiceDB createDatabase];
    [excersiceDB getExcersices:WorkoutID];
    arr = [[NSMutableArray alloc]init];
    arr =excersiceDB.Excersices;
    [self MakeArrayforViewing ];
    [self initializPlayer ];
}

-(void)MakeArrayforViewing
{
    
    ExcersicePlay *play;
    aras =[[NSMutableArray alloc]init];
    for (int i=0; i<[arr count]; i++) {
        play =[[ExcersicePlay alloc]init];
        play.repeatIntervel =[[[arr objectAtIndex:i]PosterRepeatCount]intValue];
        play.videoName =[[arr objectAtIndex:i] PosterName];
        if ([play.videoName length]>0) {
            
            [aras addObject:play];
        }
        [play release];
        
        play =[[ExcersicePlay alloc]init];
        play.repeatIntervel =[[[arr objectAtIndex:i]RepeatCount]intValue];
        play.videoName =[[arr objectAtIndex:i] Name];
        if ([play.videoName length]>0) {
            
            [aras addObject:play];
        }
        [play release];
        
        play =[[ExcersicePlay alloc]init];
        play.repeatIntervel =[[[arr objectAtIndex:i]StopRep] intValue];
        play.videoName =[[arr objectAtIndex:i] StopName];
        if ([play.videoName length]>0) {
            
            [aras addObject:play];
        }
        [play release];
        
        play =[[ExcersicePlay alloc]init];
        play.repeatIntervel =[[[arr objectAtIndex:i]OthersidePosterRep]intValue];
        play.videoName =[[arr objectAtIndex:i] OthersidePosterName];
        if ([play.videoName length]>0) {
            
            [aras addObject:play];
        }
        [play release];
        
        play =[[ExcersicePlay alloc]init];
        play.repeatIntervel =[[[arr objectAtIndex:i]OthersideRep]intValue];
        play.videoName =[[arr objectAtIndex:i] OthersideName];
        if ([play.videoName length]>0) {
            
            [aras addObject:play];
        }
        [play release];
        
        play =[[ExcersicePlay alloc]init];
        play.repeatIntervel =1;
        play.videoName =[[arr objectAtIndex:i] RecoveryVideoName];
        if ([play.videoName length]>0) {
            
            [aras addObject:play];
        }
        
        [play release];
        
        play =[[ExcersicePlay alloc]init];
        play.repeatIntervel =[[[arr objectAtIndex:i]NextRep]intValue];
        play.videoName =[[arr objectAtIndex:i] NextName];
        if ([play.videoName length]>0) {
            
            [aras addObject:play];
        }
        
        [play release];
        
        play =[[ExcersicePlay alloc]init];
        play.repeatIntervel =[[[arr objectAtIndex:i]CompletedRep]intValue];
        play.videoName =[[arr objectAtIndex:i] CompletedName];
        if ([play.videoName length]>0) {
            
            [aras addObject:play];
        }
        
        [play release];
    }
    
}

static int initalArrayCount=0;
static int playCount=0;
static float totalDuration=0;

-(void)initializPlayer
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyFolder"];
    storeURL =  [dataPath stringByAppendingPathComponent :[[aras objectAtIndex:initalArrayCount]videoName]];
    if (playCount==0) {
        if(initalArrayCount<[aras count]){
            initalArrayCount +=1;
            
        }
        else {
            initalArrayCount = 0;
        }
        
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:storeURL])
    {
        if (initalArrayCount<[aras count]) {
            int count =[[aras objectAtIndex:initalArrayCount-1]repeatIntervel];
            if (count==0) {
                count=1;
            }
            if (playCount==count) {
                
                playCount=0;
            }
            [self initializPlayer];
        }
    }
    else {
        if (moviePlayer!=nil) {
            if (playCount==0) {
                moviePlayer.view .frame= subview.bounds;
                moviePlayer.contentURL =[NSURL fileURLWithPath:storeURL];
                moviePlayer.controlStyle = MPMovieControlStyleNone;
                [moviePlayer play];
            }
            else {
                [moviePlayer play];
                moviePlayer.controlStyle = MPMovieControlStyleNone;
            }
        }
        else {
            moviePlayer = [[MPMoviePlayerController alloc] init];
            moviePlayer.contentURL =[NSURL fileURLWithPath:storeURL];
            [moviePlayer play];
            moviePlayer.controlStyle = MPMovieControlStyleNone;
            moviePlayer.view .frame= subview.bounds;
            [subview addSubview: moviePlayer.view];
        }
        
        moviePlayer.controlStyle = MPMovieControlStyleNone;
        
        //Register to receive a notification when the movie has finished playing.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:moviePlayer];
        
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSUInteger numTaps = [[touches anyObject] tapCount];
    if (numTaps == 1)
    {
        if(moviePlayer.controlStyle == MPMovieControlStyleEmbedded)
        {
            moviePlayer.controlStyle = MPMovieControlStyleNone;
        }
        else
        {
            moviePlayer.controlStyle = MPMovieControlModeVolumeOnly;
        }
    }
}

-(void)showAlert
{
    
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Fitness4Me" message:NSLocalizedString(@"exitVideo", nil)
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    [alertview show];
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.0];
    
    alertview.transform = CGAffineTransformRotate(alertview.transform, 3.14159/2);
    [UIView commitAnimations];
    [alertview release];
    
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    // UIAlertView in landscape mode
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.0];
    alertView.transform = CGAffineTransformRotate(alertView.transform, 3.14159/2);
    [UIView commitAnimations];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
        if (moviePlayer!=nil) {
            totalDuration= [moviePlayer currentPlaybackTime];
            totalDuration =totalDuration*60;
            [moviePlayer release];
        }
        initalArrayCount=0;
        playCount=0;
        
        ListWorkoutsViewController *viewController;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            viewController = [[ListWorkoutsViewController alloc]initWithNibName:@"ListWorkoutsViewController" bundle:nil];
        }
        else {
            viewController = [[ListWorkoutsViewController alloc]initWithNibName:@"ListWorkoutsViewController_iPad" bundle:nil];
        }
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    else {
        
    }
}

-(IBAction)onClickBack:(id)sender{
    [self showAlert];
}


- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    moviePlayer = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    
    playCount=playCount+1;
    if (initalArrayCount<[aras count]) {
        int count =[[aras objectAtIndex:initalArrayCount-1]repeatIntervel];
        if (count==0) {
            count=1;
        }
        if (playCount==count) {
            playCount=0;
        }
        
        [self initializPlayer];
    }
    else {
        
        initalArrayCount=0;
        playCount=0;
        totalDuration= [moviePlayer currentPlaybackTime];
        totalDuration=totalDuration*60;
        [self updateStatisticsToServer];
        
        ExcersicePostPlayViewController *viewController;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            viewController = [[ExcersicePostPlayViewController alloc]initWithNibName:@"ExcersicePostPlayViewController" bundle:nil];
        }
        else {
            viewController = [[ExcersicePostPlayViewController alloc]initWithNibName:@"ExcersicePostPlayViewController_iPad" bundle:nil];
        }
        
        viewController.workout =self.workout;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}


-(void)updateStatisticsToServer
{
    BOOL isReachable = [Fitness4MeUtils isReachable];
    
    if (isReachable) {
        [self updateServer];
    }
    
    
}

-(void)updateServer{
    
    NSString *UrlPath= [NSString GetURlPath];
    NSString *requestString = [NSString stringWithFormat:@"%@stats=yes&userid=%@&workoutid=%i&duration=%f",UrlPath,userID,WorkoutID,totalDuration];
    NSURL *url =[NSURL URLWithString:requestString];
    ASIFormDataRequest   *request = [ASIFormDataRequest   requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error){
        NSString *response = [request responseString];
        if ([response length]>0) {
            
        }
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    moviePlayer=nil;
    arr=nil;
    aras=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return NO;
}

-(BOOL)shouldAutorotate {
    return NO;
}

@end
