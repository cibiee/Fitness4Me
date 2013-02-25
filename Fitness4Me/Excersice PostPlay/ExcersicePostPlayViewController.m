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
        
       // [self performSelector:@selector(showUpgradeView) withObject:nil afterDelay:2];
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
        bannerView_.adUnitID = @"a150efb4cbe1a0a";
        
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
        viewController = [[MemberPromoViewController alloc]initWithNibName:@"MemberPromoViewController_iPad" bundle:nil];
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
