//
//  MembershipPurchaseViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 11/12/12.
//
//

#import "MembershipPurchaseViewController.h"
#import "CustomWorkoutsViewController.h"

@interface MembershipPurchaseViewController ()

@end

@implementation MembershipPurchaseViewController
@synthesize workout;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickQuit:(id)sender {
    if ([self.navigateTo isEqualToString:@"List"]) {
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        self.workoutType =[userinfo stringForKey:@"workoutType"];
        
        
            if ([self.workoutType isEqualToString:@"QuickWorkouts"]) {
                ListWorkoutsViewController *viewController;
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
                    viewController =[[ListWorkoutsViewController alloc]initWithNibName:@"ListWorkoutsViewController" bundle:nil];
                }else {
                    viewController =[[ListWorkoutsViewController alloc]initWithNibName:@"ListWorkoutsViewController_iPad" bundle:nil];
                }
                [self.navigationController pushViewController:viewController animated:YES];
                
                

        }
        
        
        else{
            CustomWorkoutsViewController *viewController;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
                viewController =[[CustomWorkoutsViewController alloc]initWithNibName:@"CustomWorkoutsViewController" bundle:nil];
            }else {
                //viewController =[[HintsViewController alloc]initWithNibName:@"CustomizedWorkoutListViewController_iPad" bundle:nil];
            }
            [viewController setWorkoutType:self.workoutType];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    }
    else
    {
        ShareFitness4MeViewController *viewController;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            viewController = [[ShareFitness4MeViewController alloc]initWithNibName:@"ShareFitness4MeViewController" bundle:nil];
        }
        else {
            viewController = [[ShareFitness4MeViewController alloc]initWithNibName:@"ShareFitness4MeViewController_iPad" bundle:nil];
        }
        viewController.workoutType=self.workoutType;
        viewController.imageUrl =[self.workout ImageUrl];
        viewController.imageName =[self.workout ImageName];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (IBAction)onClicksubscribe:(id)sender {
}

#pragma   mark In App purchase methods
#pragma   loadStore
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}


//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}


//
// kick off the upgrade transaction
//
- (void)purchaseProUpgrade
{
    [self loadStore];
    [self canMakePurchases];
    
        productIdentifier = [NSString stringWithFormat:@"com.fitness4me.Fitness4Me.%@",
                             [workout WorkoutID]];
    
    // SKProduct *validProduct=productIdentifier;
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:productIdentifier])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:productIdentifier])
    {
        // enable the pro features
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful){
        // update the server with the purchased details
       
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        [userinfo setObject:@"true" forKey:@"hasMadeFullPurchase"];
        transaction =nil;
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
        
        
        [userinfo setObject:@"false" forKey:@"fullVideoDownloadlater"];
    }
    else{
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
   
    NSLog(@"failedTransaction : %@", [transaction.error localizedDescription]);
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
        
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}


-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *validProduct = nil;
    
    int counts = [response.products count];
    
     
    if (counts>0) {
        
        validProduct = [response.products objectAtIndex:0];
        //SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"appUpdate1"];
        //
        // [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        // [[SKPaymentQueue defaultQueue] addPayment:payment]; // <-- KA CHING!
        
        // NSLog (@"payment proccessed I think");
    }
    
}


@end
