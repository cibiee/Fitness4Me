//
//  NameViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 04/12/12.
//
//

#import <UIKit/UIKit.h>
#import "Workout.h"
#import "Fitness4MeUtils.h"


@interface NameViewController : UIViewController
{
    Workout *workout;
}

@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (strong, nonatomic)Workout *workout;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)onClickNext:(id)sender;
- (IBAction)onClickBack:(id)sender;

@end
