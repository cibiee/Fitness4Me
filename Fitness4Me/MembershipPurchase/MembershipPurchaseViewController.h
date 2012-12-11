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


@interface MembershipPurchaseViewController : UIViewController
{
    Workout * workout;
}
@property (retain,nonatomic)Workout *workout;
- (IBAction)onClickQuit:(id)sender;

@end
