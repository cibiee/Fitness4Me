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
#import "Workout.h"
#import "NameViewController.h"

@interface EquipmentViewController : UIViewController
{
    Workout *workout;
    NSUserDefaults *userinfo;
}
@property (weak, nonatomic) IBOutlet UITableView *equipmentsTableView;

@property (strong, nonatomic)  EquipmentDB *equipmentDB;
@property (strong, nonatomic)  Equipments *equipment;
@property (strong, nonatomic)Workout *workout;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

-(IBAction)onClickBack:(id)sender;
-(IBAction)onClickNext:(id)sender;
@end
