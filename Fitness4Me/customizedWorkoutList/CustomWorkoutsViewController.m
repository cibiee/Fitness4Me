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

@end

@implementation CustomWorkoutsViewController
@synthesize myQueue;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
         myQueue=[[ASINetworkQueue alloc]init];
        fitness =[FitnessServerCommunication sharedState];
        userinfo =[NSUserDefaults standardUserDefaults];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.canCreatetrial =@"false" ;
    [self canCreate];
}

- (void)setTabbarItems
{
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
    
    self.canCreatetrial=[[NSString alloc]init];
    workoutDB =[[WorkoutDB alloc]init];
    [workoutDB setUpDatabase];
    [workoutDB createDatabase];
    [userinfo setObject:self.workoutType forKey:@"workoutType"];
    
    
    if ([self.workoutType isEqualToString:@"SelfMade"]){
        NSString *isMember =[userinfo valueForKey:@"isMember"];
        if ([isMember isEqualToString:@"true"]) {
            [workoutDB getSelfMadeWorkouts];
        }
        else{
            [activityIndicator stopAnimating];
            [activityIndicator setHidesWhenStopped:YES];
        }
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
    [self.memberView setHidden:YES];
    [self setBackground];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self.memberView setHidden:YES];
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


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyleforRowAtIndexPath :(NSIndexPath *)indexPath
{
    // printf("About to delete item %d\n", [indexPath row]);
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
    FocusViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[FocusViewController alloc]initWithNibName:@"FocusViewController" bundle:nil];
    }else {
        viewController =[[FocusViewController alloc]initWithNibName:@"FocusViewController_iPad" bundle:nil];
    }
    
    
    
    viewController .workout=nil;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)navigateToCustomWorkoutAdd {
    CustomWorkoutAddViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[CustomWorkoutAddViewController alloc]initWithNibName:@"CustomWorkoutAddViewController" bundle:nil];
    }else {
        viewController =[[CustomWorkoutAddViewController alloc]initWithNibName:@"CustomWorkoutAddViewController_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)canCreate
{
    self.canCreatetrial=[[NSString alloc]init];
    [fitness GetUserTypeWithactivityIndicator:nil progressView:nil onCompletion:^(NSString *responseString) {
        self.canCreatetrial=responseString;
        if ([self.canCreatetrial isEqualToString:@"false"]) {
             [self.messageLabel setText:NSLocalizedStringWithDefaultValue(@"trail5EndMessage", nil,[Fitness4MeUtils getBundle], nil, nil)];
        }
        else
        {
            [self.messageLabel setText:NSLocalizedStringWithDefaultValue(@"trailMessage", nil,[Fitness4MeUtils getBundle], nil, nil)];
        }
    } onError:^(NSError *error){
        
    }];
    
    
}


-(IBAction)onClickAdd:(id)sender{
    
    NSString *isMember =[userinfo valueForKey:@"isMember"];
    [userinfo setObject:@"" forKey:@"SelectedEquipments"];
    [userinfo setObject:@"" forKey:@"Selectedfocus"];
    
    
    if ([isMember isEqualToString:@"true"]) {
        if ([self.workoutType isEqualToString:@"SelfMade"]) {
            [self navigateToFocus];
        }else{
            [self navigateToCustomWorkoutAdd];
        }
    }else{
        if ([self.groupedExcersice count]>=5) {
            [self.continueButton setHidden:YES];
            [self.messageLabel setText:NSLocalizedStringWithDefaultValue(@"trail5EndMessage", nil,[Fitness4MeUtils getBundle], nil, nil)];
            
            [self showPremium];
        }
        else{
            
            if ([self.workoutType isEqualToString:@"SelfMade"]) {
                [self.view addSubview:activityIndicator];
                [activityIndicator startAnimating];
                [NSThread detachNewThreadSelector:@selector(getTrail) toTarget:self withObject:nil];
                
               
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


-(void)getTrail{
    
    [fitness GetUserTypeWithactivityIndicator:activityIndicator progressView:nil onCompletion:^(NSString *responseString) {
        self.canCreatetrial=responseString;
        if ([self.canCreatetrial isEqualToString:@"false"]) {
            [self.continueButton setHidden:NO];
            [self.messageLabel setText:NSLocalizedStringWithDefaultValue(@"trailMessage", nil,[Fitness4MeUtils getBundle], nil, nil)];
            [self showPremium];
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            
        }
        else{
            
            [self.continueButton setHidden:YES];
            [self.messageLabel setText:NSLocalizedStringWithDefaultValue(@"trailEndMessage", nil,[Fitness4MeUtils getBundle], nil, nil)];
            [self showPremium];
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        }                } onError:^(NSError *error){
            
        }];

    
    
}

-(IBAction)onClickContinueTrial:(id)sender
{
    [self navigateToFocus];
}


-(void)showPremium
{
    
    [self.view addSubview:self.memberView];
    [self.memberView setHidden:NO];
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
    
    Fitness4MeViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[Fitness4MeViewController alloc]initWithNibName:@"Fitness4MeViewController" bundle:nil];
    }else {
        viewController =[[Fitness4MeViewController alloc]initWithNibName:@"Fitness4MeViewController_iPad" bundle:nil];
    }
    
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)onClickEdit:(id)sender{
    
    
    [userinfo setObject:@"" forKey:@"SelectedEquipments"];
    [userinfo setObject:@"" forKey:@"Selectedfocus"];
    NSString *isMember =[userinfo valueForKey:@"isMember"];
    if ([isMember isEqualToString:@"true"]) {
        CustomWorkoutEditViewController *viewController;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            viewController =[[CustomWorkoutEditViewController alloc]initWithNibName:@"CustomWorkoutEditViewController" bundle:nil];
        }else {
            viewController =[[CustomWorkoutEditViewController alloc]initWithNibName:@"CustomWorkoutEditViewController_iPad" bundle:nil];
        }
        
        
        [viewController setWorkoutType:self.workoutType];
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        [self.continueButton setHidden:YES];
        [self.messageLabel setText:NSLocalizedStringWithDefaultValue(@"cannoteditMessage", nil,[Fitness4MeUtils getBundle], nil, nil)];
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
    
    CustomWorkoutIntermediateViewController *viewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[CustomWorkoutIntermediateViewController alloc]initWithNibName:@"CustomWorkoutIntermediateViewController" bundle:nil];
    }else {
        viewController =[[CustomWorkoutIntermediateViewController alloc]initWithNibName:@"CustomWorkoutIntermediateViewController_iPad" bundle:nil];
    }
    
    
    
    viewController.workout =[[Workout alloc]init];
    viewController .workout=workout;
    [viewController setNavigateBack:YES];
    [userinfo setObject:workout.Name forKey:@"WorkoutName"];
    [self.navigationController pushViewController:viewController animated:YES];
}



- (IBAction)onClickskipToPurchase:(id)sender{
    MembershipPurchaseViewController *viewController;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        viewController = [[MembershipPurchaseViewController alloc]initWithNibName:@"MembershipPurchaseViewController" bundle:nil];
        
    }
    else {
        viewController = [[MembershipPurchaseViewController alloc]initWithNibName:@"MembershipPurchaseViewController_iPad" bundle:nil];
    }
    [viewController setNavigateTo:@"List"];
    viewController.workout =nil;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (IBAction)onClickOk:(id)sender {
    MemberPromoViewController *viewController;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController = [[MemberPromoViewController alloc]initWithNibName:@"MemberPromoViewController" bundle:nil];
    }
    else {
        viewController = [[MemberPromoViewController alloc]initWithNibName:@"MemberPromoViewController_iPad" bundle:nil];
    }
    
    [viewController setNavigateTo:@"List"];
    viewController.workout =nil;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onClickClose:(id)sender {
    [self.memberView setHidden:YES];
}
@end
