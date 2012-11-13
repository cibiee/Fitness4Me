//
//  RatingViewController.m
//  Fitness4Me
//
//  Created by Ciby K Jose on 20/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RatingViewController.h"

@interface RatingViewController ()

@end

@implementation RatingViewController

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
}


-(IBAction)ratetheApp:(id)sender{
    
    
    
    NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
    str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
    str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
    // Here is the app id from itunesconnect
    str = [NSString stringWithFormat:@"%@533402282", str];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}


-(IBAction)dontRatetheApp:(id)sender{
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setInteger:6  forKey:@"applicationLaunchCount"];
    [self navigateToHome];
    
    
}

-(IBAction)remindMeLater:(id)sender{
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setInteger:0  forKey:@"applicationLaunchCount"];
    [self navigateToHome];
}

-(void)navigateToHome
{
    
    ListWorkoutsViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        viewController =[[ListWorkoutsViewController alloc]initWithNibName:@"ListWorkoutsViewController" bundle:nil];
    }
    else {
        viewController =[[ListWorkoutsViewController alloc]initWithNibName:@"ListWorkoutsViewController_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}


-(void)navigateTofeedback
{
    
    FeedbackViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController" bundle:nil];
    }
    else{
        viewController =[[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate {
    return NO;
}

@end
