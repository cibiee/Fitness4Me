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
#import "CustomWorkoutsViewController.h"
#import "CarouselViewDemoViewController.h"
#import <StoreKit/StoreKit.h>

@interface Fitness4MeViewController : UIViewController<FitnessServerCommunicationDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver>

{
     GADBannerView *bannerView_;
    IBOutlet UIButton *hintsAdviceButton;
     IBOutlet UIImageView *ladyImageView;
    IBOutlet UIView *buttonContainerView;
    NSString *dataPath ;
    NSString* remainisgDays;
    IBOutlet UIView *SyncView;
    
    IBOutlet UIProgressView *fileDownloadProgressView;
    
    IBOutlet UIActivityIndicatorView *activityindicators;
    IBOutlet UILabel *lblCompleted;
    ///IBOutlet UITextView freeDownload

    SKProduct *proUpgradeProduct;
    SKProduct *product;
    NSString *productIdentifier;
    SKProductsRequest *productsRequest;
}
@property (nonatomic, retain) IBOutlet CarouselViewDemoViewController *viewController;
-(IBAction)onclickSelfMadeworkout:(id)sender;
-(IBAction)cancelDownloas:(id)sender;
-(IBAction)navigateToCustomWorkoutListView:(id)sender;
-(IBAction)navigateToWorkoutListView:(id)sender;
-(IBAction)navigateToAboutView:(id)sender;
-(IBAction)navigateToSettingsView:(id)sender;
-(IBAction)navigateToHintstView:(id)sender;

@end
