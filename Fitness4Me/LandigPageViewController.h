//
//  LandigPageViewController.h
//  Fitness4Me
//
//  Created by Ciby on 01/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LandigPageViewController : UIViewController
{
IBOutlet UITextView *textView;
}

-(IBAction)onNavigateToUserRegistration:(id)sender;

-(IBAction)onNavigateToHomeView:(id)sender;

@end
