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
#import "CustomWorkoutsViewController.h"

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
    
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    NSString *isMember =[userinfo valueForKey:@"isMember"];
    self.workoutType =[userinfo stringForKey:@"workoutType"];
    // add continue button
    UIButton *backutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backutton.frame = CGRectMake(0, 0, 58, 30);
    [backutton setBackgroundImage:[UIImage imageNamed:@"back_btn_with_text.png"] forState:UIControlStateNormal];
    [backutton addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:backutton];
    self.navigationBar.leftBarButtonItem = backBtn;
    
    if ([[workout WorkoutID]intValue]>0) {
        [self.creationCompleteLabel setText:NSLocalizedString(@"editMessage", nil)];
    }
    else
    {
        
        if ([isMember isEqualToString:@"true"]) {
            if ([self.workoutType isEqualToString:@"SelfMade"]) {
                [self.creationCompleteLabel  setText:@"You just designed your selfmade workout"];
            }
            else
            {
                [self.creationCompleteLabel  setText:@"You just designed your custom workout"];
            }
            
        }
        else
        {
            
            if ([self.workoutType isEqualToString:@"SelfMade"]) {
                [self.creationCompleteLabel setText:@"You just designed your selfmade workout"];
            }
            else
            {
                
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
                    
                    NSString *msg= NSLocalizedString(@"creationCustomizedCompleteMsg", nil);
                    [self.creationCompleteLabel setText:[NSString stringWithFormat:msg,customCountString]];
                }
            }
        }
    }
    
    self.saveandStartbutton.titleLabel.textAlignment=UITextAlignmentCenter;
    self.saveandStartbutton.titleLabel.lineBreakMode=UILineBreakModeCharacterWrap;
    
    
    
    
    if ([self.workoutType isEqualToString:@"SelfMade"])
    {
        if ([isMember isEqualToString:@"true"]) {
            [self.saveToListButton setHidden:NO];
        }
        else{
            [self.saveToListButton setHidden:YES];
            [self.saveandStartbutton setFrame:CGRectMake(86, 290,125 , 78)];
            
        }
    }
    
    self.saveToListButton.titleLabel.textAlignment=UITextAlignmentCenter;
    self.saveToListButton.titleLabel.lineBreakMode=UILineBreakModeCharacterWrap;
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
    if ([self.workoutType isEqualToString:@"Custom"]){
        newWorkout =[workoutDB getCustomWorkoutByID:self.workoutID];
    }else{
        newWorkout=[workoutDB getSelfMadeByID:self.workoutID];
    }
    CustomWorkoutIntermediateViewController *viewController =[[CustomWorkoutIntermediateViewController alloc]initWithNibName:@"CustomWorkoutIntermediateViewController" bundle:nil];
    viewController.workout =[[Workout alloc]init];
    viewController .workout=newWorkout;
    [viewController setNavigateBack:NO];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)NavigateToWorkoutList {
    
    
    CustomWorkoutsViewController *viewController =[[CustomWorkoutsViewController alloc]initWithNibName:@"CustomWorkoutsViewController" bundle:nil];
    if ([self.workoutType isEqualToString:@"Custom"]){
        [viewController setWorkoutType:@"Custom"];
    }
    else
    {
        [viewController setWorkoutType:@"SelfMade"];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)saveWorkoutsandNavigateTo:(NSString*)navigateTo {
    [self.view addSubview:self.progressView];
    [self.activityIndicator startAnimating];
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    
    
    userID=  [userinfo stringForKey:@"UserID"];
    userlevel =[userinfo stringForKey:@"Userlevel"];
    self.workoutType =[userinfo stringForKey:@"workoutType"];
    int  selectedLanguage=[Fitness4MeUtils getApplicationLanguage] ;
    FitnessServerCommunication *fitness= [FitnessServerCommunication sharedState];
    if ([self.workoutType isEqualToString:@"Custom"]) {
        [fitness saveCustomWorkout:workout userID:userID userLevel:userlevel language:selectedLanguage activityIndicator:self.activityIndicator progressView:self.progressView onCompletion:^(NSString *workoutID) {
            if (workoutID>0) {
               
                
                [workout setWorkoutID:workoutID];
                self.workoutID=workoutID;
                [fitness  parseCustomFitnessDetails:[userID intValue]  onCompletion:^(NSString *responseString){
                    
                    
                } onError:^(NSError *error) {
                    // [self getExcersices];
                }];
            }
            
        }onError:^(NSError *error) {
            // [self getExcersices];
        }];
        
        if ([navigateTo isEqualToString:@"List"]) {
            [self NavigateToWorkoutList];
        }
        else
        {
            [self getNewWorkoutList];
        }
    }
    else{
        [fitness saveSelfMadeWorkout:self.workoutName workoutCollection:self.collectionString workoutID:self.workoutID userID:userID userLevel:userlevel language:selectedLanguage focus:self.focusList equipments:self.equipments activityIndicator:self.activityIndicator progressView:self.progressView onCompletion:^(NSString *workoutID) {
            if (workoutID>0) {
                [workout setWorkoutID:workoutID];
                
                self.workoutID=workoutID;
                NSString *trail;
                NSString *isMember =[userinfo valueForKey:@"isMember"];
                if ([isMember isEqualToString:@"true"]) {
                    trail=@"0";
                }
                else{
                    
                    int trailCount =[userinfo integerForKey:@"trailCount"];
                    if (trailCount==0) {
                        trail=@"1";
                    }
                    else{
                        trail=@"0";
                        
                    }
                    
                    trailCount++;
                    [userinfo setInteger:trailCount forKey:@"trialCount"];
                }
                GlobalArray =[[NSMutableArray alloc]init];
                [userinfo setObject:@"" forKey:@"SelectedWorkouts"];
                [fitness  parseSelfMadeFitnessDetails:[userID intValue] trail:trail onCompletion:^(NSString *responseString){
                    if ([navigateTo isEqualToString:@"List"]) {
                        [self NavigateToWorkoutList];
                    }
                    else
                    {
                        [self getNewWorkoutList];
                    }
                    
                    
                    
                } onError:^(NSError *error) {
                    // [self getExcersices];
                }];
            }
            
        }onError:^(NSError *error) {
            // [self getExcersices];
        }];
        
    }
}

- (IBAction)onClickLetsGo:(id)sender {
    
    [self saveWorkoutsandNavigateTo:@"videoPlay"];
}

- (IBAction)savetoList:(id)sender{
    [self saveWorkoutsandNavigateTo:@"List"];
}


-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload {
    [self setNavigationBar:nil];
    [self setProgressView:nil];
    [self setActivityIndicator:nil];
    [self setCreationCompleteLabel:nil];
    [self setSaveToListButton:nil];
    [self setSaveandStartbutton:nil];
    [super viewDidUnload];
}
@end
