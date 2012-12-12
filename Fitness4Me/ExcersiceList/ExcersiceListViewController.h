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

@interface ExcersiceListViewController : UIViewController
{
    ASINetworkQueue  *myQueue;
     NSString *dataPath;
}
@property (nonatomic,retain) ASINetworkQueue *myQueue;
@property (strong, nonatomic)ExcersiceList *focus;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *excersiceListTableview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
