//
//  Fitness4MeAppDelegate.h
//  Fitness4Me
//
//  Created by Ciby K Jose on 05/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "User.h"
#import "UserDB.h"
#import "WorkoutDB.h"
#import "Fitness4MeViewController.h"
#import "InitialAppLaunchViewController.h"
#import "FitnessServerCommunication.h"
#import "Fitness4MeUtils.h"
#import "StatisticsDB.h"
#import "Favourite.h"
#import "CustomFavourites.h"


@class Fitness4MeViewController;
@class InitialAppLaunchViewController;

@interface Fitness4MeAppDelegate : UIResponder <UIApplicationDelegate>
{
    User *user;
    WorkoutDB *workoutDB;
      NSString* remainisgDays;
}


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) InitialAppLaunchViewController *viewController;
@property (strong, nonatomic) Fitness4MeViewController *fitness4MeViewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end







