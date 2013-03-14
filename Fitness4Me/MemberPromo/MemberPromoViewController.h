//
//  MemberPromoViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 11/12/12.
//
//

#import <UIKit/UIKit.h>
#import "Workout.h"
#import "ShareFitness4MeViewController.h"
#import "MembershipRateViewController.h"
#import "FitnessDemoViewController.h"

@interface MemberPromoViewController : UIViewController
{
     Workout * workout;
}
@property (retain,nonatomic)Workout *workout;
@property (retain,nonatomic)NSString *navigateTo;
@property(strong,nonatomic)NSString *workoutType;
@property (weak, nonatomic) IBOutlet UIButton *showMoreButton;
- (IBAction)onClickTellMeMore:(id)sender;
- (IBAction)onClickNotYet:(id)sender;
- (IBAction)onClickShowVideo:(id)sender;

- (IBAction)onClickSkipToPurchase:(id)sender;
@end
