//
//  CustomWorkoutEditViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 06/12/12.
//
//

#import "CustomWorkoutEditViewController.h"
#import "CustomWorkoutAddViewController.h"
#import "Favourite.h"
#import "CustomFavourites.h"
#import "ExcersiceListViewController.h"
#import "CarouselViewDemoViewController.h"
#import "FitnessServer.h"
@interface CustomWorkoutEditViewController ()
@property NSMutableArray *groupedExcersice;
@property NSMutableArray *workouts;
@property int s;
@end

@implementation CustomWorkoutEditViewController

@synthesize myQueue;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
        GlobalArray =[[NSMutableArray alloc]init];
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
    
    [activityIndicator startAnimating];
    [NSThread detachNewThreadSelector:@selector(ListExcersices) toTarget:self withObject:nil];
}

-(void)ListExcersices
{
    
    workoutDB =[[WorkoutDB alloc]init];
    [workoutDB setUpDatabase];
    [workoutDB createDatabase];
    
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setObject:self.workoutType forKey:@"workoutType"];
    
    if ([self.workoutType isEqualToString:@"SelfMade"]){
        [workoutDB getSelfMadeWorkouts];
    }else{
        [workoutDB getCustomWorkouts];
    }
    
    if ([workoutDB.Workouts count]>0) {
        [self.tableView setHidden:NO];
        self.workouts = workoutDB.Workouts;
        [self prepareTableView];
        [self.tableView reloadData];
        [activityIndicator stopAnimating];
        [activityIndicator setHidesWhenStopped:YES];
    }else {
        BOOL isReachable =[Fitness4MeUtils isReachable];
        if (isReachable){
            self.workouts =nil;
            [self.tableView reloadData];
            [self.tableView setHidden:YES];
            [NSThread detachNewThreadSelector:@selector(parseFitnessDetails) toTarget:self withObject:nil];
        }else {
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            return;
        }
    }
}


-(void)parseFitnessDetails{
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    UserID =[userinfo integerForKey:@"UserID"];
    FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
    if ([self.workoutType isEqualToString:@"SelfMade"]){
    
    [fitness parseSelfMadeFitnessDetails:UserID onCompletion:^(NSString *responseString){
        if ([responseString length]>0) {
            [self parseCustomWorkoutList:responseString];
        }
        
    }  onError:^(NSError *error) {
        
    }];
    }
    else
    {
        [fitness parseCustomFitnessDetails:UserID onCompletion:^(NSString *responseString){
            if ([responseString length]>0) {
                [self parseCustomWorkoutList:responseString];
            }
            
        }  onError:^(NSError *error) {
            
        }];

    }
}


-(void)parseCustomWorkoutList:(NSString*)responseString
{
    NSMutableArray *object = [responseString JSONValue];
    self.workouts = [[NSMutableArray alloc]init];
    NSMutableArray *itemsarray =[object valueForKey:@"items"];
    [itemsarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* item = obj;
        
        [self.workouts addObject:[[Workout alloc]initWithCustomData:[item objectForKey:@"id"]:[item objectForKey:@"name"]:[item objectForKey:@"rate"]:[item objectForKey:@"image_android"]:[item objectForKey:@"image_name"]:[item objectForKey :@"isFav"]:[item objectForKey:@"description"]:[item objectForKey:@"description_big"]:nil:[item objectForKey:@"description_big"]:[item objectForKey :@"image_thumb"]:[item objectForKey:@"equipment"]:[item objectForKey:@"duration"]:[item objectForKey:@"focus"]]];
    }];
    
    if (self.workouts.count>0) {
        [self ListExcersices];
        [self.tableView setHidden:NO];
    }
    else
    {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        [self.tableView setHidden:YES];
        [self.tableView reloadData];
    }
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
    //return 1;
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
    
    if ([[workout IsLocked] isEqualToString:@"true"]) {
        [cell.favIcon setImage:[UIImage imageNamed:@"smiley"] forState:UIControlStateNormal];
    }
    else{
        [cell.favIcon setImage:[UIImage imageNamed:@"smiley_disabled"] forState:UIControlStateNormal];
        
    }
    [cell.favIcon setTag:[indexPath section]];
    [cell.favIcon  addTarget:self action:@selector(onClicksetFavourite:) forControlEvents:UIControlEventTouchUpInside];
    
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
        self.myQueue = [ASINetworkQueue queue];
        [self.myQueue setDelegate:self];
        [self.myQueue setShowAccurateProgress:YES];
        [self.myQueue setRequestDidFinishSelector:@selector(requestFinisheds:)];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[workout ThumbImageUrl]]];
        [request setDownloadDestinationPath:storeURL];
        [request setDelegate:self];
        //[request startAsynchronous];
        [myQueue addOperation:request];
        [myQueue go];
    }else {
        UIImage *im =[[UIImage alloc]initWithContentsOfFile:storeURL];
        excersiceImageHolder.image=im;
        
    }
	
    return excersiceImageHolder.image;
    
}

- (void)requestFinisheds:(ASINetworkQueue *)queue
{
    [self.tableView reloadData];
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
    
   
    
    if ([self.workoutType isEqualToString:@"SelfMade"]) {
        
        FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
        [fitness listExcersiceFwithworkoutID:[workout WorkoutID] activityIndicator:nil progressView:nil onCompletion:^(NSString *responseString) {
            NSString *str= [[NSString alloc]init];

           [self praseworkoutArray:responseString];
            if ([GlobalArray count]>0) {
                for (ExcersiceList *excerlist in GlobalArray) {
                    
                    if ([str length]==0) {
                        
                        str =[str stringByAppendingString:[excerlist excersiceID]];
                        
                    }
                    else{
                        str=[str stringByAppendingString:@","];
                        str =[str stringByAppendingString:[excerlist excersiceID]];
                        
                    }
                }
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];           
        [userinfo setObject:str forKey:@"SelectedWorkouts"];
                CarouselViewDemoViewController *viewController;
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
                    viewController =[[CarouselViewDemoViewController alloc]initWithNibName:@"CarouselViewDemoViewController" bundle:nil];
                }else {
                    viewController =[[CarouselViewDemoViewController alloc]initWithNibName:@"CarouselViewDemoViewController" bundle:nil];
                }
                 [viewController setOperationMode:@"Edit"];
                viewController.workout =[[Workout alloc]init];
                viewController .workout =workout;
                [viewController setDataSourceArray:GlobalArray];
                [self.navigationController pushViewController:viewController animated:YES];
                
            }
            
        } onError:^(NSError *error) {
            
        }];
       
    }
    else
    {
        CustomWorkoutAddViewController *viewController =[[CustomWorkoutAddViewController alloc]initWithNibName:@"CustomWorkoutAddViewController" bundle:nil];
        viewController.workout =[[Workout alloc]init];
        viewController .workout=workout;
        NSLog(@"%@",workout.WorkoutID);
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


- (void)praseworkoutArray:(NSString *)responseString
{
    NSMutableArray *object = [responseString JSONValue];
    GlobalArray = [[NSMutableArray alloc]init];
    NSMutableArray *itemsarray =[object valueForKey:@"items"];
    [itemsarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* item = obj;
        ExcersiceList *excersice=[[ExcersiceList alloc]init];
        if ([[item objectForKey:@"exerciseID"] length]>0) {
            
       
        [excersice setExcersiceID:[item objectForKey:@"exerciseID"]];
        [excersice setName:[item objectForKey:@"name"]];
        [excersice setImageUrl:[item objectForKey:@"image"]];
        [excersice setImageName:[item objectForKey:@"imageName"]];
        //[excersice setExcersiceID:[item objectForKey:@"exerciseID"]];
         }
        else if ([[item objectForKey:@"recovery"] length]>0)
        {
            
            [excersice setExcersiceID:[item objectForKey:@"recovery"]];
            [excersice setName:@"recoverI5"];
            [excersice setImageUrl:[item objectForKey:@"image"]];
            [excersice setImageName:[item objectForKey:@"imageName"]];
        }
        
        [GlobalArray addObject:excersice];
    }];
    
  }

- (CustomFavourites *)deleteFavStatus:(Favourite *)fav {
    CustomFavourites *customFavourites =[[CustomFavourites alloc]init];
    [customFavourites setUpDatabase];
    [customFavourites createDatabase];
    [customFavourites deletefavouritewithID:[fav workoutID]];
    return customFavourites;
}

- (void)insertFavStatus:(Favourite *)fav {
    CustomFavourites *customFavourites =[[CustomFavourites alloc]init];
    [customFavourites setUpDatabase];
    [customFavourites createDatabase];
    [customFavourites insertfavourite:fav];
}

- (void)updateWorkout:(Workout *)workout {
    workoutDB =[[WorkoutDB alloc]init];
    [workoutDB setUpDatabase];
    [workoutDB createDatabase];
    [workoutDB updateCustomWorkout:[workout WorkoutID] :[workout IsLocked]];
}

-(IBAction)onClicksetFavourite:(id)sender{
    
    int s = [sender tag];
    UIButton *SetFaveButton =(UIButton*)sender;
    NSDictionary *dictionary = [self.groupedExcersice objectAtIndex:s];
    NSArray *array = [dictionary objectForKey:@"workouts"];
    Workout *workout = [[Workout alloc]init];
    Favourite *fav= [[Favourite alloc]init];
    workout = [array objectAtIndex:0];
    
    NSString *status =[workout IsLocked];;
    NSString *statusInt=0;
    if ([status isEqualToString:@"true"]) {
        [[self.workouts objectAtIndex:s] setIsLocked:@"false"];
        statusInt=@"0";
        [fav setStatus:0];
        [fav setWorkoutID:[workout WorkoutID]];
        
        [SetFaveButton setImage:[UIImage imageNamed:@"smiley_disabled"] forState:UIControlStateNormal];
    }
    else
    {
        [[self.workouts objectAtIndex:s] setIsLocked:@"true"];
        statusInt=@"1";
        [fav setStatus:1];
        [fav setWorkoutID:[workout WorkoutID]];
        [SetFaveButton setImage:[UIImage imageNamed:@"smiley"] forState:UIControlStateNormal];
    }
    
    
    BOOL isReachable = [Fitness4MeUtils isReachable];
    if (isReachable) {
        
        
        __weak FitnessServerCommunication *fitness=[FitnessServerCommunication  sharedState];
        
        if ([self.workoutType isEqualToString:@"SelfMade"]){
            [fitness setSelfMadeWorkoutfavourite:[workout WorkoutID] UserID:UserID Status:statusInt activityIndicator:nil progressView:nil onCompletion:^(NSString *responseString) {
                
                
            } onError:^(NSError *error) {
                
            }];
            [self parseFitnessDetails];
        }
        
        else
        {
        [fitness setWorkoutfavourite:[workout WorkoutID] UserID:UserID Status:statusInt activityIndicator:nil progressView:nil onCompletion:^(NSString *responseString) {
            
            
        } onError:^(NSError *error) {
            
        }];
        [self parseFitnessDetails];
        }
    }
    else
    {
        CustomFavourites *customFavourites;
        customFavourites = [self deleteFavStatus:fav];
        [self insertFavStatus:fav];
        [self updateWorkout:workout];
    }
    
}


-(IBAction)onClickdelete:(id)sender{
    self.s= [sender tag];
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"fitness4.me" message:NSLocalizedString(@"deleteWorkout", nil)
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
        
        if ([self.workoutType isEqualToString:@"SelfMade"]){
            
            [fitness deleteSelfMadeWorkout:[workout WorkoutID] userID:UserID activityIndicator:nil progressView:nil onCompletion:^(NSString *responseString) {
                [self.workouts removeObjectAtIndex:self.s];
                [self prepareTableView];
                [self.tableView reloadData];
                [Fitness4MeUtils showAlert:NSLocalizedString(@"deletedSucessfully", nil)];
                [fitness parseSelfMadeFitnessDetails:UserID onCompletion:^(NSString *responseString){
                    
                } onError:^(NSError *error) {
                    // [self getExcersices];
                }];
            } onError:^(NSError *error) {
                // [self getExcersices];
            }];
        }
        else
        {
            
            [fitness deleteCustomWorkout:[workout WorkoutID] userID:UserID activityIndicator:nil progressView:nil onCompletion:^(NSString *responseString) {
                [self.workouts removeObjectAtIndex:self.s];
                [self prepareTableView];
                [self.tableView reloadData];
                 [Fitness4MeUtils showAlert:NSLocalizedString(@"deletedSucessfully", nil)];
                [fitness parseCustomFitnessDetails:UserID onCompletion:^(NSString *responseString){
                    
                } onError:^(NSError *error) {
                    // [self getExcersices];
                }];
            } onError:^(NSError *error) {
                // [self getExcersices];
            }];
        }
        
    }
    else {
        
    }
}

#pragma mark - Table view delegate


@end
