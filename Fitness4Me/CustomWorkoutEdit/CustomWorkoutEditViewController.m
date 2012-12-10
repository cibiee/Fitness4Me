//
//  CustomWorkoutEditViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 06/12/12.
//
//

#import "CustomWorkoutEditViewController.h"
#import "CustomWorkoutAddViewController.h"

@interface CustomWorkoutEditViewController ()
@property NSMutableArray *groupedExcersice;
@property NSMutableArray *workouts;
@property int s;
@end

@implementation CustomWorkoutEditViewController

@synthesize myQueue;
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
    [self setBackground];
}

-(void)setBackground{
    self.tableView.backgroundColor =[UIColor clearColor];
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:(CGRectMake(0,0, 320, 480))];
    UIImage  *backgroundImage= [UIImage imageNamed:@"home_bg.png"];
    background.image=backgroundImage;
    self.tableView.backgroundView = background;
    
    self.tableView.separatorColor =[UIColor clearColor];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self getExcersices];
    
}



-(void)getExcersices{
    
    //[activityIndicator startAnimating];
    [NSThread detachNewThreadSelector:@selector(ListExcersices) toTarget:self withObject:nil];
}

-(void)ListExcersices
{
    
    
    
    workoutDB =[[WorkoutDB alloc]init];
    [workoutDB setUpDatabase];
    [workoutDB createDatabase];
    [workoutDB getCustomWorkouts];
    
    if ([workoutDB.Workouts count]>0) {
        
        self.workouts = workoutDB.Workouts;
        [self prepareTableView];
        [self.tableView reloadData];
        //  [activityIndicator stopAnimating];
        // [activityIndicator setHidesWhenStopped:YES];
        
    }
    
    else {
        
        BOOL isReachable =[Fitness4MeUtils isReachable];
        if (isReachable){
            [NSThread detachNewThreadSelector:@selector(parseFitnessDetails) toTarget:self withObject:nil];
        }
        else {
            
            // networkNotificationtextView.hidden=NO;
            // [activityIndicator stopAnimating];
            // [activityIndicator removeFromSuperview];
            
            return;
        }
    }
    
    
}


-(void)parseFitnessDetails{
    
    
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    UserID =[userinfo integerForKey:@"UserID"];
    
    FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
    [fitness parseCustomFitnessDetails:UserID onCompletion:^{
        [self ListExcersices];
        
    }  onError:^(NSError *error) {
        
    }];
    
    
}


-(void)prepareTableView{
    self.groupedExcersice =[[NSMutableArray alloc]init];
    for(int i=0;i<[workoutDB.Workouts count];i++){
        NSArray *arrworkouts = [NSArray arrayWithObjects:[workoutDB.Workouts objectAtIndex:i], nil];
        NSDictionary *workouts = [NSDictionary dictionaryWithObject:arrworkouts forKey:@"workouts"];
        [self.groupedExcersice addObject:workouts];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Return the number of sections.
    return [self.groupedExcersice  count];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [self.groupedExcersice objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"workouts"];
    return [array count];
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"mycell";
    CustomCellContentController *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    
    if (cell == nil)
    {
        cell = [[CustomCellContentController alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
    }
    
    NSDictionary *dictionary = [self.groupedExcersice objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"workouts"];
    Workout *workout = [[Workout alloc]init];
    workout = [array objectAtIndex:indexPath.row];
    
    cell.TitleLabel.text = [workout Name];
    cell.DurationLabel.text = [[workout Duration] stringByAppendingString:@" miuntes."];
    cell.focusLabel.text=[workout Focus];
    cell.ExcersiceImage.image =[self imageForRowAtIndexPath:workout inIndexPath:indexPath];
    
    
    [cell.EditButton setTag:[indexPath section]]  ;
    [cell.EditButton  addTarget:self action:@selector(onClickEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.deleteButton setTag:[indexPath section]] ;
    [cell.deleteButton  addTarget:self action:@selector(onClickdelete:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyleforRowAtIndexPath:(NSIndexPath *)indexPath
{
    printf("About to delete item %d\n", [indexPath row]);
    //[tableTitles removeObjectAtIndex:[indexPath row]];
    [tableView reloadData];
}

- (UIImage *)imageForRowAtIndexPath:(Workout *)workout inIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyFolder/Thumbs"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        //Create Folder
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString  *storeURL= [dataPath stringByAppendingPathComponent :[workout ImageName]];
    UIImageView *excersiceImageHolder =[[UIImageView alloc]init];
    // Check If File Does Exists if not download the video
    if (![[NSFileManager defaultManager] fileExistsAtPath:storeURL]){
        UIImage *im =[UIImage imageNamed:@"dummyimg.png"];
        excersiceImageHolder.image =im;
        [self.myQueue setDelegate:self];
        [self.myQueue setShowAccurateProgress:YES];
        [self.myQueue setRequestDidFinishSelector:@selector(requestFinisheds:)];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[workout ThumbImageUrl]]];
        [request setDownloadDestinationPath:storeURL];
        [request setDelegate:self];
        [request startAsynchronous];
        [myQueue addOperation:[request copy]];
        [myQueue go];
    }else {
        UIImage *im =[[UIImage alloc]initWithContentsOfFile:storeURL];
        excersiceImageHolder.image=im;
        
    }
	
    return excersiceImageHolder.image;
    
}


-(IBAction)onClickAdd:(id)sender{
    CustomWorkoutAddViewController *viewController =[[CustomWorkoutAddViewController alloc]initWithNibName:@"CustomWorkoutAddViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onClickEdit:(id)sender{
    
    int s = [sender tag];

    NSDictionary *dictionary = [self.groupedExcersice objectAtIndex:s];
    NSArray *array = [dictionary objectForKey:@"workouts"];
    Workout *workout = [[Workout alloc]init];
    workout = [array objectAtIndex:0];
    CustomWorkoutAddViewController *viewController =[[CustomWorkoutAddViewController alloc]initWithNibName:@"CustomWorkoutAddViewController" bundle:nil];
    viewController.workout =[[Workout alloc]init];
    viewController .workout=workout;
    NSLog(@"%@",workout.WorkoutID);
    [self.navigationController pushViewController:viewController animated:YES];

}

-(IBAction)onClickdelete:(id)sender{
    
    self.s= [sender tag];
    
   
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"fitness4.me" message:@"Are you sure you want to delete this workout?"
                                                           delegate:self cancelButtonTitle:@"ok" otherButtonTitles:@"cancel", nil];
        [alertview show];
                        
   
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        UserID =[userinfo integerForKey:@"UserID"];
        
        NSDictionary *dictionary = [self.groupedExcersice objectAtIndex:self.s];
        NSArray *array = [dictionary objectForKey:@"workouts"];
        Workout *workout = [[Workout alloc]init];
        workout = [array objectAtIndex:0];
        FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
        [fitness deleteCustomWorkout:[workout WorkoutID] userID:UserID activityIndicator:nil progressView:nil onCompletion:^(NSString *responseString) {
            [self.workouts removeObjectAtIndex:self.s];
            [self prepareTableView];
            [self.tableView reloadData];
            [Fitness4MeUtils showAlert:@"Deleted Sucessfully"];
            [fitness parseCustomFitnessDetails:UserID onCompletion:^{
                
            } onError:^(NSError *error) {
                // [self getExcersices];
            }];
        } onError:^(NSError *error) {
            // [self getExcersices];
        }];

    }
    else {
        
    }
}

#pragma mark - Table view delegate


@end
