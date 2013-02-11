//
//  HintsViewController.m
//  Fitness4Me
//
//  Created by Ciby on 04/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HintsViewController.h"

@interface HintsViewController ()

@end

@implementation HintsViewController

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
    
    [self loadhints];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}


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
            path = [thisBundle pathForResource:@"Hintspage" ofType:@"html"];
        }
        else
        {
            path = [thisBundle pathForResource:@"hintsandTips_de" ofType:@"html"];
        }

        
    }
    else {
        if (selectedLang ==1) {
            path = [thisBundle pathForResource:@"HintspageiPad" ofType:@"html"];
        }
        else
        {
            path = [thisBundle pathForResource:@"hintsandTips_deiPad" ofType:@"html"];
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
