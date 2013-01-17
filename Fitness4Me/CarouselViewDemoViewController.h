//
//  CarouselViewDemoViewController.h
//  CarouselViewDemo
//
//  Created by kastet on 14.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "Workout.h"
#import "CarouselView.h"
#import "FitnessServer.h"
#import "ExcersiceList.h"
#import "CarouselViewCell.h"
#import "NameViewController.h"
#import  "FocusViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface CarouselViewDemoViewController : UIViewController <CarouselViewDataSource, CarouselViewDelegate> {
    CarouselView *_carouselView;
    NSMutableArray *_dataSourceArray;
	IBOutlet UISegmentedControl *_animationSegmentedControl;
	IBOutlet UIButton *_removeSelectedButton;
     Workout *workout;
    NSUserDefaults *userinfo;
}

@property int videoCount;
@property int totalDuration;
@property (strong, nonatomic)Workout *workout;
@property(strong,nonatomic) NSString *focusList;
@property(strong,nonatomic) NSString *equipments;
@property(strong,nonatomic)NSString *operationMode;
@property (nonatomic, retain) NSMutableArray *dataSourceArray;
@property (weak, nonatomic) IBOutlet UILabel *backgroundLabel;

@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalVideoCountLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UIButton *addMoreButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *moveSegmentControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *recoverySegmentControl;



-(IBAction)onClickMove:(id)sender;
-(IBAction)onClickBack:(id)sender;
-(IBAction) segmentedControlIndexChanged;
-(IBAction)removeSelectedColumn;
-(IBAction)addMoreExcersices:(id)sender;

@end

