//
//  MembershipRateViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 11/12/12.
//
//

#import <UIKit/UIKit.h>
#import "Workout.h"
#import "ShareFitness4MeViewController.h"
#import "CustomWorkoutsViewController.h"
#import "ListWorkoutsViewController.h"
#import "MembershipPurchaseViewController.h"
@interface MembershipRateViewController : UIViewController
{
    Workout * workout;
}
@property(strong,nonatomic)NSString *workoutType;
@property (retain,nonatomic)Workout *workout;
@property (retain,nonatomic)NSString *navigateTo;
@property (weak, nonatomic) IBOutlet UIButton *tellmeMoreButton;
@property (weak, nonatomic) IBOutlet UIButton *showMoreButton;
- (IBAction)onClickYes:(id)sender;
- (IBAction)onClickNotYet:(id)sender;
- (IBAction)onClickSkipToPurchase:(id)sender;
@end
