//
//  MembershipPurchaseViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 11/12/12.
//
//
#import "MembershipTableViewCell.h"
#import "MembershipPurchaseViewController.h"
#import "CustomWorkoutsViewController.h"
#import "Membership.h"
@interface MembershipPurchaseViewController ()
@property(nonatomic,strong)NSMutableArray *productArray;
@end

@implementation MembershipPurchaseViewController
@synthesize workout,memberships;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
         fitness =[FitnessServer sharedState];
        self.productArray= [[NSMutableArray alloc]init];
        userinfo =[NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackground];
    self.planPopUpView.layer.cornerRadius=12;
    self.planPopUpView.layer.borderWidth = 2;
    self.planPopUpView.layer.borderColor = [[UIColor blackColor] CGColor];
   
    [self.planPopUpView setHidden:YES];
    [self.tableView setHidden:YES];
    [self PrepareDataForInappPurchase];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickQuit:(id)sender {
    if ([self.navigateTo isEqualToString:@"List"]) {
       
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


-(void)setBackground{
    self.tableView.backgroundColor =[UIColor clearColor];
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:(CGRectMake(0,0, 320, 480))];
    UIImage  *backgroundImage= [UIImage imageNamed:@"home_bg.png"];
    background.image=backgroundImage;
    self.tableView.backgroundView = background;
    [self.tableView reloadData];
    self.tableView.separatorColor =[UIColor clearColor];
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
    
     BOOL s= [self verifyReceipt:transaction];
     if (s ==YES) {
        
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


- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSMutableArray *purchasedItemIDs = [[NSMutableArray alloc] init];
    
  //  NSLog(@"received restored transactions: %i", queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        [purchasedItemIDs addObject:productID];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
   // NSLog(error.localizedDescription);
}


- (BOOL)verifyReceipt:(SKPaymentTransaction *)transaction {
  
    __block BOOL isValid;
    NSString *jsonObjectString = [self encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length];
    fitness= [FitnessServer sharedState];
    [fitness storeRecipt:jsonObjectString activitIndicator:nil progressView:nil onCompletion:^(NSString *response) {
        isValid =YES;
    } onError:^(NSError *error) {
        
    }];
    
    return isValid;
}

- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length {
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
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
        
        [self sendMembership];
        // update the server with the purchased details
       
       
        transaction =nil;
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
        
          
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


-(void)PrepareDataForInappPurchase{
    
   // [self.view addSubview:fullvideoView];
  //  [activityIndicator setHidden:NO];
   // [activityIndicator startAnimating];
    [NSThread detachNewThreadSelector:@selector(parseFitnessDetails) toTarget:self withObject:nil];
}


-(void)parseFitnessDetails{
    
   [fitness parseMembership:nil progressView:nil onCompletion:^(NSString *response) {
       if ([response length]>0) {
           [self parseCustomWorkoutList:response];
       }
   }  onError:^(NSError *error) {
       
   }];
    
      
    
}

-(void)ListExcersices
{
    
   
    memberships = [[NSMutableArray alloc]init];
     membershipDB =[[MembershipDB alloc]init];
    [membershipDB setUpDatabase];
    [membershipDB createDatabase];
    [membershipDB getMemberships];
    
    if ([membershipDB.memberships count]>0) {
        memberships = membershipDB.memberships;
        [self prepareTableView];
        [self.tableView reloadData];
        [self.tableView setHidden:NO];
        //[activityIndicator stopAnimating];
        //[activityIndicator setHidesWhenStopped:YES];
    }
    
    else {
        
        BOOL isReachable =[Fitness4MeUtils isReachable];
        if (isReachable){
            [NSThread detachNewThreadSelector:@selector(parseFitnessDetails) toTarget:self withObject:nil];
        }
        else {
          
            return;
        }
    }
    
        
    self.tableView.separatorStyle =UITableViewStylePlain;
   
}


-(void)parseCustomWorkoutList:(NSString*)responseString
{
    if ([responseString length]>0) {
        [self ListExcersices];
        [self.tableView setHidden:NO];
    }
    else
    {
        //[activityIndicator stopAnimating];
       // [activityIndicator removeFromSuperview];
        [self.tableView setHidden:YES];
        [self.tableView reloadData];
    }
}


-(void)prepareTableView{
    
    self.groupedMemberships =[[NSMutableArray alloc]init];
    for(int i=0;i<[membershipDB.memberships count];i++){
      //  NSLog(@"%i",[membershipDB.memberships count]);
        NSArray *arrMemberships = [NSArray arrayWithObjects:[membershipDB.memberships objectAtIndex:i], nil];
        NSDictionary *membership = [NSDictionary dictionaryWithObject:arrMemberships forKey:@"memberships"];
        [self.groupedMemberships addObject:membership];
    }
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Return the number of sections.
    return [self.groupedMemberships  count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [self.groupedMemberships objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"memberships"];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"mycell";
    MembershipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil){
        cell = [[MembershipTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"membershipbg.png"]];
    }
    
    NSDictionary *dictionary = [self.groupedMemberships objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"memberships"];
    Membership *membership = [[Membership alloc]init];
    membership = [array objectAtIndex:indexPath.row];
    cell.nameLabel.text = [membership name];
    cell.rateLabel.text=[[membership currency] stringByAppendingString:[membership rate]];
    
    cell.moreInfoButton.titleLabel .textColor=[UIColor whiteColor];
    cell.buyNowButton.titleLabel .textColor=[UIColor whiteColor];
    
    cell.moreInfoButton.titleLabel .font=[UIFont systemFontOfSize:14];
    cell.buyNowButton.titleLabel .font=[UIFont systemFontOfSize:14];
    [cell.moreInfoButton setTag:[indexPath section]];
    [cell.moreInfoButton  addTarget:self action:@selector(onClickMoreInfo:) forControlEvents:UIControlEventTouchUpInside];
    [cell.buyNowButton setTag:[indexPath section]];
    [cell.buyNowButton  addTarget:self action:@selector(onClickBuyNow:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [self setCloseButton:nil];
    [self setTitleLabel:nil];
    [self setDescriptionLabel:nil];
    [self setPlanPopUpView:nil];
    [self setRateLabel:nil];
    [super viewDidUnload];
}
- (IBAction)closePopup:(id)sender {
    [self.planPopUpView setHidden:YES];
}

- (IBAction)onClickMoreInfo:(id)sender {
    
    int s = [sender tag];
    
    NSDictionary *dictionary = [self.groupedMemberships objectAtIndex:s];
    NSArray *array = [dictionary objectForKey:@"memberships"];
    selectedMembership = [[Membership alloc]init];
    selectedMembership = [array objectAtIndex:0];
    [self.titleLabel setText:[selectedMembership name]];
    NSString *ratetext= [[selectedMembership currency] stringByAppendingString:[selectedMembership rate]];
    [self.rateLabel setText:[@"only " stringByAppendingString:ratetext]];
    int membershipID= [[selectedMembership membershipID]intValue];
    NSString *descriptionKey;
    
    switch (membershipID) {
        case 1:
            
            descriptionKey =@"monthlyDescription";
            break;
        case 2:
            
            descriptionKey =@"supersaver1Description";
            break;
        case 3:
            
            descriptionKey =@"supersaver2Description";
            break;
        case 4:
            
            descriptionKey =@"supersaver3Description";
            break;
            
        default:
            break;
    }
    [self.descriptionLabel setText:NSLocalizedStringWithDefaultValue(descriptionKey, nil,[Fitness4MeUtils getBundle], nil, nil)];
    [self.planPopUpView setHidden:NO];
}

- (IBAction)onClickBuyNow:(id)sender {
    int s = [sender tag];
    NSDictionary *dictionary = [self.groupedMemberships objectAtIndex:s];
    NSArray *array = [dictionary objectForKey:@"memberships"];
    selectedMembership = [[Membership alloc]init];
    selectedMembership = [array objectAtIndex:0];
    productIdentifier=[selectedMembership appleID];
   [self purchaseProUpgrade];
}




-(void)sendMembership{
    
    [fitness membershipPlanUser:[selectedMembership membershipID] activityIndicator:nil progressView:nil onCompletion:^(NSString *status) {
        if ([status length]>0) {
            if ([status isEqualToString:@"success"]) {
                [userinfo setObject:@"true" forKey:@"isMember"];
                [userinfo setObject:@"dontSubscribe" forKey:@"yearly"];
                [userinfo setObject:[selectedMembership membershipID] forKey:@"MembershipPlan"];
                [self showAlertwithMsg:@"Congratulations! You  have become a member of fitness4.me."];
            }
        }
    }  onError:^(NSError *error) {
        
    }];

}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self onClickQuit:nil];
    }
    else {
        exit(0);
    }
}


-(void)showAlertwithMsg:(NSString*)message
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"fitness4.me" message:message
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
    
    
    
}
@end
