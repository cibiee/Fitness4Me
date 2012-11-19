//
//  AboutViewController.m
//  Fitness4Me
//
//  Created by Ciby on 04/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "Fitness4MeUtils.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark View Overriden methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadhints];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    [self loadhints];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark hidden instance methods

-(void)loadhints
{
    
	webView.backgroundColor = [UIColor colorWithRed:148.0/256.0 green:148.0/256.0 blue:148.0/256.0 alpha:0.0];
	webView.opaque = YES;
    int selectedLang= [Fitness4MeUtils getApplicationLanguage];
	// get localized path for file from app bundle
	NSString *path;
	NSBundle *thisBundle = [NSBundle mainBundle];
   
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (selectedLang ==1) {
            path = [thisBundle pathForResource:@"about" ofType:@"html"];
        }else{
            path = [thisBundle pathForResource:@"aboutusDe" ofType:@"html"];
        }
        
    }
    else {
        if (selectedLang ==1) {
            path = [thisBundle pathForResource:@"about_iPad" ofType:@"html"];
        }else{
            path = [thisBundle pathForResource:@"aboutusDe_Ipad" ofType:@"html"];
        }
    }
    
    
	// make a file: URL out of the path
	NSURL *instructionsURL = [NSURL fileURLWithPath:path];
	[webView loadRequest:[NSURLRequest requestWithURL:instructionsURL]];
    
	[super viewDidLoad];
}

-(void)navigateToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark instance methods


-(IBAction)loadAboutUs
{
    
	webView.backgroundColor = [UIColor colorWithRed:148.0/256.0 green:148.0/256.0 blue:148.0/256.0 alpha:0.0];
	webView.opaque = YES;
    int selectedLang= [Fitness4MeUtils getApplicationLanguage];
	// get localized path for file from app bundle
	NSString *path;
	NSBundle *thisBundle = [NSBundle mainBundle];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (selectedLang ==1) {
            path = [thisBundle pathForResource:@"about" ofType:@"html"];
        }else{
            path = [thisBundle pathForResource:@"aboutusDe" ofType:@"html"];
        }
        
    }
    else {
        if (selectedLang ==1) {
            path = [thisBundle pathForResource:@"about_iPad" ofType:@"html"];
        }else{
            path = [thisBundle pathForResource:@"aboutusDe_Ipad" ofType:@"html"];
        }
    }

	// make a file: URL out of the path
	NSURL *instructionsURL = [NSURL fileURLWithPath:path];
	[webView loadRequest:[NSURLRequest requestWithURL:instructionsURL]];
    
	[super viewDidLoad];
}



-(IBAction)loadTerms:(id)sender
{
    webView.backgroundColor = [UIColor colorWithRed:148.0/256.0 green:148.0/256.0 blue:148.0/256.0 alpha:0.0];
	webView.opaque = YES;
    
    int selectedLang= [Fitness4MeUtils getApplicationLanguage];
    NSString *path;
	NSBundle *thisBundle = [NSBundle mainBundle];
    if (selectedLang ==2) {
        path = [thisBundle pathForResource:@"termsOfUseDe" ofType:@"html"];
    }else{
        path = [thisBundle pathForResource:@"termsofUse" ofType:@"html"];
    }
	NSURL *instructionsURL = [NSURL fileURLWithPath:path];
	[webView loadRequest:[NSURLRequest requestWithURL:instructionsURL]];
}



-(IBAction)loadPrivacypolicy:(id)sender
{
    
    webView.backgroundColor = [UIColor colorWithRed:148.0/256.0 green:148.0/256.0 blue:148.0/256.0 alpha:0.0];
    webView.opaque = YES;
    int selectedLang= [Fitness4MeUtils getApplicationLanguage];
    NSString *path;
    NSBundle *thisBundle = [NSBundle mainBundle];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (selectedLang ==2) {
            path = [thisBundle pathForResource:@"PrivacyPolicyDe" ofType:@"html"];
        }else{
            path = [thisBundle pathForResource:@"PrivacyPolicy" ofType:@"html"];
        }
        
    }
    else {
        if (selectedLang ==2) {
            path = [thisBundle pathForResource:@"PrivacyPolicyDeiPad" ofType:@"html"];
        }else{
            path = [thisBundle pathForResource:@"PrivacyPolicyiPad" ofType:@"html"];
        }

    }

    
   
    NSURL *instructionsURL = [NSURL fileURLWithPath:path];
    [webView loadRequest:[NSURLRequest requestWithURL:instructionsURL]];
    
}

#pragma mark view orientation Methods


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate {
    return NO;
}


@end
