//
//  MembershipPurchaseViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 11/12/12.
//
//

#import <UIKit/UIKit.h>
#import "Workout.h"
#import "ShareFitness4MeViewController.h"
#import "ListWorkoutsViewController.h"

@interface MembershipPurchaseViewController : UIViewController
{
    Workout * workout;
}
@property(strong,nonatomic)NSString *workoutType;
@property (retain,nonatomic)Workout *workout;
@property (retain,nonatomic)NSString *navigateTo;
- (IBAction)onClickQuit:(id)sender;

@end
