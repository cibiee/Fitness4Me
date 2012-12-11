//
//  CustomWokoutPostplayViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 11/12/12.
//
//

#import <UIKit/UIKit.h>
#import "Workout.h"
#import "GADBannerView.h"

@interface CustomWokoutPostplayViewController : UIViewController
{
    Workout * workout;
    GADBannerView *bannerView_;
}
@property (retain,nonatomic)Workout *workout;

- (IBAction)onClickDoAnotherWokout:(id)sender;
- (IBAction)onClickCOntinue:(id)sender;

@end
