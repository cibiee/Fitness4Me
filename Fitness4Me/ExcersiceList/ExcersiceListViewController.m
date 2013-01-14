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
#import "FitnessServer.h"

@interface ExcersiceListViewController ()
@property NSMutableArray *excersiceList;
@property NSMutableArray *groupedExcersice;
@property int videoCount;
@property int totalDuration;
@end

@implementation ExcersiceListViewController
@synthesize myQueue;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
        userinfo=[NSUserDefaults standardUserDefaults];
        if ([GlobalArray count]>0) {
            
        }
        else{
            GlobalArray =[[NSMutableArray alloc]init];
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    self.videoCount=0;
    self.totalDuration=0;
    [self.totalVideoCountLabel setText:[NSString stringWithFormat:@"Number of excersices [%i]",self.videoCount]];
    [self.durationLabel setText:[NSString stringWithFormat:@"Total Time [%i]",self.totalDuration]];
    
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
    self.excersiceList = [[NSMutableArray alloc]init];
    [NSThread detachNewThreadSelector:@selector(listExcersice) toTarget:self withObject:nil];
}


-(void)listExcersice
{
    
    FitnessServerCommunication *fitness =[FitnessServerCommunication sharedState];
    [fitness listExcersiceWithequipments:self.equipments focus:self.focusList activityIndicator:self.activityIndicator progressView:nil onCompletion:^(NSString *responseString) {
        
        if ([responseString length]>0) {
            [self parseCustomWorkoutList:responseString];
            if ([self.excersiceList count]>0) {
                self.excersiceList = [self prepareData:self.excersiceList];
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

-(NSMutableArray*)prepareData:(NSMutableArray *)excersicelist {
    
    NSString *selectedWorkouts = [userinfo objectForKey:@"SelectedWorkouts"];
    NSArray* foo = [selectedWorkouts componentsSeparatedByString: @","];
    self.totalDuration=0;
    self.videoCount=0;
    
    NSMutableArray *newfocusArray=[[NSMutableArray alloc]init];
    newfocusArray=excersicelist;
    for (int k=0; k<foo.count; k++) {
        for (int i=0; i<excersicelist.count; i++) {
            if([[[excersicelist objectAtIndex:i] excersiceID] isEqualToString:[foo objectAtIndex:k]] ){
                [[newfocusArray objectAtIndex:i] setIsChecked:YES];
                if ([GlobalArray count]>0) {
                    if ([[[GlobalArray objectAtIndex:k]excersiceID]isEqualToString:[[excersicelist objectAtIndex:i] excersiceID]]) {
                        
                    }else{
                        [GlobalArray addObject:[excersicelist objectAtIndex:k]];
                    }
                }
                self.totalDuration=self.totalDuration+ [[[self.excersiceList objectAtIndex:k] time]intValue];
                self.videoCount++;
                break;
            }
        }
    }
    
    [self.totalVideoCountLabel setText:[NSString stringWithFormat:@"%@ [%i]",NSLocalizedString(@"numberOfExcersice", nil),self.videoCount]];
    [self.durationLabel setText:[NSString stringWithFormat:@"%@ [%i]",NSLocalizedString(@"totalTime", nil),self.totalDuration]];
    return newfocusArray;
}



-(void)prepareTableView{
    self.groupedExcersice =[[NSMutableArray alloc]init];
    for(int i=0;i<[self.excersiceList count];i++){
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
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"mycell";
    CustomExcersiceCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil){
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
    cell.DurationLabel.text = [[workout time] stringByAppendingString:@" minutes."];
    cell.focusLabel.text=[workout focus];
    cell.ExcersiceImage.image =[self imageForRowAtIndexPath:workout inIndexPath:indexPath];
    if (workout.isChecked) {
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
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString  *storeURL= [dataPath stringByAppendingPathComponent :[workout imageName]];
    UIImageView *excersiceImageHolder =[[UIImageView alloc]init];
    
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
    
    if ([[tableView cellForRowAtIndexPath:indexPath] accessoryType] == UITableViewCellAccessoryCheckmark){
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
        [[self.excersiceList objectAtIndex:indexPath.section] setIsChecked:NO];
        [self removeExcerisce:[[self.excersiceList objectAtIndex:indexPath.section] excersiceID]];
        self.videoCount--;
        self.totalDuration=self.totalDuration- [[[self.excersiceList objectAtIndex:indexPath.section] time]intValue];
    }else{
        
        [[tableView cellForRowAtIndexPath:indexPath]setAccessoryType:UITableViewCellAccessoryCheckmark];
        [[self.excersiceList objectAtIndex:indexPath.section] setIsChecked:YES];
        [self AddExcersice:[self.excersiceList objectAtIndex:indexPath.section]];
        self.videoCount++;
        self.totalDuration=self.totalDuration+ [[[self.excersiceList objectAtIndex:indexPath.section] time]intValue];
    }
    [self performSelector:@selector(deselect:) withObject:nil afterDelay:0.5f];
    [self.totalVideoCountLabel setText:[NSString stringWithFormat:@"Number of excersices [%i]",self.videoCount]];
    [self.durationLabel setText:[NSString stringWithFormat:@"Total Time [%i]",self.totalDuration]];
    
}

-(void)removeExcerisce:(NSString*)ExcersiceID

{
    NSMutableArray *foundObjects = [NSMutableArray array];
    if ([GlobalArray count]>0) {
        for (ExcersiceList *excersices in GlobalArray)
        {
            NSLog(@"Excersices ID %@",[excersices excersiceID]);
            if ([[excersices excersiceID] isEqualToString:ExcersiceID]) {
                [foundObjects addObject:excersices];
                break;
            }
        }
        [GlobalArray removeObjectsInArray:foundObjects];
    }
}


-(void)AddExcersice:(ExcersiceList*)excersice

{
    if ([GlobalArray count]>0) {
        for (ExcersiceList *excersices in GlobalArray)
        {
            if ([[excersices excersiceID] isEqualToString:[excersice excersiceID]]) {
                break;
            }else{
                [GlobalArray addObject:excersice];
                break;
            }
        }
    }else{
        [GlobalArray addObject:excersice];
    }
}



- (void) deselect: (id) sender {
    [self.excersiceListTableview deselectRowAtIndexPath:[self.excersiceListTableview indexPathForSelectedRow] animated:YES];
}


-(IBAction)onClickNext:(id)sender
{
    NSString *str= [[NSString alloc]init];
    str =@"";
    for (ExcersiceList *excersice in self.excersiceList) {
        if ([excersice isChecked]) {
            if ([str length]==0) {
                str =[str stringByAppendingString:[excersice excersiceID]];
            }else{
                str=[str stringByAppendingString:@","];
                str =[str stringByAppendingString:[excersice excersiceID]];
            }
        }
    }
    
    [userinfo setObject:str forKey:@"SelectedWorkouts"];
    if ([GlobalArray count]>0) {
        CarouselViewDemoViewController *viewController;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            viewController =[[CarouselViewDemoViewController alloc]initWithNibName:@"CarouselViewDemoViewController" bundle:nil];
        }else {
            viewController =[[CarouselViewDemoViewController alloc]initWithNibName:@"CarouselViewDemoViewController" bundle:nil];
        }
        [viewController setEquipments:self.equipments];
        [viewController setFocusList:self.focusList];
        [viewController setDataSourceArray:GlobalArray];
        [self.navigationController pushViewController:viewController animated:YES];
        
    }else{
        [Fitness4MeUtils showAlert:@"Please select the excersice"];
    }
}

-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setExcersiceListTableview:nil];
    [self setDurationLabel:nil];
    [self setTotalVideoCountLabel:nil];
    [self setExcersiceList:nil];
    [self setTotalDuration:0];
    [self setVideoCount:0];
    [super viewDidUnload];
}
@end
