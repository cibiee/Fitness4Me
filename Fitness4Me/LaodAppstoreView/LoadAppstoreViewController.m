//
//  LoadAppstoreViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 10/10/12.
//
//

#import "LoadAppstoreViewController.h"

@interface LoadAppstoreViewController ()

@end

@implementation LoadAppstoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     rateView= [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
     [rateView setDelegate:self];
    
    NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
    str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
    str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
    
    // Here is the app id from itunesconnect
    str = [NSString stringWithFormat:@"%@533403096", str];
    
    NSString *urlAddress =str;
    NSURL *url = [NSURL URLWithString:[urlAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [rateView loadRequest:requestObj];
    
    [self.view addSubview:rateView];

    // Do any additional setup after loading the view from its nib.
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType;
{
    NSURL *loadURL = [request URL] ;
   // NSLog(@"%@",loadURL);
    if([[loadURL absoluteString] hasPrefix:@"http://"])
    {
       
        return TRUE;
    }
    
    return FALSE;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
