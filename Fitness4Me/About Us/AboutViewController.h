//
//  AboutViewController.h
//  Fitness4Me
//
//  Created by Ciby on 04/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fitness4MeViewController.h"
#import "GADBannerView.h"

@interface AboutViewController : UIViewController
{
     GADBannerView *bannerView_;
    IBOutlet UIWebView *webView;
}
-(IBAction)navigateToHome;
-(IBAction)loadAboutUs;
-(IBAction)loadTerms:(id)sender;
-(IBAction)loadPrivacypolicy:(id)sender;
@end
