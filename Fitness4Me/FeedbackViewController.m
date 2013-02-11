//
//  FeedbackViewController.m
//  Fitness4Me
//
//  Created by Ciby K Jose on 20/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FeedbackViewController.h"
#import "Fitness4MeViewController.h"
#import "ASIFormDataRequest.h"

@interface FeedbackViewController ()

@end

#define kOFFSET_FOR_KEYBOARD 100;

@implementation FeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (IBAction)sendFeedBack:(id)sender
{
    if ([feedbackTextView.text  length]>0) {
        
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        NSString *username= [userinfo  stringForKey:@"Username"];
        NSString *email= [userinfo  stringForKey:@"email"];
        FitnessServerCommunication *fitness= [FitnessServerCommunication sharedState];
        [fitness sendFeedback:feedbackTextView.text byUser:username email:email onCompletion:^(NSString *status) {
            if ([status isEqualToString:@"sent"] ){
                [self navigateToHome];
            }
        }
                      onError:^(NSError *error) {
                          
                      }];
    }else{
        [Fitness4MeUtils showAlert:NSLocalizedStringWithDefaultValue(@"nullfeedbackmsg", nil,[Fitness4MeUtils getBundle], nil, nil)];
    }
    
}

-(void)navigateToHome
{
    ThanksViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[ThanksViewController alloc]initWithNibName:@"ThanksViewController" bundle:nil];
    }else{
        viewController =[[ThanksViewController alloc]initWithNibName:@"ThanksViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}


#pragma mark -setViewMovedUp


-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect rect = self.view.frame;
    if (movedUp){
        if (rect.origin.y == 0 ) {
            rect.origin.y -= kOFFSET_FOR_KEYBOARD;
            
        }
    }else{
        if (stayup == NO) {
            rect.origin.y += kOFFSET_FOR_KEYBOARD;
        }
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}


#pragma mark -textfieldDelgates


- (BOOL)textViewShouldReturn:(UITextField *)textView
{
    [textView resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self setViewMovedUp:YES];
    stayup = NO;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self setViewMovedUp:NO];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];}
    return YES;
}


#pragma mark -DismissKeyboardAway

-(IBAction)dismissKeyboardAway
{
    [feedbackTextView resignFirstResponder];
}

-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

-(BOOL)shouldAutorotate {
    return NO;
}

@end
