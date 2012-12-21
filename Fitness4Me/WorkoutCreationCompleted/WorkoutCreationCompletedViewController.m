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
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
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
    
    if ([[workout WorkoutID]intValue]>0) {
        [self.creationCompleteLabel setText:@"Save changes and start workout?"];
    }
    else
    {
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    NSString *hasMadeFullPurchase= [userinfo valueForKey:@"hasMadeFullPurchase"];
    if ([hasMadeFullPurchase isEqualToString:@"true"]) {
     [self.creationCompleteLabel setText:@"Congratulations!You just designed your customized workouts"];
    }
    else {
        int customCount= [userinfo integerForKey:@"customCount"]+1;
        NSString *customCountString;
        
        switch (customCount) {
            case 1:
                
                customCountString =@"first";
                break;
            case 2:
                
                customCountString =@"second";
                break;
            case 3:
                
                customCountString =@"third";
                break;
            case 4:
                
                customCountString =@"fourth";
                break;
            case 5:
                customCountString =@"last";
                break;
                
            default:
                break;
        }
        if ([customCountString length]>0) {
            [self.creationCompleteLabel setText:[NSString stringWithFormat:@"Congratulations!You just designed  the %@ of your five free customized workouts",customCountString]];
        }
    }
    }
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
    [viewController setNavigateBack:NO];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onClickLetsGo:(id)sender {
    
    [self.view addSubview:self.progressView];
    [self.activityIndicator startAnimating];
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
   
    
    userID=  [userinfo stringForKey:@"UserID"];
    userlevel =[userinfo stringForKey:@"Userlevel"];
    NSString *workoutType =[userinfo stringForKey:@"workoutType"];
    int  selectedLanguage=[Fitness4MeUtils getApplicationLanguage] ;
    FitnessServerCommunication *fitness= [FitnessServerCommunication sharedState];
    if ([workoutType isEqualToString:@"Custom"]) {
               [fitness saveCustomWorkout:workout userID:userID userLevel:userlevel language:selectedLanguage activityIndicator:self.activityIndicator progressView:self.progressView onCompletion:^(NSString *workoutID) {
            if (workoutID>0) {
                [workout setWorkoutID:workoutID];
                [fitness  parseCustomFitnessDetails:[userID intValue]  onCompletion:^(NSString *responseString){
                    [self getNewWorkoutList];
                    
                } onError:^(NSError *error) {
                    // [self getExcersices];
                }];
            }
            
        }onError:^(NSError *error) {
            // [self getExcersices];
        }];
    }
    else{
        
        [fitness saveSelfMadeWorkout:self.workoutName workoutCollection:self.collectionString workoutID:self.workoutID userID:userID userLevel:userlevel language:selectedLanguage activityIndicator:self.activityIndicator progressView:self.progressView onCompletion:^(NSString *responseString) {
            if (responseString>0) {
                [workout setWorkoutID:responseString];
                [fitness  parseSelfMadeFitnessDetails:[userID intValue]  onCompletion:^(NSString *responseString){
                   // [self getNewWorkoutList];
                    
                } onError:^(NSError *error) {
                    // [self getExcersices];
                }];
            }
            
        }onError:^(NSError *error) {
            // [self getExcersices];
        }];
    }
}




-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload {
    [self setNavigationBar:nil];
    [self setProgressView:nil];
    [self setActivityIndicator:nil];
    [self setCreationCompleteLabel:nil];
    [super viewDidUnload];
}
@end
