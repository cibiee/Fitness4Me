//
//  ExcersiceListViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 12/12/12.
//
//

#import "CustomExcersiceCell.h"
#import "ExcersiceListViewController.h"
#import "ExcersiceList.h"
#import "FitnessServerCommunication.h"

@interface ExcersiceListViewController ()
@property NSMutableArray *excersiceList;
@property NSMutableArray *groupedExcersice;
@end

@implementation ExcersiceListViewController
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
    
    // NSLog(workout.Duration);
    [self.excersiceListTableview.layer setCornerRadius:8];
    [self.excersiceListTableview.layer setBorderColor:[[UIColor blackColor]CGColor]];
    [self.excersiceListTableview.layer setBorderWidth:2];
    [self setBackground];
    [self.activityIndicator startAnimating];
    [NSThread detachNewThreadSelector:@selector(listExcersice) toTarget:self withObject:nil];
}

-(void)setBackground{
    self.excersiceListTableview.backgroundColor =[UIColor clearColor];
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:(CGRectMake(0,0, 320, 480))];
    UIImage  *backgroundImage= [UIImage imageNamed:@"home_bg.png"];
    background.image=backgroundImage;
    self.excersiceListTableview.backgroundView = background;
    
    self.excersiceListTableview.separatorColor =[UIColor clearColor];
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}


-(void)listExcersice
{
  
    FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
    [fitness listExcersiceWithequipments:@"2" focus:@"3" activityIndicator:self.activityIndicator progressView:nil onCompletion:^(NSString *responseString) {
        
        if ([responseString length]>0) {
            [self parseCustomWorkoutList:responseString];
            if ([self.excersiceList count]>0) {
                [self prepareTableView];
                
                [self.excersiceListTableview reloadData];
                [self.activityIndicator stopAnimating];
                [self.activityIndicator setHidesWhenStopped:YES];
            }
        }
        
    } onError:^(NSError *error) {
        
    }];
    

 
}


-(void)parseCustomWorkoutList:(NSString*)responseString
{
    NSMutableArray *object = [responseString JSONValue];
    self.excersiceList = [[NSMutableArray alloc]init];
    NSMutableArray *itemsarray =[object valueForKey:@"exercises"];
    
    [itemsarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* item = obj;
        ExcersiceList *excersiceLists =[[ExcersiceList alloc]init];
        [excersiceLists setExcersiceID:[item objectForKey:@"id"]];
        [excersiceLists setImageUrl:[item objectForKey:@"imageThumb"]];
        [excersiceLists setImageName:[item objectForKey:@"imageThumbName"]];
        [excersiceLists setTime:[item objectForKey:@"exerciseTime"]];
        [excersiceLists setName:[item objectForKey:@"exerciseName"]];
        [excersiceLists setFocus:[item objectForKey:@"exerciseFocus"]];
        [excersiceLists setEquipments:[item objectForKey:@"exerciseEquipments"]];
        [self.excersiceList addObject:excersiceLists];
        
    }];
    
    
}





-(void)prepareTableView{
    
    self.groupedExcersice =[[NSMutableArray alloc]init];
    
    for(int i=0;i<[self.excersiceList count];i++)
    {
        
        NSArray *arrworkouts = [NSArray arrayWithObjects:[self.excersiceList objectAtIndex:i], nil];
        NSDictionary *workouts = [NSDictionary dictionaryWithObject:arrworkouts forKey:@"workouts"];
        [self.groupedExcersice addObject:workouts];
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    CustomExcersiceCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    
    if (cell == nil)
    {
        cell = [[CustomExcersiceCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
    }
    
    NSDictionary *dictionary = [self.groupedExcersice objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"workouts"];
    ExcersiceList *workout = [[ExcersiceList alloc]init];
    workout = [array objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.deleteButton setHidden:YES];
    [cell.EditButton setHidden:YES];
    [cell.deleteLabel setHidden:YES];
    [cell.EditLabel setHidden:YES];
    cell.TitleLabel.text = [workout name];
    cell.DurationLabel.text = [[workout time] stringByAppendingString:@" miuntes."];
    cell.focusLabel.text=[workout focus];
    cell.ExcersiceImage.image =[self imageForRowAtIndexPath:workout inIndexPath:indexPath];
     self.focus=[array objectAtIndex:indexPath.row];
    if (self.focus.isChecked) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}


- (UIImage *)imageForRowAtIndexPath:(ExcersiceList *)workout inIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyFolder/SelfMadeThumbs"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        //Create Folder
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString  *storeURL= [dataPath stringByAppendingPathComponent :[workout imageName]];
    UIImageView *excersiceImageHolder =[[UIImageView alloc]init];
    // Check If File Does Exists if not download the video
    if (![[NSFileManager defaultManager] fileExistsAtPath:storeURL]){
        UIImage *im =[UIImage imageNamed:@"dummyimg.png"];
        excersiceImageHolder.image =im;
        [self.myQueue setDelegate:self];
        [self.myQueue setShowAccurateProgress:YES];
        [self.myQueue setRequestDidFinishSelector:@selector(requestFinisheds:)];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[workout imageUrl]]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[tableView cellForRowAtIndexPath:indexPath] accessoryType] == UITableViewCellAccessoryCheckmark)
    {
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
        [[self.excersiceList objectAtIndex:indexPath.section] setIsChecked:NO];
    }
    else
    {
        [[tableView cellForRowAtIndexPath:indexPath]setAccessoryType:UITableViewCellAccessoryCheckmark];
        [[self.excersiceList objectAtIndex:indexPath.section] setIsChecked:YES];
    }
    
    
}


-(IBAction)onClickNext:(id)sender
{
    
    
//    NSString *str= [[NSString alloc]init];
//    
//    for (Focus *focus in self.muscles) {
//        if ([focus isChecked]) {
//            if ([str length]==0) {
//                str =[str stringByAppendingString:[focus muscleID]];
//            }
//            else{
//                str=[str stringByAppendingString:@","];
//                str =[str stringByAppendingString:[focus muscleID]];
//            }
//            
//        }
//    }
//    if ([str length]>0) {
//        
//        
//        Workout *workouts= [[Workout alloc]init];
//        
//        if ([[workout WorkoutID]intValue]>0) {
//            WorkoutDB *workoutDB =[[WorkoutDB alloc]init];
//            [workoutDB setUpDatabase];
//            [workoutDB createDatabase];
//            workouts =[workoutDB getCustomWorkoutByID:[workout WorkoutID]];
//        }
//        
//        
//        [workouts setDuration:workout.Duration];
//        [workouts setFocus:str];
//        
//        EquipmentViewController *viewController =[[EquipmentViewController alloc]initWithNibName:@"EquipmentViewController" bundle:nil];
//        viewController.workout =[[Workout alloc]init];
//        viewController.workout=workouts;
//        [self.navigationController pushViewController:viewController animated:YES];
//    }
//    else
//    {
//        [Fitness4MeUtils showAlert:@"Please select an area of focus"];
//    }
}

-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setExcersiceListTableview:nil];
    [super viewDidUnload];
}
@end
