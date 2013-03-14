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
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    // add continue button
    UIButton *backutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backutton.frame = CGRectMake(0, 0, 58, 30);
    [backutton setBackgroundImage:[UIImage imageNamed:@"back_btnBlack.png"] forState:UIControlStateNormal];
    [backutton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [backutton.titleLabel setTextAlignment:UITextAlignmentRight];
     [backutton setTitle:NSLocalizedStringWithDefaultValue(@"back", nil,[Fitness4MeUtils getBundle], nil, nil) forState:UIControlStateNormal];
    [backutton addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:backutton];
    self.navigationBar.leftBarButtonItem = backBtn;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0, 0, 58, 30);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"next_btn_with_text.png"] forState:UIControlStateNormal];
    
    [nextButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [nextButton.titleLabel setTextAlignment:UITextAlignmentRight];
    [nextButton setTitle:NSLocalizedStringWithDefaultValue(@"next", nil,[Fitness4MeUtils getBundle], nil, nil) forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(onClickNext:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    self.navigationBar.rightBarButtonItem = nextBtn;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.nameTextfield setText:self.name];
    
   
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
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        NSString *workoutType =[userinfo stringForKey:@"workoutType"];
        if ([workoutType isEqualToString:@"Custom"]){
            Workout *workouts= [[Workout alloc]init];
           
            if ([[workout WorkoutID]intValue]>0) {
                WorkoutDB *workoutDB =[[WorkoutDB alloc]init];
                [workoutDB setUpDatabase];
                [workoutDB createDatabase];
                 workouts =[workoutDB getCustomWorkoutByID:[workout WorkoutID]];
                [workouts  setWorkoutID:[workout WorkoutID]];
                
                
            }
            [workouts setDuration:workout.Duration];
            [workouts setFocus:workout.Focus];
            [workouts setProps:workout.Props];
            [workouts setName:self.nameTextfield.text];
            WorkoutCreationCompletedViewController *viewController;
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
                viewController = [[WorkoutCreationCompletedViewController alloc]initWithNibName:@"WorkoutCreationCompletedViewController" bundle:nil];
            }
            else {
                viewController = [[WorkoutCreationCompletedViewController alloc]initWithNibName:@"WorkoutCreationCompletedViewController_iPad" bundle:nil];
            }

            
            viewController.workout= [[Workout alloc]init];
            viewController.workout =workouts;
              
            [self.navigationController pushViewController:viewController animated:YES];
        }else{
            WorkoutCreationCompletedViewController *viewController;
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
                viewController = [[WorkoutCreationCompletedViewController alloc]initWithNibName:@"WorkoutCreationCompletedViewController" bundle:nil];
            }
            else {
                viewController = [[WorkoutCreationCompletedViewController alloc]initWithNibName:@"WorkoutCreationCompletedViewController_iPad" bundle:nil];
            }
            

           
            [viewController setWorkoutName:self.nameTextfield.text];
            [viewController setCollectionString:self.collectionString];
            
            [viewController setWorkoutID:[workout WorkoutID]];
            [viewController setEquipments:self.equipments];
            
            viewController.workout= [[Workout alloc]init];
            if ([[workout WorkoutID]intValue]>0)
                [viewController.workout setWorkoutID:[workout WorkoutID]];

            [viewController setFocusList:self.focusList];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }else{
        [Fitness4MeUtils showAlert:NSLocalizedStringWithDefaultValue(@"NameNull", nil,[Fitness4MeUtils getBundle], nil, nil)];
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
