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

@interface FocusViewController : UIViewController

@property (strong, nonatomic)  FocusDB *focusDB;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *focusTableView;
-(IBAction)onClickNext:(id)sender;
-(IBAction)onClickBack:(id)sender;
@end
