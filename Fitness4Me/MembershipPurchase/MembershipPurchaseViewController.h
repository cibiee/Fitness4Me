//
//  MembershipPurchaseViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 11/12/12.
//
//

#import <UIKit/UIKit.h>
#import "Workout.h"
#import "ShareFitness4MeViewController.h"
#import "ListWorkoutsViewController.h"
#import <StoreKit/StoreKit.h>
#import "Membership.h"
#import "MembershipDB.h"
#import "FitnessServer.h"
@interface MembershipPurchaseViewController : UIViewController<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    Workout * workout;
    FitnessServer *fitness;
    MembershipDB *membershipDB;
    Membership *selectedMembership;
    NSMutableArray *memberships;
    SKProduct *proUpgradeProduct;
    SKProduct *product;
    NSString *productIdentifier;
    SKProductsRequest *productsRequest;
    NSUserDefaults *userinfo;
}
@property(retain,nonatomic) NSMutableArray *memberships;
@property (retain,nonatomic)Workout *workout;
@property (retain,nonatomic) NSMutableArray *groupedMemberships;
@property(strong,nonatomic)NSString *workoutType;
@property (retain,nonatomic)NSString *navigateTo;


@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *planPopUpView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;

- (IBAction)onClickQuit:(id)sender;
- (IBAction)onClicksubscribe:(id)sender;
@end
