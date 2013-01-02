//
//  EquipmentViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 03/12/12.
//
//

#import "EquipmentViewController.h"
#import "WorkoutDB.h"
#import "FitnessServerCommunication.h"
#import "ExcersiceListViewController.h"
@interface EquipmentViewController ()
@property NSMutableArray *equipments;
@property(strong,nonatomic)NSIndexPath *lastIndex;
@end

@implementation EquipmentViewController
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
    // Do any additional setup after loading the view from its nib.
    
    [self.equipmentsTableView.layer setCornerRadius:8];
    [self.equipmentsTableView.layer setBorderColor:[[UIColor blackColor]CGColor]];
    [self.equipmentsTableView.layer setBorderWidth:2];
    
    
    self.equipments = [[NSMutableArray alloc]init];
    
    // add continue button
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
    
    [self getEquipments];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getEquipments{
    
    // [activityIndicator startAnimating];
    [NSThread detachNewThreadSelector:@selector(listEquipments) toTarget:self withObject:nil];
}


-(void)listEquipments
{
    
    self.equipmentDB =[[EquipmentDB alloc]init];
    [ self.equipmentDB setUpDatabase];
    [ self.equipmentDB createDatabase];
    [ self.equipmentDB getequipments];
    
    if ([ self.equipmentDB.equipments count]>0) {
        
        if ([[self.workout WorkoutID]intValue]>0) {
            [self.workout setProps:[self getfocusIDs:self.equipmentDB.equipments]];
            self.equipments = [self prepareTableView:self.equipmentDB.equipments];
        }
        else{
            self.equipments =self.equipmentDB.equipments;
            
        }
        
        [self.equipmentsTableView reloadData];
        
        
    }
    
    else{
        FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
        [fitness listEquipments:nil progressView:nil onCompletion:^(NSString *responseString) {
            [self listEquipments];}
                        onError:^(NSError *error) {
                            
                        }];
        
    }
    
    
}



-(NSString *)getfocusIDs:(NSMutableArray *)focuslist
{
    NSArray* foo = [[workout Props] componentsSeparatedByString: @","];
    
    //NSLog(@"%@",[workout Focus]);
    
    NSString *str=[[NSString alloc]init];
    
    for (int k=0; k<foo.count; k++) {
        
        for (int i=0; i<focuslist.count; i++) {
            if([[[focuslist objectAtIndex:i] equipmentName] isEqualToString:[foo objectAtIndex:k]] ){
                if ([str length]==0) {
                    str =[str stringByAppendingString:[[focuslist objectAtIndex:i] equipmentID]];
                }
                else{
                    str=[str stringByAppendingString:@","];
                    str =[str stringByAppendingString:[[focuslist objectAtIndex:i] equipmentID]];
                }
                
                
                break;
            }
            
            
        }
        
    }
    return str;
}





-(NSMutableArray*)prepareTableView:(NSMutableArray *)focuslist {
    
    NSArray* foo = [[workout Props] componentsSeparatedByString: @","];
    
    
    
    NSMutableArray *newfocusArray=[[NSMutableArray alloc]init];
    newfocusArray=focuslist;
    for (int k=0; k<foo.count; k++) {
        
        for (int i=0; i<focuslist.count; i++) {
            
            if([[[focuslist objectAtIndex:i] equipmentID] isEqualToString:[foo objectAtIndex:k]] ){
                [[newfocusArray objectAtIndex:i] setIsChecked:YES];
                break;
            }
            
            
        }
        
    }
    return newfocusArray;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.equipments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:@"Cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    // cell.accessoryType=UITableViewCellAccessoryNone;
    self.equipment=[self.equipments objectAtIndex:indexPath.row];
    [cell.textLabel setText:self.equipment.equipmentName];
    
    if (self.equipment.isChecked) {
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
        [[self.equipments objectAtIndex:indexPath.row] setIsChecked:NO];
    }
    else
    {
        [[tableView cellForRowAtIndexPath:indexPath]setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        [[self.equipments objectAtIndex:indexPath.row] setIsChecked:YES];
        
    }
    [self performSelector:@selector(deselect:) withObject:nil afterDelay:0.5f];
}

- (void) deselect: (id) sender {
    [self.equipmentsTableView deselectRowAtIndexPath:[self.equipmentsTableView indexPathForSelectedRow] animated:YES];
}


-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onClickNext:(id)sender{
    NSString *str= [[NSString alloc]init];
    str =@"";
    NSString *name= [[NSString alloc]init];
    for (Equipments *equipment in self.equipments) {
        if ([equipment isChecked]) {
            if ([str length]==0) {
                str =[str stringByAppendingString:[equipment equipmentID]];
                name =[name stringByAppendingString:[equipment equipmentName]];
            }
            else{
                str=[str stringByAppendingString:@","];
                str =[str stringByAppendingString:[equipment equipmentID]];
                name=[name stringByAppendingString:@","];
                name =[name stringByAppendingString:[equipment equipmentName]];
            }
            
        }
    }
    
    Workout *workouts= [[Workout alloc]init];
    if ([[workout WorkoutID]intValue]>0) {
        WorkoutDB *workoutDB =[[WorkoutDB alloc]init];
        [workoutDB setUpDatabase];
        [workoutDB createDatabase];
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        NSString *workoutType =[userinfo stringForKey:@"workoutType"];
        
        if ([workoutType isEqualToString:@"Custom"]) {
        workouts =[workoutDB getCustomWorkoutByID:[workout WorkoutID]];
        }
        else
        {
            workouts =[workoutDB getSelfMadeByID:[workout WorkoutID]];
        }
    }
    [workouts setDuration:workout.Duration];
    [workouts setFocus:workout.Focus];
    [workouts setFocusName:name];
    [workouts setProps:str];
    
    
    
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    NSString *workoutType =[userinfo stringForKey:@"workoutType"];
    
    if ([workoutType isEqualToString:@"Custom"]) {
        NameViewController *viewController =[[NameViewController alloc]initWithNibName:@"NameViewController" bundle:nil];
        viewController.workout= [[Workout alloc]init];
        viewController.workout =workouts;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        ExcersiceListViewController *viewController;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            viewController =[[ExcersiceListViewController alloc]initWithNibName:@"ExcersiceListViewController" bundle:nil];
        }else {
            viewController =[[ExcersiceListViewController alloc]initWithNibName:@"ExcersiceListViewController" bundle:nil];
        }
        [viewController setFocusList:[workout Focus]];
        [viewController setEquipments:str];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)viewDidUnload {
    [self setNavigationBar:nil];
    [super viewDidUnload];
}
@end
