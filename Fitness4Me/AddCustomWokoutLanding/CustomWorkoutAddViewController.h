//
//  CustomWorkoutAddViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 03/12/12.
//
//

#import <UIKit/UIKit.h>
#import  "FocusViewController.h"
#import "Workout.h"

@interface CustomWorkoutAddViewController : UIViewController
{
    Workout *workout;
    
}
@property (weak, nonatomic) IBOutlet UIPickerView *timePickerView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UILabel *addWorkoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *editLabel;
@property (strong, nonatomic)Workout *workout;

-(IBAction)onClickNext:(id)sender;
-(IBAction)onClickBack:(id)sender;
@end
