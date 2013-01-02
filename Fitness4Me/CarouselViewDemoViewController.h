//
//  CarouselViewDemoViewController.h
//  CarouselViewDemo
//
//  Created by kastet on 14.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CarouselView.h"
#import "CarouselViewCell.h"
#import "Workout.h"

@interface CarouselViewDemoViewController : UIViewController <CarouselViewDataSource, CarouselViewDelegate> {
    CarouselView *_carouselView;
    NSMutableArray *_dataSourceArray;
	IBOutlet UISegmentedControl *_animationSegmentedControl;
	IBOutlet UIButton *_removeSelectedButton;
     Workout *workout;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *moveSegmentControl;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *recoverySegmentControl;
@property (strong, nonatomic)Workout *workout;
@property (nonatomic, retain) NSMutableArray *dataSourceArray;
@property(strong,nonatomic) NSString *focusList;
@property(strong,nonatomic) NSString *equipments;
- (IBAction)onClickMove:(id)sender;
-(IBAction)onClickBack:(id)sender;
-(IBAction) segmentedControlIndexChanged;
- (IBAction)removeSelectedColumn;
- (IBAction)removeMultipleColumns;

@end
