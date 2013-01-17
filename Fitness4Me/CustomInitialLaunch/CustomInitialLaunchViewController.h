//
//  CustomInitialLaunchViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 15/01/13.
//
//

#import <UIKit/UIKit.h>

@interface CustomInitialLaunchViewController : UIViewController
@property BOOL checkboxSelected;
@property (weak, nonatomic) IBOutlet UIButton *dontShowButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
- (IBAction)onClickDontShow:(id)sender;
@end
