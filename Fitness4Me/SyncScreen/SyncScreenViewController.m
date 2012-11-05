//
//  SyncScreenViewController.m
//  Fitness4Me
//
//  Created by Ciby on 06/08/12.
//
//

#import "SyncScreenViewController.h"
#import "Fitness4MeViewController.h"
#import "ASIFormDataRequest.h"

@interface SyncScreenViewController ()

@end

@implementation SyncScreenViewController

@synthesize UserID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - private Methods

-(void)getUserPreferencesData
{
    
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    self.UserID =[userinfo integerForKey:@"UserID"];
    
    
    
}


-(void)getExcersices{
    
    [activityIndicator startAnimating];
    [self parseFitnessDetails];
}

-(void)parseFitnessDetails{
    
    
    
    NSString *UrlPath= [NSString GetURlPath];
    
    
    BOOL isReachable =[Fitness4MeUtils isReachable];
    if (isReachable){
        
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        self.UserID =[userinfo integerForKey:@"UserID"];
        
        NSString *requestString = [NSString stringWithFormat:@"%@listapps=yes&userid=%i&duration=10",UrlPath, UserID];
        NSURL *url =[NSURL URLWithString:requestString];
        
        ASIFormDataRequest   *request = [ASIFormDataRequest   requestWithURL:url];
        [request setTimeOutSeconds:60];
        [request setDelegate:self];
        [request startAsynchronous];
        //[self navigateToFitness4Me];
        
    }
    
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    if ([responseString length]>0) {
        
        NSMutableArray *object = [responseString JSONValue];
        workouts = [[NSMutableArray alloc]init];
        NSMutableArray *itemsarray =[object valueForKey:@"items"];
        
        for (int i=0; i<[itemsarray count]; i++) {
            
            NSString *workoutID =[[itemsarray objectAtIndex:i] valueForKey:@"id"];
            NSString *name = [[itemsarray objectAtIndex:i] valueForKey:@"name"];
            NSString *rate = [[itemsarray objectAtIndex:i] valueForKey:@"rate"];
            NSString *descriptionTodo = [[itemsarray objectAtIndex:i] valueForKey:@"description_big"];
            NSString *imageName =[[itemsarray objectAtIndex:i] valueForKey:@"image_name"];
            NSString *imageUrl =[[itemsarray objectAtIndex:i] valueForKey:@"image"];
            NSString *description = [[itemsarray objectAtIndex:i] valueForKey :@"description"];
            NSString *islocked =[[itemsarray objectAtIndex:i] valueForKey :@"islocked"];
            NSString *descriptionBig =[[itemsarray objectAtIndex:i] valueForKey :@"description_big"];
            NSString *thumbImage =[[itemsarray objectAtIndex:i] valueForKey :@"image_thumb"];
            NSString *props =[[itemsarray objectAtIndex:i] valueForKey :@"props"];
            
            Workout *workout = [[Workout alloc]initWithData:workoutID:name:rate:imageUrl:imageName:islocked:description:descriptionTodo:nil:descriptionBig:thumbImage:props];
            [workouts addObject:workout];
            
            
        }
        
        if ([workouts count]>0) {
            [self insertExcersices];
        }
        
        // Use when fetching binary data
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    // NSError *error = [request error];
    
}


-(void)navigateToFitness4Me{
    
    Fitness4MeViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[Fitness4MeViewController alloc]initWithNibName:@"Fitness4MeViewController" bundle:nil];
    }
    else{
        viewController =[[Fitness4MeViewController alloc]initWithNibName:@"Fitness4MeViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
    
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getExcersices];
    
    // Do any additional setup after loading the view from its nib.
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
    [self getUserPreferencesData];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}




-(void)insertExcersices
{
    workoutDB =[[WorkoutDB alloc]init];
    [workoutDB setUpDatabase];
    [workoutDB createDatabase];
    [workoutDB insertWorkouts:workouts];
    
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    
    
}

-(BOOL)shouldAutorotate {
    return NO;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
