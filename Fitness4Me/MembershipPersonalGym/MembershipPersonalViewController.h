//
//  MembershipPersonalViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 03/01/13.
//
//

#import <UIKit/UIKit.h>
#import "Workout.h"
#import "ShareFitness4MeViewController.h"
#import "CustomWorkoutsViewController.h"

@interface MembershipPersonalViewController : UIViewController

@property (retain,nonatomic)Workout *workout;
@property (retain,nonatomic)NSString *navigateTo;

- (IBAction)onClickNotYet:(id)sender;
- (IBAction)onClickShowYouTube:(id)sender;
- (IBAction)onClickTellMeMore:(id)sender;

@end
