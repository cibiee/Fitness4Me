//
//  SyncScreenViewController.h
//  Fitness4Me
//
//  Created by Ciby on 06/08/12.
//
//

#import <UIKit/UIKit.h>
#import "FitnessServerCommunication.h"

@interface SyncScreenViewController : UIViewController<FitnessServerCommunicationDelegate>
{
    int UserID;
    
    FitnessServerCommunication *fitnessCommunication;
    
    NSMutableArray *workouts;
    
    WorkoutDB *workoutDB;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
}
@property (assign,nonatomic)int UserID;


@end
