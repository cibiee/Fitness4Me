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
#import "ListWorkoutsViewController.h"
#import "WorkoutDB.h"


@class Fitness4MeViewController;
@class InitialAppLaunchViewController;

@interface Fitness4MeAppDelegate : UIResponder <UIApplicationDelegate>
{
    User *user;
    WorkoutDB *workoutDB;
    
}


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) InitialAppLaunchViewController *viewController;
@property (strong, nonatomic) Fitness4MeViewController *fitness4MeViewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end







