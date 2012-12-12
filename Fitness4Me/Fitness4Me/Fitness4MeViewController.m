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

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [Fitness4MeUtils showAdMob:self];
    
    [SyncView removeFromSuperview];
    SyncView.layer.cornerRadius =14;
    SyncView.layer.borderWidth = 2;
    SyncView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self freeVideoDownload];
    
    
    NSArray *VideoArray =[NSArray arrayWithObjects:@"completed_exercise_de.mp4",@"completed_exercise.mp4",@"next_exercise_de.mp4",@"next_exercise.mp4",@"otherside_exercise_de.mp4",@"otherside_exercise.mp4",@"recovery_15_de.mp4",@"recovery_15.mp4",@"recovery_30_de.mp4",@"recovery_30.mp4",@"stop_exercise_de.mp4",@"stop_exercise.mp4",nil];
    
    
    BOOL success;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    dataPath= [documentsDirectory stringByAppendingPathComponent:@"MyFolder"];
    
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        //Create Folder
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    
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
    [fitness parseWorkoutVideos];
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
    
    
    


    [fitness getFreevideos];
    
    fileDownloadProgressView.progress = ((float)0 / (float) 100);
}


- (void)didfinishedWorkout:(int)countCompleted:(int)totalCount
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
         }];
    }
    fileDownloadProgressView.progress = ((float)countCompleted / (float) totalCount);
}


//
// called for  navigating To WorkoutListView
//

-(IBAction)navigateToWorkoutListView:(id)sender{
    
    ListWorkoutsViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[ListWorkoutsViewController alloc]initWithNibName:@"ListWorkoutsViewController" bundle:nil];
    }else {
        viewController =[[ListWorkoutsViewController alloc]initWithNibName:@"ListWorkoutsViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController release];
}

//
// called for  navigating To WorkoutListView
//

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



//
// called for  navigating To WorkoutListView
//

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

//
// called for  navigating To WorkoutListView
//

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
    CustomWorkoutsViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[CustomWorkoutsViewController alloc]initWithNibName:@"CustomWorkoutsViewController" bundle:nil];
    }else {
        //viewController =[[HintsViewController alloc]initWithNibName:@"CustomizedWorkoutListViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController release];

}


- (IBAction)onclickSelfMadeworkout:(id)sender {
     ExcersiceListViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[ExcersiceListViewController alloc]initWithNibName:@"ExcersiceListViewController" bundle:nil];
    }else {
        viewController =[[ExcersiceListViewController alloc]initWithNibName:@"ExcersiceListViewController" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];

}

-(IBAction)cancelDownloas:(id)sender
{
    FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
    [fitness cancelDownload];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self .navigationController setNavigationBarHidden:YES animated:NO];
    
    [super viewWillAppear:animated];
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

@end
