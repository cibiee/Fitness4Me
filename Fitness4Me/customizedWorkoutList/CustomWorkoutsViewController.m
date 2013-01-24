//
//  CustomWorkoutsViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 28/11/12.
//
//

#import "CustomWorkoutsViewController.h"
#import "FitnessServerCommunication.h"
#import "Fitness4MeViewController.h"
#import "Favourite.h"
#import "CustomFavourites.h"
#import "MemberPromoViewController.h"
#import "FocusViewController.h"

@interface CustomWorkoutsViewController ()

@property NSMutableArray *groupedExcersice;
@property NSMutableArray *workouts;
@property (strong,nonatomic)NSString* canCreatetrials;
@end

@implementation CustomWorkoutsViewController
@synthesize myQueue;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        fitness =[FitnessServerCommunication sharedState];
         userinfo =[NSUserDefaults standardUserDefaults];
        //  self.workoutType=[[NSString alloc]init];
        // Custom initialization
    }
    return self;
}

- (void)setTabbarItems
{
    // Do any additional setup after loading the view from its nib.
    
    UIButton *backutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backutton.frame = CGRectMake(0, 0, 58, 30);
    [backutton setBackgroundImage:[UIImage imageNamed:@"back_btn_with_text.png"] forState:UIControlStateNormal];
    [backutton addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:backutton];
    self.navigationBar.leftBarButtonItem = backBtn;
}

-(void)setBackground{
    self.tableView.backgroundColor =[UIColor clearColor];
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:(CGRectMake(0,0, 320, 480))];
    UIImage  *backgroundImage= [UIImage imageNamed:@"home_bg.png"];
    background.image=backgroundImage;
    self.tableView.backgroundView = background;
    [self.tableView reloadData];
    self.tableView.separatorColor =[UIColor clearColor];
}

-(void)getExcersices{
    
    [activityIndicator startAnimating];
    [NSThread detachNewThreadSelector:@selector(ListExcersices) toTarget:self withObject:nil];
}

-(void)ListExcersices
{
    NSString *canCreates=[[NSString alloc]init];
    canCreates=[self canCreate];
    
    NSString *isMember =[userinfo valueForKey:@"isMember"];
    if ([isMember isEqualToString:@"true"]) {
 
    workoutDB =[[WorkoutDB alloc]init];
    [workoutDB setUpDatabase];
    [workoutDB createDatabase];
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
    }else{
        [activityIndicator stopAnimating];
        [activityIndicator setHidesWhenStopped:YES];
        [self showPremium];
    }
}


-(void)parseFitnessDetails{
   
    UserID =[userinfo integerForKey:@"UserID"];
    if ([self.workoutType isEqualToString:@"SelfMade"]) {
        [fitness parseSelfMadeFitnessDetails:UserID trail:@"0" onCompletion:^(NSString *responseString){
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTabbarItems];
    [self setBackground];
}

- (void)viewDidAppear:(BOOL)animated {
     [self getExcersices];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setNavigationBar:nil];
    [self setMemberView:nil];
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"mycell";
    CustomCellContentController *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil){
        cell = [[CustomCellContentController alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
    }
    
    NSDictionary *dictionary = [self.groupedExcersice objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"workouts"];
    Workout *workout = [[Workout alloc]init];
    workout = [array objectAtIndex:indexPath.row];
    
    [cell.deleteButton setHidden:YES];
    [cell.EditButton setHidden:YES];
    [cell.deleteLabel setHidden:YES];
    [cell.EditLabel setHidden:YES];
    cell.TitleLabel.text = [workout Name];
    cell.DurationLabel.text = [NSString stringWithFormat:@"%@",[Fitness4MeUtils displayTimeWithSecond:[[workout Duration]intValue]]];
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
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
        
        [myQueue addOperation:request];
        [myQueue go];
    }else {
        UIImage *im =[[UIImage alloc]initWithContentsOfFile:storeURL];
        excersiceImageHolder.image=im;
        
    }
	
    return excersiceImageHolder.image;
    
}


- (void)navigateToFocus {
    FocusViewController *viewController =[[FocusViewController alloc]initWithNibName:@"FocusViewController" bundle:nil];
    viewController .workout=nil;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)navigateToCustomWorkoutAdd {
    CustomWorkoutAddViewController *viewController =[[CustomWorkoutAddViewController alloc]initWithNibName:@"CustomWorkoutAddViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(NSString*)canCreate
{
    
  self.canCreatetrials=@"";
    [fitness GetUserTypeWithactivityIndicator:nil progressView:nil onCompletion:^(NSString *responseString) {
                canCreate=[[NSString alloc]init];
        canCreate =responseString;
        

    } onError:^(NSError *error){
        
    }];
     NSLog(@"--sdsdsd--%@-----",self.canCreatetrials);
    return canCreate;
}


-(IBAction)onClickAdd:(id)sender{
    
    NSString *isMember =[userinfo valueForKey:@"isMember"];
    NSString *canCreatetrial=[[NSString alloc]init];
    [userinfo setObject:@"" forKey:@"SelectedEquipments"];
    [userinfo setObject:@"" forKey:@"Selectedfocus"];
     canCreatetrial=[self canCreate];
    NSLog(@"----%@-----",canCreatetrial);


    if ([isMember isEqualToString:@"true"]) {
        if ([self.workoutType isEqualToString:@"SelfMade"]) {
            [self navigateToFocus];
        }else{
            [self navigateToCustomWorkoutAdd];
        }
    }else{
        if ([self.groupedExcersice count]>=5) {
            [self showPremium];
        }
        else{
            NSLog(@"----%@-----",canCreatetrial);
            if ([self.workoutType isEqualToString:@"SelfMade"]) {
                if ([canCreatetrial isEqualToString:@"false"]) {
                    [self navigateToFocus];
                }
                else{
                    [self showPremium];
                }
            }
            
            else{
                
                [userinfo setInteger:[self.groupedExcersice count] forKey:@"customCount"];
                [self navigateToCustomWorkoutAdd];
            }
        }
    }
    
    [userinfo setObject:@"" forKey:@"SelectedWorkouts"];
    GlobalArray=[[NSMutableArray alloc]init];
}


-(void)showPremium
{
    [self.memberView setHidden:NO];
    [self.view addSubview:self.memberView];
}



- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
       
    }
    else {
        
    }
}


- (CustomFavourites *)deleteFavStatus:(Favourite *)fav {
    CustomFavourites *customFavourites =[[CustomFavourites alloc]init];
    [customFavourites setUpDatabase];
    [customFavourites createDatabase];
    if ([self.workoutType isEqualToString:@"SelfMade"]){
        [customFavourites deleteSelfMadefavouritewithID:[fav workoutID]];
    }
    else{
        [customFavourites deletefavouritewithID:[fav workoutID]];
    }
    
    
    return customFavourites;
}

- (void)insertFavStatus:(Favourite *)fav {
    CustomFavourites *customFavourites =[[CustomFavourites alloc]init];
    [customFavourites setUpDatabase];
    [customFavourites createDatabase];
    if ([self.workoutType isEqualToString:@"SelfMade"]){
        [customFavourites insertSelfMadefavourite:fav];
    }
    else{
        [customFavourites insertfavourite:fav];
    }
    
}

- (void)updateWorkout:(Workout *)workout {
    workoutDB =[[WorkoutDB alloc]init];
    [workoutDB setUpDatabase];
    [workoutDB createDatabase];
    if ([self.workoutType isEqualToString:@"SelfMade"]){
        [workoutDB updateCustomWorkout:[workout WorkoutID] :[workout IsLocked]];
    }
    else{
        [workoutDB updateSelfMadeWorkout:[workout WorkoutID] :[workout IsLocked]];
    }
    
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
    }else{
        [[self.workouts objectAtIndex:s] setIsLocked:@"true"];
        statusInt=@"1";
        [fav setStatus:1];
        [fav setWorkoutID:[workout WorkoutID]];
        [SetFaveButton setImage:[UIImage imageNamed:@"smiley"] forState:UIControlStateNormal];
    }
    BOOL isReachable = [Fitness4MeUtils isReachable];
    if (isReachable) {
        if ([self.workoutType isEqualToString:@"SelfMade"]){
            [fitness setSelfMadeWorkoutfavourite:[workout WorkoutID] UserID:UserID Status:statusInt activityIndicator:nil progressView:nil onCompletion:^(NSString *responseString) {
            } onError:^(NSError *error) {
            }];
            [self parseFitnessDetails];
        }else{
            [fitness setWorkoutfavourite:[workout WorkoutID] UserID:UserID Status:statusInt activityIndicator:nil progressView:nil onCompletion:^(NSString *responseString) {
            } onError:^(NSError *error) {
            }];
            [self parseFitnessDetails];
        }
    }else{
        CustomFavourites *customFavourites;
        customFavourites = [self deleteFavStatus:fav];
        [self insertFavStatus:fav];
        [self updateWorkout:workout];
    }
    
}


- (void)requestFinisheds:(ASINetworkQueue *)queue
{
    [self.tableView reloadData];
}


-(IBAction)onClickBack:(id)sender{
    Fitness4MeViewController *viewController =[[Fitness4MeViewController alloc]initWithNibName:@"Fitness4MeViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)onClickEdit:(id)sender{
    
    NSString *canCreate=[[NSString alloc]init];
    canCreate=[self canCreate];
    [userinfo setObject:@"" forKey:@"SelectedEquipments"];
    [userinfo setObject:@"" forKey:@"Selectedfocus"];

    NSString *isMember =[userinfo valueForKey:@"isMember"];
    if ([isMember isEqualToString:@"true"]) {
        CustomWorkoutEditViewController *viewController =[[CustomWorkoutEditViewController alloc]initWithNibName:@"CustomWorkoutEditViewController" bundle:nil];
        [viewController setWorkoutType:self.workoutType];
        [self.navigationController pushViewController:viewController animated:YES];
   }else{
        [self showPremium];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = [self.groupedExcersice objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"workouts"];
    Workout *workout = [[Workout alloc]init];
    workout = [array objectAtIndex:indexPath.row];
    CustomWorkoutIntermediateViewController *viewController =[[CustomWorkoutIntermediateViewController alloc]initWithNibName:@"CustomWorkoutIntermediateViewController" bundle:nil];
    viewController.workout =[[Workout alloc]init];
    viewController .workout=workout;
    [viewController setNavigateBack:YES];
    [userinfo setObject:workout.Name forKey:@"WorkoutName"];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (IBAction)onClickOk:(id)sender {
    MemberPromoViewController *viewController;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController = [[MemberPromoViewController alloc]initWithNibName:@"MemberPromoViewController" bundle:nil];
    }
    else {
        viewController = [[MemberPromoViewController alloc]initWithNibName:@"MemberPromoViewController" bundle:nil];
    }
    
    [viewController setNavigateTo:@"List"];
    viewController.workout =nil;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onClickClose:(id)sender {
    [self.memberView setHidden:YES];
}
@end
