//
//  ExcersiceIntermediateViewController.h
//  Fitness4Me
//
//  Created by Ciby K Jose on 06/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"
#import "ExcersiceDB.h"
#import "WorkoutDB.h"
#import "ListWorkoutsViewController.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "SBJSON.h"
#import "SBJsonParser.h"
#import <StoreKit/StoreKit.h>
#import "User.h"
#import "UserDB.h"


#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"
#define kInAppPurchaseProUpgradeProductId @"com.fitness4me.Fitness4Me"

@interface ExcersiceIntermediateViewController : UIViewController<SKProductsRequestDelegate,SKPaymentTransactionObserver,ASIHTTPRequestDelegate>
{
    
    IBOutlet UIImageView *excersiceImageHolder;
    IBOutlet UITextView  *descriptionTextview;
    IBOutlet  UINavigationBar *navigationBars;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITextView *pleaseWait;
    IBOutlet UIView *signUpView;
    IBOutlet UIButton *letsgoButton;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIBarButtonItem *backButton ;
    IBOutlet UITextView *propsLabel;
     IBOutlet UILabel *propLabel;
    IBOutlet UIView *slownetView;

     IBOutlet UIButton *slownetButton;
    

    ExcersiceDB *excersiceDB;  
    WorkoutDB *workoutDB;
    Workout * workout;
    User *user;

    
    SKProduct *proUpgradeProduct;    
    SKProductsRequest *productsRequest;
    NSString *productIdentifier;

    BOOL isConected;
    
    NSMutableArray *excersices;
    NSMutableArray *arr;
    NSMutableArray *excersicesList;
    
    NSString *purchaseAll;       
    NSString *dataPath;
    NSString *urlPath;
        NSString *userlevel;
    NSString *userID;
    
    int count;
    int stop;
    
}

@property (retain,nonatomic)Workout *workout;
@property (retain,nonatomic)NSString *purchaseAll;
@property(retain,nonatomic)NSString *userlevel;
@property(retain,nonatomic)NSString *userID;
@property(retain,nonatomic)NSString *productIdentifier;

-(void)downloadVideos:(NSString *)url:(NSString*)name;
-(void)parseExcersiceDetails;
-(void)startDownload;

-(void)getExcersices;
-(void)getUnlockedExcersices;
-(void)loadStore;
-(void)purchaseProUpgrade;
-(BOOL)canMakePurchases;


-(IBAction)onClickOK:(id)sender;
-(IBAction)NavigateToMoviePlayer:(id)sender;
-(IBAction)onClickBack:(id)sender;



@end
