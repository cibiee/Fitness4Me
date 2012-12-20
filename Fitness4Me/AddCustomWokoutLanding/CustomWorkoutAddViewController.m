//
//  CustomWorkoutAddViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 03/12/12.
//
//

#import "CustomWorkoutAddViewController.h"
#import "WorkoutDB.h"
#import "Fitness4MeUtils.h"

@interface CustomWorkoutAddViewController ()
@property (strong,nonatomic)NSString *oncePlace;
@property(strong,nonatomic)NSString *tensPlace;
@property(strong,nonatomic)NSString *duration;
@property(strong,nonatomic)NSString *workoutID;
@property(strong,nonatomic)NSMutableArray *timeArray;
@end

@implementation CustomWorkoutAddViewController
@synthesize workout;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark private method

- (void)setTabbarItems
{
    UIButton *backutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backutton.frame = CGRectMake(0, 0, 58, 30);
    [backutton setBackgroundImage:[UIImage imageNamed:@"back_btn_with_text.png"] forState:UIControlStateNormal];
    [backutton addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:backutton];
    self.navigationBar.leftBarButtonItem = backBtn;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0, 0, 58, 30);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"next_btn_with_text.png"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(onClickNext:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    self.navigationBar.rightBarButtonItem = nextBtn;
}


- (void)setDuration
{
    self.timeArray =[[NSMutableArray alloc]initWithObjects:@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55",@"60", nil];
    
    if ([[workout WorkoutID] integerValue]>0 ) {
        
        int duration = [[workout Duration]intValue];
        self.duration= [workout Duration];
        int tensplace= duration/5;
        self.workoutID =[workout WorkoutID];
        [self.timePickerView selectRow:tensplace-1 inComponent:0 animated:YES];
        
        [self.editLabel setHidden:NO];
        [self.nameLabel setText:[workout Name]];
        [self.nameLabel setHidden:NO];
        [self.addWorkoutLabel setHidden:YES];
    }
    else
    {
        [self.timePickerView selectRow:0 inComponent:0 animated:YES];
        self.duration= @"5";
    }
}


#pragma mark view overriden method

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.nameLabel setHidden:YES];
    [self.editLabel setHidden:YES];
    [self setTabbarItems];
    [self setDuration];
}

- (void)viewDidUnload {
    [self setTimePickerView:nil];
    [self setNavigationBar:nil];
    [self setNavigationBar:nil];
    [self setAddWorkoutLabel:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark pickerview delegate  method
//PickerViewController.m
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.timeArray count];
    
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return  [self.timeArray objectAtIndex:row];
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 230, 37)];
    label.text = [NSString stringWithFormat:@"%@",[self.timeArray objectAtIndex:row]];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font=[UIFont systemFontOfSize:30];
    return label;
}

//PickerViewController.m
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    self.duration = [self.timeArray objectAtIndex:row];
}

#pragma mark -
#pragma mark instance method


-(IBAction)onClickNext:(id)sender
{
    Workout *workouts= [[Workout alloc]init];
    if ([self.workoutID intValue]>0) {
        WorkoutDB *workoutDB =[[WorkoutDB alloc]init];
        [workoutDB setUpDatabase];
        [workoutDB createDatabase];
        workouts =[workoutDB getCustomWorkoutByID:self.workoutID];
    }
    
    [workouts setDuration:self.duration];
    FocusViewController *viewController =[[FocusViewController alloc]initWithNibName:@"FocusViewController" bundle:nil];
    viewController.workout =[[Workout alloc]init];
    viewController .workout=workouts;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
