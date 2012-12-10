//
//  WorkoutDB.h
//  Fitness4Me
//
//  Created by Ciby on 23/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Workout.h"

@interface WorkoutDB : NSObject
{

NSMutableArray *Workouts;

NSString * databasePath;

NSString * databaseName;

FMDatabase * database;
    
    int  temp;


}
@property (retain, nonatomic) NSMutableArray *Workouts;

@property (nonatomic,assign) int temp;

-(void)setUpDatabase;

-(void)createDatabase;

-(void)getWorkouts;

-(void)insertWorkout:(Workout *)workout;
-(void)insertWorkouts:(NSMutableArray *)workouts;
-(void)deleteWorkout;
-(void)selectWorkout;
-(void)updateWorkout:(NSString *)workoutID:(NSString *)isLocked;


-(void)getCustomWorkouts;
-(void)insertCustomWorkout:(Workout *)workout;
-(void)insertCustomWorkouts:(NSMutableArray *)workouts;
-(void)deleteCustomWorkout;
-(Workout*)getCustomWorkoutByID:(NSString*)workoutID;
//-(void)selectCustomWorkout;
//-(void)updateCustomWorkout:(NSString *)workoutID:(NSString *)isLocked;





@end
