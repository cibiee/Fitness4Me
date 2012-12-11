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

@interface MemberPromoViewController : UIViewController
{
     Workout * workout;
}
@property (retain,nonatomic)Workout *workout;
- (IBAction)onClickTellMeMore:(id)sender;
- (IBAction)onClickNotYet:(id)sender;

@end
