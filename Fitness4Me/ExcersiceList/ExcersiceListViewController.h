//
//  ExcersiceListViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 12/12/12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ASINetworkQueue.h"
#import "ExcersiceList.h"
#import "CarouselViewDemoViewController.h"

@interface ExcersiceListViewController : UIViewController<UIScrollViewDelegate>
{
     ASINetworkQueue  *myQueue;
     NSString *dataPath;
    
}

@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalVideoCountLabel;
@property (nonatomic,retain) ASINetworkQueue *myQueue;
@property (strong, nonatomic)ExcersiceList *focus;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *excersiceListTableview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(strong,nonatomic) NSString *focusList;
@property(strong,nonatomic) NSString *equipments;
@end
