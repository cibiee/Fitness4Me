//
//  NameViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 04/12/12.
//
//

#import "NameViewController.h"
#import "FitnessServerCommunication.h"
#import "WorkoutCreationCompletedViewController.h"

@interface NameViewController ()

@end

@implementation NameViewController
@synthesize workout;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // add continue button
    UIButton *backutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backutton.frame = CGRectMake(0, 0, 58, 30);
    [backutton setBackgroundImage:[UIImage imageNamed:@"back_btn_with_text.png"] forState:UIControlStateNormal];
    [backutton addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:backutton];
    self.navigationBar.leftBarButtonItem = backBtn;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissKeyboard:(id)sender {
    
    [self.nameTextfield resignFirstResponder];
}
- (void)viewDidUnload {
    [self setNameTextfield:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
}
- (IBAction)onClickNext:(id)sender {
    if ([self.nameTextfield.text length]>0) {
      
        Workout *workouts= [[Workout alloc]init];
        [workouts setDuration:workout.Duration];
        [workouts setFocus:workout.Focus];
        [workouts setProps:workout.Props];
        [workouts setName:self.nameTextfield.text];
        
       
        

            WorkoutCreationCompletedViewController *viewController =[[WorkoutCreationCompletedViewController alloc]initWithNibName:@"WorkoutCreationCompletedViewController" bundle:nil];
            viewController.workout= [[Workout alloc]init];
            viewController.workout =workouts;
            [self.navigationController pushViewController:viewController animated:YES];
            
                
    }
    else
    {
        [Fitness4MeUtils showAlert:@"Please Provide a Name for the workout"];
    }
    
    
}

-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return NO;
}

@end
