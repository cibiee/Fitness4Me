//
//  LandigPageViewController.m
//  Fitness4Me
//
//  Created by Ciby on 01/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LandigPageViewController.h"
#import "LoginViewController.h"
#import "InitialAppLaunchViewController.h"

@interface LandigPageViewController ()

@end

@implementation LandigPageViewController

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
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
        }
        if(result.height == 568)
        {
            
           textView.frame=CGRectMake(10, 200, 320, 175);
        }
    }

    
    // Do any additional setup after loading the view from its nib.
}



-(IBAction)onNavigateToUserRegistration:(id)sender
{ 
    LoginViewController  *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        viewController =[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    }
    else {
        viewController =[[LoginViewController alloc]initWithNibName:@"LoginViewController_iPad" bundle:nil];    }


    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}


-(IBAction)onNavigateToHomeView:(id)sender
{
    InitialAppLaunchViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
     viewController =[[InitialAppLaunchViewController alloc]initWithNibName:@"InitialAppLaunchViewController" bundle:nil];
    }
    else {
    viewController =[[InitialAppLaunchViewController alloc]initWithNibName:@"InitialAppLaunchViewController_iPad" bundle:nil];    }
    
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
