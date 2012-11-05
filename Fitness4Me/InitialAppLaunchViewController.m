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
-(void)showAdmobs;
-(void)setChildProperties;
-(void)showDropDown;
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

    [super viewDidLoad];
    
    [self prepareData];
    [self showAdmobs];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setChildProperties];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
     selectedLanguage=@"Select";
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        viewController = [[UserLoginViewController alloc]initWithNibName:@"UserLoginViewController" bundle:nil];
        
    }
    else {
        viewController = [[UserLoginViewController alloc]initWithNibName:@"UserLoginViewController_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}




-(IBAction)onclickRegisterUser:(id)sender
{
    
    LandigPageViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        viewController = [[LandigPageViewController alloc]initWithNibName:@"LandigPageViewController" bundle:nil];
    }
    else {
        viewController = [[LandigPageViewController alloc]initWithNibName:@"LandigPageViewController_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark - Hidden Instance methods

- (void)setChildProperties
{
    [newtoFitness4meLabel setTextColor:UIColorFromRGBWithAlpha(0xc8e2ff,1)];
    [signUpLabel setTextColor:UIColorFromRGBWithAlpha(0xc8e2ff,1)];
    [logInLabel setTextColor:UIColorFromRGBWithAlpha(0xc8e2ff,1)];
    [haveAccountLabel setTextColor:UIColorFromRGBWithAlpha(0xc8e2ff,1)];
}

- (void)showAdmobs
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        bannerView_ = [[GADBannerView alloc]
                       initWithFrame:CGRectMake(0,self.view.frame.size.height-50,
                                                self.view.frame.size.width,
                                                50)];
        
    }
    else {
        bannerView_ = [[GADBannerView alloc]
                       initWithFrame:CGRectMake(0,self.view.frame.size.height-70,
                                                self.view.frame.size.width,
                                                100)];
        
    }
    
    bannerView_.adUnitID = @"a1506940e575b91";
    [bannerView_ setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    
    [bannerView_ loadRequest:[GADRequest request]];
}



-(void)showDropDown{
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    [actionSheet addSubview:pickerView];
    [pickerView release];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:closeButton];
    [closeButton release];
    
    if (self.view !=nil) {
        [actionSheet showInView: self.view];
        
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
       [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
        
    }
    else {
         [actionSheet setBounds:CGRectMake(0, 0, 600, 700)];
    }

   
    
    
}


-(void)prepareData{
    
    currencytexts = [[NSMutableArray alloc]initWithObjects:@"English",@"German", nil];
    currencyKeys = [[NSMutableArray alloc]initWithObjects:@"English",@"de",
                    nil];
}


#pragma mark - Action Sheet Delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    selectedLanguage =[currencytexts objectAtIndex:row];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:[currencytexts objectAtIndex:row], nil] forKey:@"AppleLanguages"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setInteger:row+1 forKey:@"lang"];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [currencytexts count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return  [currencytexts objectAtIndex:row];
}

-(void)dismissActionSheet:(id)sender{
    
    
    if ([selectedLanguage isEqualToString:@"Select"]) {
        
        selectedLanguage =[currencytexts objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:[currencytexts objectAtIndex:0], nil] forKey:@"AppleLanguages"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        [userinfo setInteger:1 forKey:@"lang"];
    }
    
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    
    TermsOfUse *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        viewController = [[TermsOfUse alloc]initWithNibName:@"TermsOfUse" bundle:nil];
        
    }
    else {
        viewController = [[TermsOfUse alloc]initWithNibName:@"TermsOfUse_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
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
