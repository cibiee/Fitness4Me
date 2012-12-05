//
//  FocusViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 29/11/12.
//
//

#import "FocusViewController.h"
#import "EquipmentViewController.h"

@interface FocusViewController ()
@property NSMutableArray *muscles;
@end

@implementation FocusViewController
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
    
   
    
    UIButton *backutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backutton.frame = CGRectMake(0, 0, 58, 30);
    [backutton setBackgroundImage:[UIImage imageNamed:@"back_btn_with_text.png"] forState:UIControlStateNormal];
    [backutton addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:backutton];
    self.navigationBar.leftBarButtonItem = backBtn;
   
     NSLog(workout.Duration);
    [self.focusTableView.layer setCornerRadius:8];
    [self.focusTableView.layer setBorderColor:[[UIColor blackColor]CGColor]];
    [self.focusTableView.layer setBorderWidth:2];
    
    [NSThread detachNewThreadSelector:@selector(listfocus) toTarget:self withObject:nil];
}


-(void)listfocus
{
    self.focusDB =[[FocusDB alloc]init];
    [ self.focusDB setUpDatabase];
    [ self.focusDB createDatabase];
    [ self.focusDB getFocus];
    
    if ([ self.focusDB.muscles count]>0) {
        
        self.muscles =self.focusDB.muscles  ;
        [self.focusTableView reloadData];
        
    }
    
    
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
    Workout *workouts= [[Workout alloc]init];
    [workouts setDuration:workout.Duration];
    [workouts setFocus:str];
    
    EquipmentViewController *viewController =[[EquipmentViewController alloc]initWithNibName:@"EquipmentViewController" bundle:nil];
    viewController.workout =[[Workout alloc]init];
    viewController.workout=workouts;
   [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setFocusTableView:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
}
@end
