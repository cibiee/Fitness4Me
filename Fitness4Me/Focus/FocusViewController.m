//
//  FocusViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 29/11/12.
//
//

#import "FocusViewController.h"
#import "EquipmentViewController.h"
#import "WorkoutDB.h"
#import "FitnessServerCommunication.h"

@interface FocusViewController ()
@property NSMutableArray *muscles;
@end

@implementation FocusViewController
@synthesize workout;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
         userinfo=[NSUserDefaults standardUserDefaults];
    }
    return self;
}



- (void)viewDidLoad
{
    
     
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

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
    
    // NSLog(workout.Duration);
    [self.focusTableView.layer setCornerRadius:8];
    [self.focusTableView.layer setBorderColor:[[UIColor blackColor]CGColor]];
    [self.focusTableView.layer setBorderWidth:2];
    
    [self.activityIndicator startAnimating];
    [NSThread detachNewThreadSelector:@selector(listfocus) toTarget:self withObject:nil];
}


-(void)viewDidAppear:(BOOL)animated{
    [self.focusTableView reloadData];
}



-(void)listfocus
{
      self.focusDB =[[FocusDB alloc]init];
    [ self.focusDB setUpDatabase];
    [ self.focusDB createDatabase];
    
    [self.focusDB getFocus];
    
    if ([ self.focusDB.muscles count]>0) {
        
        
        if ([[self.workout WorkoutID]intValue]>0) {
            [self.workout setFocus:[self getfocusIDs:self.focusDB.muscles]];
             self.muscles = [self prepareTableView:self.focusDB.muscles];
            
        }
        else{
            
            self.muscles =self.focusDB.muscles;
            NSString *selectedWorkouts = [userinfo objectForKey:@"Selectedfocus"];
            if ([selectedWorkouts length]>0) {

            self.muscles = [self prepareData:self.focusDB.muscles];
            }

        }
        
       
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidesWhenStopped:YES];
    }
    
    else{
        FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
        [fitness listfocus:self.activityIndicator progressView:nil onCompletion:^(NSString *responseString) {
            [self listfocus];}
         onError:^(NSError *error) {
            
        }];

    }
     
}

-(NSMutableArray*)prepareData:(NSMutableArray *)excersicelist {
    
    NSString *selectedWorkouts = [userinfo objectForKey:@"Selectedfocus"];
    NSArray* foo = [selectedWorkouts componentsSeparatedByString: @","];
        
    NSMutableArray *newfocusArray=[[NSMutableArray alloc]init];
    newfocusArray=excersicelist;
    for (int k=0; k<foo.count; k++) {
        for (int i=0; i<excersicelist.count; i++) {
            if([[[excersicelist objectAtIndex:i] muscleID] isEqualToString:[foo objectAtIndex:k]] ){
                [[newfocusArray objectAtIndex:i] setIsChecked:YES];
                break;
            }
        }
    }
    
    return newfocusArray;
}


-(NSString *)getfocusIDs:(NSMutableArray *)focuslist
{
    NSArray* foo = [[workout Focus] componentsSeparatedByString: @","];
    
    //NSLog(@"%@",[workout Focus]);
    
    NSString *str=[[NSString alloc]init];
    
    for (int k=0; k<foo.count; k++) {
        
        for (int i=0; i<focuslist.count; i++) {
            if([[[focuslist objectAtIndex:i] muscleName] isEqualToString:[foo objectAtIndex:k]] ){
                if ([str length]==0) {
                    str =[str stringByAppendingString:[[focuslist objectAtIndex:i] muscleID]];
                }
                else{
                    str=[str stringByAppendingString:@","];
                    str =[str stringByAppendingString:[[focuslist objectAtIndex:i] muscleID]];
                }

                
                break;
            }
            
            
        }
        
    }
    return str;
}





-(NSMutableArray*)prepareTableView:(NSMutableArray *)focuslist {
    
    NSArray* foo = [[workout Focus] componentsSeparatedByString: @","];
       
   
    
    NSMutableArray *newfocusArray=[[NSMutableArray alloc]init];
    newfocusArray=focuslist;
    for (int k=0; k<foo.count; k++) {
        
        for (int i=0; i<focuslist.count; i++) {
           
            if([[[focuslist objectAtIndex:i] muscleID] isEqualToString:[foo objectAtIndex:k]] ){
                [[newfocusArray objectAtIndex:i] setIsChecked:YES];
                 
                break;
            }
            
            
        }
        
    }
    return newfocusArray;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.muscles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:@"Cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    self.focus=[self.muscles objectAtIndex:indexPath.row];
    [cell.textLabel setText:self.focus.muscleName];

    if (self.focus.isChecked) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([[tableView cellForRowAtIndexPath:indexPath] accessoryType] == UITableViewCellAccessoryCheckmark)
    {
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
        [[self.muscles objectAtIndex:indexPath.row] setIsChecked:NO];
    }
    else
    {
        [[tableView cellForRowAtIndexPath:indexPath]setAccessoryType:UITableViewCellAccessoryCheckmark];
         [[self.muscles objectAtIndex:indexPath.row] setIsChecked:YES];
    }
   
    
}


-(IBAction)onClickNext:(id)sender
{
    
    
    NSString *str= [[NSString alloc]init];
     
    for (Focus *focus in self.muscles) {
        if ([focus isChecked]) {
            if ([str length]==0) {
                str =[str stringByAppendingString:[focus muscleID]];
            }
            else{
                str=[str stringByAppendingString:@","];
                str =[str stringByAppendingString:[focus muscleID]];
            }
            
        }
    }
    if ([str length]>0) {
     [userinfo setObject:str forKey:@"Selectedfocus"];    
        
    Workout *workouts= [[Workout alloc]init];
    
    if ([[workout WorkoutID]intValue]>0) {
        WorkoutDB *workoutDB =[[WorkoutDB alloc]init];
        [workoutDB setUpDatabase];
        [workoutDB createDatabase];
       
        NSString *workoutType =[userinfo stringForKey:@"workoutType"];
        
         ;
        if ([workoutType isEqualToString:@"Custom"]) {
            workouts =[workoutDB getCustomWorkoutByID:[workout WorkoutID]];
        }
        else
        {
            workouts =[workoutDB getSelfMadeByID:[workout WorkoutID]];
        }
    }
    
    
    [workouts setDuration:workout.Duration];
    [workouts setFocus:str];
        [workouts setName:[workout Name]];
        
        EquipmentViewController *viewController;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            
            viewController = [[EquipmentViewController alloc]initWithNibName:@"EquipmentViewController" bundle:nil];
            
        }
        else {
            viewController = [[EquipmentViewController alloc]initWithNibName:@"EquipmentViewController_iPad" bundle:nil];
        }
        
    viewController.workout =[[Workout alloc]init];
    viewController.workout=workouts;
       

   [self.navigationController pushViewController:viewController animated:YES];
    }
 else
 {
    [Fitness4MeUtils showAlert:NSLocalizedStringWithDefaultValue(@"focusMessage", nil,[Fitness4MeUtils getBundle], nil, nil)];
 }
}

-(IBAction)onClickBack:(id)sender{
     [userinfo setObject:@"" forKey:@"Selectedfocus"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setFocusTableView:nil];
    [self setNavigationBar:nil];
    self.muscles =nil;
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}
@end
