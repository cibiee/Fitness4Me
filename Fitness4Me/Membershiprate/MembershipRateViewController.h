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


@interface MembershipRateViewController : UIViewController
{
    Workout * workout;
}
@property (retain,nonatomic)Workout *workout;
- (IBAction)onClickYes:(id)sender;
- (IBAction)onClickNotYet:(id)sender;

@end
