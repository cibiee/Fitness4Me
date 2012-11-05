//
//  Fitness4MeViewController.h
//  Fitness4Me
//
//  Created by Ciby K Jose on 05/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListWorkoutsViewController.h"
#import "AboutViewController.h"
#import "HintsViewController.h"
#import "SettingsViewController.h"
#import "GADBannerView.h"
#import <QuartzCore/QuartzCore.h>


@interface Fitness4MeViewController : UIViewController<FitnessServerCommunicationDelegate>

{
     GADBannerView *bannerView_;
    IBOutlet UIButton *hintsAdviceButton;
    NSString *dataPath ;
    
    IBOutlet UIView *SyncView;
    
    IBOutlet UIProgressView *fileDownloadProgressView;
    
    IBOutlet UIActivityIndicatorView *activityindicators;
    IBOutlet UILabel *lblCompleted;
    ///IBOutlet UITextView freeDownload


}
-(IBAction)cancelDownloas:(id)sender;

-(IBAction)navigateToWorkoutListView:(id)sender;
-(IBAction)navigateToAboutView:(id)sender;
-(IBAction)navigateToSettingsView:(id)sender;
-(IBAction)navigateToHintstView:(id)sender;

@end
