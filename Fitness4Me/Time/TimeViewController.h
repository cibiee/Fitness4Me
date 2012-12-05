//
//  TimeViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 03/12/12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include "FocusViewController.h"
#import "Workout.h"

@interface TimeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIPickerView *timePickerView;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (strong, nonatomic)Workout *workout;
-(IBAction)onClickNext:(id)sender;
-(IBAction)onClickBack:(id)sender;

@end
