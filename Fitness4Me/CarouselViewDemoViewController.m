//
//  CarouselViewDemoViewController.m
//  CarouselViewDemo
//
//  Created by kastet on 14.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CarouselViewDemoViewController.h"
#import "ExcersiceList.h"
#import "NameViewController.h"



@implementation CarouselViewDemoViewController
@synthesize workout;

@synthesize dataSourceArray = _dataSourceArray;

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSourceArray = [[NSMutableArray alloc]init];

    }
    return self;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.transform = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeRotation(M_PI_2));
    [self.recoverySegmentControl setSelectedSegmentIndex:-1];

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
    

    
	[_removeSelectedButton setEnabled:NO];
	
    _carouselView = [[CarouselView alloc] initWithFrame:CGRectMake(2, 50, 480, 120)
                                             dataSource:self 
                                               delegate:self];
    _carouselView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_dataSourceArray =self.dataSourceArray;
	[self.view addSubview:_carouselView];
}

- (void)viewDidUnload {
    [self setRecoverySegmentControl:nil];
    [super viewDidUnload];
}


#pragma mark - Carousel DataSource

- (NSInteger)numberOfColumnsForCarouselView:(CarouselView *)carouselView {

    return [_dataSourceArray count];
}

- (CarouselViewCell *)carouselView:(CarouselView *)carouselView cellForColumnAtIndex:(NSInteger)index {
    
    CarouselViewCell *cell = [carouselView dequeueReusableCell];
    if (cell == nil) {
        cell = [[CarouselViewCell alloc] init];
        ExcersiceList *excersiceList= [_dataSourceArray objectAtIndex:index];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyFolder/SelfMadeThumbs"];
        NSString  *storeURL= [dataPath stringByAppendingPathComponent :[excersiceList imageName]];
        cell.ExcersiceImage.image= [[UIImage alloc]initWithContentsOfFile:storeURL];
        [cell.titleLabel setText:[excersiceList name]];
    }
    return cell;
}

#pragma mark - CarouselView Delegate

- (void)carouselView:(CarouselView *)carouselView didSelectCellAtIndex:(NSInteger)index {
	[_removeSelectedButton setEnabled:YES];
}

#pragma - Helper Methods

- (NSString *)randomString {	
	NSMutableString *randomString = [NSMutableString stringWithCapacity:10];

	for (int i=0; i<10; i++) {
		[randomString appendFormat: @"%c", [letters characterAtIndex: rand()%[letters length]]];
	}
	
	return randomString;
}

#pragma mark - IBActions

- (IBAction)cleanRecyclePool {
    [_carouselView cleanCellsRecyclePool];
}

-(IBAction) segmentedControlIndexChanged{
    NSNumber *selectedIndex = [NSNumber numberWithInt:[_carouselView indexOfSelectedCell]+1];
    NSNumber *index = selectedIndex;
    ExcersiceList *list= [[ExcersiceList alloc]init];
    switch (self.recoverySegmentControl.selectedSegmentIndex) {
        case 0:
            list.name=@"recovery 15";
            list.imageName= @"dummyimg.png";
            [_dataSourceArray insertObject:list atIndex:[index intValue]];
            
            [_carouselView insertColumnsAtIndexes:[NSArray arrayWithObject:index] withColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
            break;
        case 1:
            list.name=@"recovery 30";
            list.imageName= @"dummyimg.png";
            [_dataSourceArray insertObject:list atIndex:[index intValue]];
            [_carouselView insertColumnsAtIndexes:[NSArray arrayWithObject:index] withColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
            break;
            
        default:
            break;
    }
    [self.recoverySegmentControl setSelectedSegmentIndex:-1];

}

-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)onClickNext:(id)sender{
//    NSString *str= [[NSString alloc]init];
//    str =@"";
//    NSString *name= [[NSString alloc]init];
//    for (Equipments *equipment in self.equipments) {
//        if ([equipment isChecked]) {
//            if ([str length]==0) {
//                str =[str stringByAppendingString:[equipment equipmentID]];
//                name =[name stringByAppendingString:[equipment equipmentName]];
//            }
//            else{
//                str=[str stringByAppendingString:@","];
//                str =[str stringByAppendingString:[equipment equipmentID]];
//                name=[name stringByAppendingString:@","];
//                name =[name stringByAppendingString:[equipment equipmentName]];
//            }
//            
//        }
//    }
//    
//    Workout *workouts= [[Workout alloc]init];
//    if ([[workout WorkoutID]intValue]>0) {
//        WorkoutDB *workoutDB =[[WorkoutDB alloc]init];
//        [workoutDB setUpDatabase];
//        [workoutDB createDatabase];
//        workouts =[workoutDB getCustomWorkoutByID:[workout WorkoutID]];
//    }
//    [workouts setDuration:workout.Duration];
//    [workouts setFocus:workout.Focus];
//    [workouts setFocusName:name];
//    [workouts setProps:str];
//    
//    
//    
//    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
//    NSString *workoutType =[userinfo stringForKey:@"workoutType"];
//    
//    if ([workoutType isEqualToString:@"Custom"]) {
        NameViewController *viewController =[[NameViewController alloc]initWithNibName:@"NameViewController" bundle:nil];
        viewController.workout= [[Workout alloc]init];
        viewController.workout =workouts;
        [self.navigationController pushViewController:viewController animated:YES];
//    }
//    else
//    {
//        ExcersiceListViewController *viewController;
//        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
//            viewController =[[ExcersiceListViewController alloc]initWithNibName:@"ExcersiceListViewController" bundle:nil];
//        }else {
//            viewController =[[ExcersiceListViewController alloc]initWithNibName:@"ExcersiceListViewController" bundle:nil];
//        }
//        [viewController setFocusList:[workout Focus]];
//        [viewController setEquipments:str];
//        [self.navigationController pushViewController:viewController animated:YES];
//    }
}


- (IBAction)addColumn {
    NSNumber *selectedIndex = [NSNumber numberWithInt:[_carouselView indexOfSelectedCell]+1];
	NSNumber *index = selectedIndex;
	//NSString *newObj = [self randomString];
    ExcersiceList *list= [[ExcersiceList alloc]init];
    
    list.name=@"recovery 15";
    list.imageName= @"dummyimg.png";
	[_dataSourceArray insertObject:list atIndex:[index intValue]];
	
    [_carouselView insertColumnsAtIndexes:[NSArray arrayWithObject:index] withColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
}

- (IBAction)addMultipleColumns {
	NSMutableArray *array = [NSMutableArray array];
	
	for (int i = 0; i < 5; i++) {
		NSString *newObj = [self randomString];
		[_dataSourceArray insertObject:newObj atIndex:0];
		[array addObject:[NSNumber numberWithInt:i]];
	}
	
	[_carouselView insertColumnsAtIndexes:array withColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
}

- (IBAction)removeSelectedColumn {
	NSNumber *selectedIndex = [NSNumber numberWithInt:[_carouselView indexOfSelectedCell]];
	[_dataSourceArray removeObjectAtIndex:[selectedIndex intValue]];
	[_carouselView deleteColumnsAtIndexes:[NSArray arrayWithObject:selectedIndex] withColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
	
	[_removeSelectedButton setEnabled:NO];
}

- (IBAction)removeMultipleColumns {
	if ([_dataSourceArray count] < 3) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Enough Data" 
														message:@"Need at least 3 columns to be able to delete multiple" 
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		return;
	}
	
	NSMutableArray *array = [NSMutableArray array];
	
	for (int i = 0; i < 3; i++) {
		[_dataSourceArray removeObjectAtIndex:0];
		[array addObject:[NSNumber numberWithInt:i]];
	}
	
	[_carouselView deleteColumnsAtIndexes:array withColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
	
}


#pragma mark - view orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate {
    return YES;
}


@end
