//
//  CustomWorkoutsViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 28/11/12.
//
//

#import <UIKit/UIKit.h>
#import "CustomCellContentController.h"
#import "TimeViewController.h"
#import "CustomWorkoutAddViewController.h"

@interface CustomWorkoutsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

-(IBAction)onClickEdit:(id)sender;
-(IBAction)onClickBack:(id)sender;
-(IBAction)onClickAdd:(id)sender;

@end
