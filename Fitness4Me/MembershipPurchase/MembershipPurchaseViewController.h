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
@interface MembershipPurchaseViewController : UIViewController<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    Workout * workout;
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
    NSString *productIdentifier;
}
@property(strong,nonatomic)NSString *workoutType;
@property (retain,nonatomic)Workout *workout;
@property (retain,nonatomic)NSString *navigateTo;
- (IBAction)onClickQuit:(id)sender;
- (IBAction)onClicksubscribe:(id)sender;

@end
