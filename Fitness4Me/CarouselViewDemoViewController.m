//
//  CarouselViewDemoViewController.m
//  CarouselViewDemo
//
//  Created by kastet on 14.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CarouselViewDemoViewController.h"


@interface CarouselViewDemoViewController ()

@end
@implementation CarouselViewDemoViewController
@synthesize workout;

//@synthesize dataSourceArray = _dataSourceArray;

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
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
    
    [self.backgroundLabel.layer setCornerRadius:10];
    [self.totalVideoCountLabel setText:[NSString stringWithFormat:@"Number of excersices [%i]",self.videoCount]];
    [self.durationLabel setText:[NSString stringWithFormat:@"Total Time [%@]",[Fitness4MeUtils displayTimeWithSecond:self.totalDuration]]];

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
    
    if ([self.operationMode isEqualToString:@"Edit"]) {
        
    }
    else
    {
        [self.addMoreButton removeFromSuperview];
    }
    
	[_removeSelectedButton setEnabled:NO];
    _carouselView = [[CarouselView alloc] initWithFrame:CGRectMake(2, 50, 480, 120)
                                             dataSource:self
                                               delegate:self];
    _carouselView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	[self.view addSubview:_carouselView];
}

- (void)viewDidUnload {
    [self setRecoverySegmentControl:nil];
    [self setMoveSegmentControl:nil];
    [self setBackgroundLabel:nil];
    [super viewDidUnload];
}


#pragma mark - Carousel DataSource

- (NSInteger)numberOfColumnsForCarouselView:(CarouselView *)carouselView {
    
    return [GlobalArray count];
}

- (CarouselViewCell *)carouselView:(CarouselView *)carouselView cellForColumnAtIndex:(NSInteger)index {
    
    CarouselViewCell *cell = [carouselView dequeueReusableCell];
    if (cell == nil) {
        cell = [[CarouselViewCell alloc] init];
        ExcersiceList *excersiceList =[[ExcersiceList alloc]init];
        excersiceList= [GlobalArray objectAtIndex:index];
        
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
                 list.time=@"900";
                list.repetitions=@"1";
                [GlobalArray insertObject:list atIndex:[index intValue]];
                
                for (int i = 0; i < [GlobalArray count]; i++) {
                    [arrays addObject:[NSNumber numberWithInt:i]];
                }
                self.videoCount++;
                 self.totalDuration=self.totalDuration+ 900;
                [_carouselView insertColumnsAtIndexes:arrays withColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
                
                break;
            case 1:
                list.name=@"recovery 30";
                list.imageName= @"dummyimg.png";
                list.excersiceID=@"rec30";
                list.time=@"1800";
                list.repetitions=@"1";
                [GlobalArray insertObject:list atIndex:[index intValue]];
                for (int i = 0; i < [GlobalArray count]; i++) {
                    [arrays addObject:[NSNumber numberWithInt:i]];
                }
                self.videoCount++;
                self.totalDuration=self.totalDuration+ 1800;
                [_carouselView insertColumnsAtIndexes:arrays withColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
                
                
                
                break;
                
            default:
                break;
        }
    }
    [self.durationLabel setText:[NSString stringWithFormat:@"Total Time [%@]",[Fitness4MeUtils displayTimeWithSecond:self.totalDuration]]];
 
    //[Fitness4MeUtils displayTimeWithSecond:self.totalDuration];
    
    [self.recoverySegmentControl setSelectedSegmentIndex:-1];
    
}

- (IBAction)onClickMove:(id)sender {
    int selectedIndex =[_carouselView indexOfSelectedCell];
    NSMutableArray *arrays= [[NSMutableArray alloc]init];
    switch (self.moveSegmentControl.selectedSegmentIndex) {
        case 0:
            if (selectedIndex>0) {
                [_carouselView deleteAllColumnswithColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
                [GlobalArray exchangeObjectAtIndex:selectedIndex withObjectAtIndex:selectedIndex-1];
                for (int i = 0; i < [GlobalArray count]; i++) {
                    [arrays addObject:[NSNumber numberWithInt:i]];
                }
                [_carouselView insertColumnsAtIndexes:arrays withColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
            }
            
            break;
        case 1:
            
            if (selectedIndex<[GlobalArray count]-1) {
                [_carouselView deleteAllColumnswithColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
                [GlobalArray exchangeObjectAtIndex:selectedIndex withObjectAtIndex:selectedIndex+1];
                for (int i = 0; i < [GlobalArray count]; i++) {
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
    for (ExcersiceList *excerlist in GlobalArray) {
        
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
    if ([GlobalArray count]>1) {
        NSMutableArray *arrays= [[NSMutableArray alloc]init];
        NSNumber *selectedIndex = [NSNumber numberWithInt:[_carouselView indexOfSelectedCell]];
        self.videoCount--;
        self.totalDuration=self.totalDuration- ([[[GlobalArray objectAtIndex:[_carouselView indexOfSelectedCell]] time]intValue]*[[[GlobalArray objectAtIndex:[_carouselView indexOfSelectedCell]] repetitions]intValue]);
        [GlobalArray removeObjectAtIndex:[selectedIndex intValue]];
        [_carouselView deleteAllColumnswithColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
       
        for (int i = 0; i < [GlobalArray count]; i++) {
            [arrays addObject:[NSNumber numberWithInt:i]];
            
          
        }
        [self.totalVideoCountLabel setText:[NSString stringWithFormat:@"Number of excersices [%i]",self.videoCount]];
        [self.durationLabel setText:[NSString stringWithFormat:@"Total Time [%@]",[Fitness4MeUtils displayTimeWithSecond:self.totalDuration]]];


        [_carouselView insertColumnsAtIndexes:arrays withColumnAnimation:_animationSegmentedControl.selectedSegmentIndex];
	    [_removeSelectedButton setEnabled:NO];
        
        NSString *str= [[NSString alloc]init];
        for (ExcersiceList *excerlist in GlobalArray) {
            if ([str length]==0) {
                str =[str stringByAppendingString:[excerlist excersiceID]];
            }
            else{
                str=[str stringByAppendingString:@","];
                str =[str stringByAppendingString:[excerlist excersiceID]];
            }
        }
       
        [userinfo setObject:str forKey:@"SelectedWorkouts"];
    }
    
    
}



- (IBAction)addMoreExcersices:(id)sender {
    FocusViewController *viewController =[[FocusViewController alloc]initWithNibName:@"FocusViewController" bundle:nil];
    viewController.workout =[[Workout alloc]init];
    viewController .workout=self.workout;
    [self.navigationController pushViewController:viewController animated:YES];
    
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
