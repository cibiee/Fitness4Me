//
//  EquipmentViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 03/12/12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EquipmentDB.h"
#import "Equipments.h"

@interface EquipmentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *equipmentsTableView;

@property (strong, nonatomic)  EquipmentDB *equipmentDB;
@property (strong, nonatomic)  Equipments *equipment;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

-(IBAction)onClickBack:(id)sender;
-(IBAction)onClickNext:(id)sender;
@end
