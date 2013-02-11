//
//  MemverRateViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 03/01/13.
//
//

#import <UIKit/UIKit.h>
#import "Workout.h"
#import "ShareFitness4MeViewController.h"
#import "CustomWorkoutsViewController.h"
#import "ListWorkoutsViewController.h"
@interface MemverRateViewController : UIViewController
@property(strong,nonatomic)NSString *workoutType;
@property (retain,nonatomic)Workout *workout;
@property (retain,nonatomic)NSString *navigateTo;
@property (weak, nonatomic) IBOutlet UIButton *tellmeMoreButton;
@property (weak, nonatomic) IBOutlet UIButton *showMoreButton;
- (IBAction)onClickNotYet:(id)sender;
- (IBAction)onClickShowYouTube:(id)sender;
- (IBAction)onClickTellMeMore:(id)sender;
- (IBAction)onClickSkipToPurchase:(id)sender;

@end
