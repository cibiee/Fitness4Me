//
//  CustomWorkoutAddViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 03/12/12.
//
//

#import "CustomWorkoutAddViewController.h"
#import "WorkoutDB.h"

@interface CustomWorkoutAddViewController ()
@property (strong,nonatomic)NSString *oncePlace;
@property(strong,nonatomic)NSString *tensPlace;
@property(strong,nonatomic)NSString *duration;
@property(strong,nonatomic)NSString *workoutID;
@end

@implementation CustomWorkoutAddViewController
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
    
    if ([[workout WorkoutID] integerValue]>0 ) {
    
        int duration = [[workout Duration]intValue];
        int onceplace = duration % 10;
        int tensplace= duration/10;
        self.tensPlace =[NSString stringWithFormat:@"%i",tensplace];
        self.oncePlace=[NSString stringWithFormat:@"%i",onceplace];
        self.workoutID =[workout WorkoutID];
        [self.timePickerView selectRow:tensplace-1 inComponent:0 animated:YES];
        [self.timePickerView selectRow:onceplace inComponent:1 animated:YES];
    }
    else
    {
        self.tensPlace =[NSString stringWithFormat:@"%i",1];
        self.oncePlace=[NSString stringWithFormat:@"%i",0];
        [self.timePickerView selectRow:0 inComponent:0 animated:YES];
        [self.timePickerView selectRow:0 inComponent:1 animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//PickerViewController.m
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component==0) {
        return 5;
    }
    else{
        return  10;
        
    }
    
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component==0) {
        return  [NSString stringWithFormat:@"%i", row+1];
        
    }
    else{
        return  [NSString stringWithFormat:@"%i", row];
    }
    
}

//PickerViewController.m
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
        if (component==0) {
            self.tensPlace = ([NSString stringWithFormat:@"%i", row+1]);
    
       }
       else{
           self.oncePlace = ([NSString stringWithFormat:@"%i", row]);
    
       }
    
   }



-(IBAction)onClickNext:(id)sender
{
    self.duration =[self.tensPlace stringByAppendingString:self.oncePlace];
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

- (void)viewDidUnload {
    [self setTimePickerView:nil];
    [self setNavigationBar:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
}

@end
