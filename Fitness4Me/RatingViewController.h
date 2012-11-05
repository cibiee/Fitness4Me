//
//  RatingViewController.h
//  Fitness4Me
//
//  Created by Ciby K Jose on 20/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fitness4MeViewController.h"
#import "FeedbackViewController.h"

@interface RatingViewController : UIViewController
{
    
}


-(IBAction)ratetheApp:(id)sender;
-(IBAction)dontRatetheApp:(id)sender;
-(IBAction)remindMeLater:(id)sender;
-(IBAction)navigateTofeedback;


@end
