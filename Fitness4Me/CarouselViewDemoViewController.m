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

//@synthesize dataSourceArray = _dataSourceArray;

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSourceArray = [[NSMutableArray alloc]init];
        userinfo=[NSUserDefaults standardUserDefaults];
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
    [self.moveSegmentControl setSelectedSegmentIndex:-1];
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
	//_dataSourceArray =nil;
	[self.view addSubview:_carouselView];
}

- (void)viewDidUnload {
    [self setRecoverySegmentControl:nil];
    [self setMoveSegmentControl:nil];
    [super viewDidUnload];
}


#pragma mark - Carousel DataSource

- (NSInteger)numberOfColumnsForCarouselView:(CarouselView *)carouselView {
    
    return [self.dataSourceArray count];
}

- (CarouselViewCell *)carouselView:(CarouselView *)carouselView cellForColumnAtIndex:(NSInteger)index {
    
    CarouselViewCell *cell = [carouselView dequeueReusableCell];
    if (cell == nil) {
        cell = [[CarouselViewCell alloc] init];
        ExcersiceList *excersiceList= [self.dataSourceArray objectAtIndex:index];
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



#pragma mark - IBActions

- (IBAction)cleanRecyclePool {
    [_carouselView cleanCellsRecyclePool];
}

-(IBAction) segmentedControlIndexChanged{
    NSNumber *selectedIndex = [NSNumber numberWithInt:[_carouselView indexOfSelectedCell]+1];
    NSNumber *index = selectedIndex;
    ExcersiceList *list= [[ExcersiceList alloc]init];
    NSMutableArray *arrays= [[NSMutableArray alloc]init];
    if ([index intValue]>0) {
        
        [_carouselView deleteAllColumnswithColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
        switch (self.recoverySegmentControl.selectedSegmentIndex) {
            case 0:
                
                list.name=@"recovery 15";
                list.imageName= @"dummyimg.png";
                list.excersiceID=@"rec15";
                [self.dataSourceArray insertObject:list atIndex:[index intValue]];
                
                for (int i = 0; i < [self.dataSourceArray count]; i++) {
                    [arrays addObject:[NSNumber numberWithInt:i]];
                }
                [_carouselView insertColumnsAtIndexes:arrays withColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
                
                break;
            case 1:
                list.name=@"recovery 30";
                list.imageName= @"dummyimg.png";
                list.excersiceID=@"rec30";
                [self.dataSourceArray insertObject:list atIndex:[index intValue]];
                for (int i = 0; i < [self.dataSourceArray count]; i++) {
                    [arrays addObject:[NSNumber numberWithInt:i]];
                }
                [_carouselView insertColumnsAtIndexes:arrays withColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
                
                break;
                
            default:
                break;
        }
    }
    [self.recoverySegmentControl setSelectedSegmentIndex:-1];
    
}

- (IBAction)onClickMove:(id)sender {
    int selectedIndex =[_carouselView indexOfSelectedCell];
    NSMutableArray *arrays= [[NSMutableArray alloc]init];
    switch (self.moveSegmentControl.selectedSegmentIndex) {
        case 0:
            if (selectedIndex>0) {
                [_carouselView deleteAllColumnswithColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
                [self.dataSourceArray exchangeObjectAtIndex:selectedIndex withObjectAtIndex:selectedIndex-1];
                for (int i = 0; i < [self.dataSourceArray count]; i++) {
                    [arrays addObject:[NSNumber numberWithInt:i]];
                }
                [_carouselView insertColumnsAtIndexes:arrays withColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
            }
            
            break;
        case 1:
            
            if (selectedIndex<[self.dataSourceArray count]-1) {
                [_carouselView deleteAllColumnswithColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
                [self.dataSourceArray exchangeObjectAtIndex:selectedIndex withObjectAtIndex:selectedIndex+1];
                for (int i = 0; i < [self.dataSourceArray count]; i++) {
                    [arrays addObject:[NSNumber numberWithInt:i]];
                }
                [_carouselView insertColumnsAtIndexes:arrays withColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
            }
            break;
            
            
        case 2:
            
            [self removeSelectedColumn];
            break;
        default:
            break;
    }
    
    [self.moveSegmentControl setSelectedSegmentIndex:-1];
}

-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)onClickNext:(id)sender{
    
    NSString *str= [[NSString alloc]init];
    for (ExcersiceList *excerlist in self.dataSourceArray) {
        
        if ([str length]==0) {
            str =[str stringByAppendingString:[excerlist excersiceID]];
        }
        else{
            str=[str stringByAppendingString:@","];
            str =[str stringByAppendingString:[excerlist excersiceID]];
        }
    }
    
    [userinfo setObject:str forKey:@"SelectedWorkouts"];
   
    NameViewController *viewController =[[NameViewController alloc]initWithNibName:@"NameViewController" bundle:nil];
    viewController.workout= [[Workout alloc]init];
    viewController.workout =nil;
    [viewController setCollectionString:str];
    [viewController setEquipments:self.equipments];
    [viewController setFocusList:self.focusList];

    [self.navigationController pushViewController:viewController animated:YES];
}





- (IBAction)removeSelectedColumn {
    if ([_dataSourceArray count]>0) {
        NSMutableArray *arrays= [[NSMutableArray alloc]init];
        NSNumber *selectedIndex = [NSNumber numberWithInt:[_carouselView indexOfSelectedCell]];
        [self.dataSourceArray removeObjectAtIndex:[selectedIndex intValue]];
        [_carouselView deleteAllColumnswithColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
        
        for (int i = 0; i < [self.dataSourceArray count]; i++) {
            [arrays addObject:[NSNumber numberWithInt:i]];
        }
        [_carouselView insertColumnsAtIndexes:arrays withColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
	    [_removeSelectedButton setEnabled:NO];
        
  
    
    
    NSString *str= [[NSString alloc]init];
    for (ExcersiceList *excerlist in self.dataSourceArray) {
        
        if ([str length]==0) {
            
            str =[str stringByAppendingString:[excerlist excersiceID]];
           
        }
        else{
            str=[str stringByAppendingString:@","];
            str =[str stringByAppendingString:[excerlist excersiceID]];
             
        }
    }
    
    [userinfo setObject:str forKey:@"SelectedWorkouts"];
    
     NSString *selectedWorkouts = [userinfo objectForKey:@"SelectedWorkouts"];
        NSLog(selectedWorkouts);
          }
    
}

- (IBAction)removeMultipleColumns {
	if ([self.dataSourceArray count] < 3) {
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
		[self.dataSourceArray removeObjectAtIndex:0];
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
