//
//  FocusViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 29/11/12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FocusDB.h"
#import "Focus.h"
#import "Workout.h"

@interface FocusViewController : UIViewController
{
    Workout *workout;
}

@property (strong, nonatomic)  FocusDB *focusDB;
@property (retain, nonatomic)Workout *workout;
@property (strong, nonatomic) Focus *focus;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *focusTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


-(IBAction)onClickNext:(id)sender;
-(IBAction)onClickBack:(id)sender;
@end
