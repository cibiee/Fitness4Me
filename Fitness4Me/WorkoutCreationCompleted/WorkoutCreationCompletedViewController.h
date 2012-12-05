//
//  WorkoutCreationCompletedViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 05/12/12.
//
//

#import <UIKit/UIKit.h>
#import "ExcersiceDB.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "SBJSON.h"
#import "SBJsonParser.h"
#import "FitnessServerCommunication.h"

@interface WorkoutCreationCompletedViewController : UIViewController
{
    
    
    Workout *workout;
    
    ASIHTTPRequest   *downloadrequest ;
    ASINetworkQueue  *myQueue;
    ExcersiceDB *excersiceDB;
   
    
    BOOL isConected;
    int count;
    int stop;
    NSString  *storeURL;
    NSString *purchaseAll;
    NSString *dataPath;
    NSString *urlPath;
    NSString *userlevel;
    NSString *userID;
    

    
    NSMutableArray *excersices;
    NSMutableArray *arr;
    NSMutableArray *excersicesList;
    
    
       
        
    int stopz;

}

@property (strong, nonatomic)Workout *workout;

- (IBAction)onClickLetsGo:(id)sender;


@end
