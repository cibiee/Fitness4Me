//
//  CustomWorkoutAddViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 03/12/12.
//
//

#import <UIKit/UIKit.h>
#include "FocusViewController.h"
@interface CustomWorkoutAddViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIPickerView *timePickerView;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

-(IBAction)onClickNext:(id)sender;
-(IBAction)onClickBack:(id)sender;
@end
