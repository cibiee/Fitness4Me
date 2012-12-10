//
//  WorkoutCreationCompletedViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 05/12/12.
//
//

#import "WorkoutCreationCompletedViewController.h"
#import "FitnessServerCommunication.h"
#import "CustomWorkoutIntermediateViewController.h"

@interface WorkoutCreationCompletedViewController ()

@end

@implementation WorkoutCreationCompletedViewController
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
    // add continue button
    UIButton *backutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backutton.frame = CGRectMake(0, 0, 58, 30);
    [backutton setBackgroundImage:[UIImage imageNamed:@"back_btn_with_text.png"] forState:UIControlStateNormal];
    [backutton addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:backutton];
    self.navigationBar.leftBarButtonItem = backBtn;
    

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getNewWorkoutList {
    Workout *newWorkout;
    WorkoutDB *workoutDB=[[WorkoutDB alloc]init];
    [workoutDB setUpDatabase];
    [workoutDB createDatabase];
    newWorkout =[[Workout alloc]init];
    newWorkout =[workoutDB getCustomWorkoutByID:[workout WorkoutID]];
    CustomWorkoutIntermediateViewController *viewController =[[CustomWorkoutIntermediateViewController alloc]initWithNibName:@"CustomWorkoutIntermediateViewController" bundle:nil];
    viewController.workout =[[Workout alloc]init];
    viewController .workout=newWorkout;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onClickLetsGo:(id)sender {
    
    [self.view addSubview:self.progressView];
    [self.activityIndicator startAnimating];
    
   
        NSUserDefaults *userInfo =[NSUserDefaults standardUserDefaults];
       
        userID=  [userInfo stringForKey:@"UserID"];
        userlevel =[userInfo stringForKey:@"Userlevel"];
        int  selectedLanguage=[Fitness4MeUtils getApplicationLanguage] ;
        FitnessServerCommunication *fitness= [FitnessServerCommunication sharedState];
        [fitness saveCustomWorkout:workout userID:userID userLevel:userlevel language:selectedLanguage activityIndicator:self.activityIndicator progressView:self.progressView onCompletion:^(NSString *workoutID) {
            if (workoutID>0) {
                [workout setWorkoutID:workoutID];
                [fitness  parseCustomFitnessDetails:[userID intValue]  onCompletion:^{
                    [self getNewWorkoutList];
                    
                } onError:^(NSError *error) {
                    // [self getExcersices];
                }];
            }
            
        }onError:^(NSError *error) {
            // [self getExcersices];
        }];
}




-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload {
    [self setNavigationBar:nil];
    [self setProgressView:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}
@end
