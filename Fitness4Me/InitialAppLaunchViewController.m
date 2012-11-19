//
//  InitialAppLaunchViewController.m
//  Fitness4Me
//
//  Created by Ciby on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InitialAppLaunchViewController.h"
#import "LandigPageViewController.h"
#import "UserLoginViewController.h"
#import "Fitness4MeUtils.h"
#import "TermsOfUse.h"
#import <QuartzCore/QuartzCore.h>
#import "GADBannerView.h"

@interface InitialAppLaunchViewController ()

@end

@implementation InitialAppLaunchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Overriden Methods

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setChildProperties];
    selectedLanguage=@"";
    [selectLanguageView removeFromSuperview];
    [super viewDidLoad];
    
    [self prepareData];
    [self showAdmobs];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    int  selectedlang=[Fitness4MeUtils getApplicationLanguage] ;
    if (selectedlang==0)
        [self showDropDown];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Instance Methods

-(IBAction)onclickLogin:(id)sender
{
    UserLoginViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController = [[UserLoginViewController alloc]initWithNibName:@"UserLoginViewController" bundle:nil];
    }else {
        viewController = [[UserLoginViewController alloc]initWithNibName:@"UserLoginViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)onclickRegisterUser:(id)sender
{
    
    LandigPageViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController = [[LandigPageViewController alloc]initWithNibName:@"LandigPageViewController" bundle:nil];
    }else {
        viewController = [[LandigPageViewController alloc]initWithNibName:@"LandigPageViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
    
}

-(IBAction)dismissActionSheets:(id)sender{
    
    if ([selectedLanguage isEqualToString:@""]) {
        [Fitness4MeUtils showAlert:@"Please select a language !"];
    }else{
        
        
        [UIView transitionWithView:selectLanguageView duration:1
                           options:UIViewAnimationOptionTransitionCurlUp animations:^{
                               [selectLanguageView setAlpha:0.0];
                               
                           }
                        completion:^(BOOL finished)
         {
             [selectLanguageView removeFromSuperview];
             [self showTermsofUse];
             
         }];
    }
}


#pragma mark - Hidden Instance methods

- (void)setChildProperties
{
    [newtoFitness4meLabel setTextColor:UIColorFromRGBWithAlpha(0xc8e2ff,1)];
    [signUpLabel setTextColor:UIColorFromRGBWithAlpha(0xc8e2ff,1)];
    [logInLabel setTextColor:UIColorFromRGBWithAlpha(0xc8e2ff,1)];
    [haveAccountLabel setTextColor:UIColorFromRGBWithAlpha(0xc8e2ff,1)];
    
    [selectLanguageView.layer setBorderColor:[[UIColor whiteColor]CGColor]];
    [selectLanguageView.layer setBorderWidth:2];
    [selectLanguageView.layer setCornerRadius:8];
    
}

- (void)showAdmobs
{
    [Fitness4MeUtils showAdMobPrelogin:self];
}

-(void)showDropDown{
    [self.view addSubview:selectLanguageView];
      }

- (void)showTermsofUse {
    TermsOfUse *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController = [[TermsOfUse alloc]initWithNibName:@"TermsOfUse" bundle:nil];
    }else {
        viewController = [[TermsOfUse alloc]initWithNibName:@"TermsOfUse_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
    
}

-(void)prepareData{
    
    currencytexts = [[NSMutableArray alloc]initWithObjects:@"English",@"German", nil];
    currencyKeys = [[NSMutableArray alloc]initWithObjects:@"English",@"de",
                    nil];
}

#pragma mark - tableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [currencytexts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:@"Cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell.textLabel setText:[currencytexts objectAtIndex:indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndex];
    
    oldCell.accessoryType = UITableViewCellAccessoryNone;
   
    [[tableView cellForRowAtIndexPath:indexPath]
     setAccessoryType:UITableViewCellAccessoryCheckmark];
    [self setLastIndex:indexPath];
    selectedLanguage =[currencytexts objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:[currencytexts objectAtIndex:indexPath.row], nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setInteger:indexPath.row+1 forKey:@"lang"];
}

#pragma mark - orientation methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

-(BOOL)shouldAutorotate {
    return NO;
}

@end
