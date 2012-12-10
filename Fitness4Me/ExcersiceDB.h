//
//  BlogDB.h
//  Bridge
//
//  Created by Ciby K Jose on 19/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Excersice.h"

@interface ExcersiceDB : NSObject
{
    NSMutableArray *Excersices;
    
    NSString * databasePath;
    
    NSString * databaseName;
    
    FMDatabase * database;
    
    
}
@property (retain,nonatomic) NSMutableArray *Excersices;

-(void)setUpDatabase;

-(void)createDatabase;

-(void)getExcersices:(int)workoutID;

-(void)insertExcersice:(Excersice *)excersice;

-(void)insertExcersices:(NSMutableArray *)excersices;

-(void)insertWorkoutExcersices:(NSMutableArray *)excersices;

-(void)deleteExcersice:(int)workoutID;



-(void)getCustomExcersices:(int)workoutID;

-(void)insertCustomExcersice:(Excersice *)excersice;

-(void)insertCustomExcersices:(NSMutableArray *)excersices;

-(void)insertCustomWorkoutExcersices:(NSMutableArray *)excersices;

-(void)deleteCustomExcersice:(int)workoutID;


@end
