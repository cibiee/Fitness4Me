//
//  CarouselViewDemoViewController.m
//  CarouselViewDemo
//
//  Created by kastet on 14.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CarouselViewDemoViewController.h"
#import "ASIHTTPRequest.h"


@interface CarouselViewDemoViewController ()

@end
@implementation CarouselViewDemoViewController
@synthesize workout,myQueue;

//@synthesize dataSourceArray = _dataSourceArray;

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        myQueue=[[ASINetworkQueue alloc]init];
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
    UIButton *backutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backutton.frame = CGRectMake(0, 0, 58, 30);
    [backutton setBackgroundImage:[UIImage imageNamed:@"back_btnBlack.png"] forState:UIControlStateNormal];
    [backutton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [backutton.titleLabel setTextAlignment:UITextAlignmentRight];
    [backutton setTitle:NSLocalizedStringWithDefaultValue(@"back", nil,[Fitness4MeUtils getBundle], nil, nil) forState:UIControlStateNormal];
    [backutton addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:backutton];
    self.navigationBar.leftBarButtonItem = backBtn;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0, 0, 58, 30);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"next_btn_with_text.png"] forState:UIControlStateNormal];
     [nextButton setTitle:NSLocalizedStringWithDefaultValue(@"next", nil,[Fitness4MeUtils getBundle], nil, nil) forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [nextButton.titleLabel setTextAlignment:UITextAlignmentRight];
    
    [nextButton addTarget:self action:@selector(onClickNext:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    self.navigationBar.rightBarButtonItem = nextBtn;
    [self.backgroundLabel.layer setCornerRadius:10];
    [self createSelfmadeImageDirectory];
    
    [self.totalVideoCountLabel setText:[NSString stringWithFormat:@"%@ %i",NSLocalizedStringWithDefaultValue(@"numberOfExcersice", nil,[Fitness4MeUtils getBundle], nil, nil),self.videoCount]];
    
    [self.durationLabel setText:[NSString stringWithFormat:@"%@ %@",NSLocalizedStringWithDefaultValue(@"totalTime", nil,[Fitness4MeUtils getBundle], nil, nil),[Fitness4MeUtils displayTimeWithSecond:self.totalDuration]]];
    

    
    self.view.transform = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeRotation(M_PI_2));
    [self.recoverySegmentControl setSelectedSegmentIndex:-1];
    [self.moveSegmentControl setSelectedSegmentIndex:-1];
      
    if ([self.operationMode isEqualToString:@"Edit"]) {
        
    }
    else
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            [self.addMoreButton removeFromSuperview];
            [self.bgImageView setFrame:CGRectMake(0,276,480 , 33)];
            [self.totalVideoCountLabel setFrame:CGRectMake(290,282,158,21)];
        }else
        {
             [self.addMoreButton removeFromSuperview];
        }
         

    }
    self.carousel.type = iCarouselTypeCoverFlow2;
    if([GlobalArray count]>2)
    {
     [self.carousel scrollToItemAtIndex:1 animated:NO];
    }
    
}

- (void)createSelfmadeImageDirectory
{
    
    
    NSArray *VideoArray =[NSArray arrayWithObjects:@"page_15.png",@"page_30.png",nil];
    
    
    BOOL success;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyFolder/SelfMadeThumbs"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    for (NSString *name in VideoArray) {
        NSString *datapath1=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:name];
        NSString *datapath2=[dataPath stringByAppendingPathComponent:name];
        NSFileManager *filemanager =[NSFileManager defaultManager];
        success =[filemanager  fileExistsAtPath:datapath1];
        if(success){
            if (![[NSFileManager defaultManager] fileExistsAtPath:datapath2]){
                [filemanager copyItemAtPath:datapath1 toPath:datapath2 error:nil];
            }
        }
    }
}
- (void)viewDidUnload {
    [self setRecoverySegmentControl:nil];
    [self setMoveSegmentControl:nil];
    [self setBackgroundLabel:nil];
    [super viewDidUnload];
}


#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
   
    //return the total number of items in the carousel
    return [GlobalArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
   // UIImageView *excersiceImage=nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)] autorelease];
       // ((UIImageView *)view).image = [self imageForRowAtIndexPath:[GlobalArray objectAtIndex:index] inIndexPath:index];
        view.contentMode = UIViewContentModeTop;
        label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 130, 30)] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.font = [label.font fontWithSize:12];
        label.tag = 1;
        label.textColor=[UIColor blackColor];
        [view addSubview:label];
        //excersiceImage=[[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)] autorelease];
        
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
        
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    if ([[[GlobalArray objectAtIndex:index] name]length]>0) {
    label.text = [[GlobalArray objectAtIndex:index] name];
     ((UIImageView *)view).image = [self imageForRowAtIndexPath:[GlobalArray objectAtIndex:index] inIndexPath:index];
    
         }
    return view;
}


- (UIImage *)imageForRowAtIndexPath:(ExcersiceList *)excersiceList inIndexPath:(NSUInteger)indexPath
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyFolder/SelfMadeThumbs"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
   
    
    NSString  *storeURL= [dataPath stringByAppendingPathComponent :[excersiceList imageName]];
    UIImageView *excersiceImageHolder =[[UIImageView alloc]init];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:storeURL]){
        UIImage *im =[UIImage imageNamed:@"page.png"];
        excersiceImageHolder.image =im;
        [self.myQueue setDelegate:self];
        [self.myQueue setShowAccurateProgress:YES];
        [self.myQueue setRequestDidFinishSelector:@selector(requestFinisheds:)];
        NSLog([excersiceList imageUrl]);
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[[excersiceList imageUrl]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [request setDownloadDestinationPath:storeURL];
        [request setDelegate:self];
       // [request startAsynchronous];
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
    [self.carousel reloadData];
}


#pragma mark - Carousel DataSource

- (void)carousel: (iCarousel *)_carousel didSelectItemAtIndex:(NSInteger)index
{
    [self.carousel itemViewAtIndex:index].alpha=.8f;
    [self.carousel itemViewAtIndex: self.selectedIndex].alpha=1; 
     self.selectedIndex=index;
}


#pragma mark - IBActions


-(IBAction) segmentedControlIndexChanged:(id)sender {
    
    
    ExcersiceList *list= [[ExcersiceList alloc]init];
    
    //self.selectedIndex =[sender tag];
    if (self.selectedIndex >0) {
        
        
        switch ([sender tag]) {
            case 0:
                
                list.name=@"Recovery 15";
                list.imageName= @"page_15.png";
                list.excersiceID=@"rec15";
                list.time=@"15";
                list.repetitions=@"1";
                [GlobalArray insertObject:list atIndex: self.selectedIndex];
               // self.videoCount++;
                self.totalDuration=self.totalDuration+ 15;
                
                
                break;
            case 1:
                list.name=@"Recovery 30";
                list.imageName= @"page_30.png";
                list.excersiceID=@"rec30";
                list.time=@"30";
                list.repetitions=@"1";
                [GlobalArray insertObject:list atIndex: self.selectedIndex];
                //self.videoCount++;
                self.totalDuration=self.totalDuration+ 30;
                break;
                
            default:
                break;
        }
    }
    
    [self.carousel reloadData];
     [self.durationLabel setText:[NSString stringWithFormat:@"%@ %@",NSLocalizedStringWithDefaultValue(@"totalTime", nil,[Fitness4MeUtils getBundle], nil, nil),[Fitness4MeUtils displayTimeWithSecond:self.totalDuration]]];
    [self.recoverySegmentControl setSelectedSegmentIndex:-1];
    
}

- (IBAction)onClickMove:(id)sender {
    switch ([sender tag]) {
        case 0:
            if ( self.selectedIndex>0) {
                [GlobalArray exchangeObjectAtIndex: self.selectedIndex withObjectAtIndex: self.selectedIndex-1];
            }
            
            break;
        case 1:
            
            if (self.selectedIndex<[GlobalArray count]-1) {
                
                [GlobalArray exchangeObjectAtIndex:self.selectedIndex withObjectAtIndex:self.selectedIndex+1];
                
            }
            break;
            
            
        case 2:
            [self removeSelectedColumn];
            break;
        default:
            break;
    }
    [self.carousel reloadData];
    self.selectedIndex=-1;
    [self.moveSegmentControl setSelectedSegmentIndex:-1];
}

-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)onClickNext:(id)sender{
    
     if (self.videoCount>0) {
    
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
         NameViewController *viewController;
         
         if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
             viewController =[[NameViewController alloc]initWithNibName:@"NameViewController" bundle:nil];
         }else {
             viewController =[[NameViewController alloc]initWithNibName:@"NameViewController_iPad" bundle:nil];
         }
         
    viewController.workout= [[Workout alloc]init];
     viewController.workout =self.workout;
       
    [viewController.workout setName:self.name];

    [viewController setCollectionString:str];
    [viewController setEquipments:self.equipments];
    [viewController setName:self.name];
    
    [viewController setFocusList:self.focusList];
    
    [self.navigationController pushViewController:viewController animated:YES];
     }
    else
    {
    [self showAlertwithMsg:NSLocalizedStringWithDefaultValue(@"Selectoneexcersice", nil,[Fitness4MeUtils getBundle], nil, nil)];
    }
}


- (IBAction)removeSelectedColumn {
    if (self.selectedIndex >-1) {
        
        if ([GlobalArray count]>1) {
            self.videoCount--;
            self.totalDuration=self.totalDuration- ([[[GlobalArray objectAtIndex:self.selectedIndex] time]intValue]*[[[GlobalArray objectAtIndex:self.selectedIndex] repetitions]intValue]);
            [GlobalArray removeObjectAtIndex:self.selectedIndex];
            [self.totalVideoCountLabel setText:[NSString stringWithFormat:@"%@ %i",NSLocalizedStringWithDefaultValue(@"numberOfExcersice", nil,[Fitness4MeUtils getBundle], nil, nil),self.videoCount]];
             [self.durationLabel setText:[NSString stringWithFormat:@"%@ %@",NSLocalizedStringWithDefaultValue(@"totalTime", nil,[Fitness4MeUtils getBundle], nil, nil),[Fitness4MeUtils displayTimeWithSecond:self.totalDuration]]];
            
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
        else{
            [self showAlertwithMsg:NSLocalizedStringWithDefaultValue(@"Notenoughworkouts", nil,[Fitness4MeUtils getBundle], nil, nil)];
        }
    
}
else{
    [self showAlertwithMsg:NSLocalizedStringWithDefaultValue(@"Selectworkout", nil,[Fitness4MeUtils getBundle], nil, nil)];
}

}


-(void)showAlertwithMsg:(NSString*)message
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Fitness4.me" message:message
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.0];
    alertview.transform = CGAffineTransformRotate(alertview.transform, 3.14159/2);
    [UIView commitAnimations];
    
    
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    // UIAlertView in landscape mode
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.0];
    alertView.transform = CGAffineTransformRotate(alertView.transform, 3.14159/2);
    [UIView commitAnimations];
}



- (IBAction)addMoreExcersices:(id)sender {
    FocusViewController *viewController;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[FocusViewController alloc]initWithNibName:@"FocusViewController" bundle:nil];
    }else {
        viewController =[[FocusViewController alloc]initWithNibName:@"FocusViewController_iPad" bundle:nil];
    }

     
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
