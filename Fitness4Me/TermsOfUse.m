//
//  TermsOfUse.m
//  Fitness4Me
//
//  Created by Ciby on 11/09/12.
//
//

#import "TermsOfUse.h"
#import "Fitness4MeUtils.h"
#import "InitialAppLaunchViewController.h"

@interface TermsOfUse ()

@end

@implementation TermsOfUse

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
    if (selectedLang ==2) {
        path = [thisBundle pathForResource:@"termsOfUseDe" ofType:@"html"];
    }
    else
    {
        path = [thisBundle pathForResource:@"termsofUse" ofType:@"html"];
    }
	// make a file: URL out of the path
	NSURL *instructionsURL = [NSURL fileURLWithPath:path];
	[webView loadRequest:[NSURLRequest requestWithURL:instructionsURL]];

}


-(void)navigateToHome
{
    InitialAppLaunchViewController *viewController =[[InitialAppLaunchViewController alloc]initWithNibName:@"InitialAppLaunchViewController" bundle:nil];
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
