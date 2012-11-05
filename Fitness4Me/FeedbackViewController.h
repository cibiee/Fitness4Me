//
//  FeedbackViewController.h
//  Fitness4Me
//
//  Created by Ciby K Jose on 20/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "ThanksViewController.h"

@interface FeedbackViewController : UIViewController
{
    IBOutlet UITextView *feedbackTextView;
    
    Boolean *stayup;
}

-(IBAction)sendFeedBack:(id)sender;

-(IBAction)onClickBack:(id)sender;
@end
