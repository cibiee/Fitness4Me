//
//  StatisticsDB.h
//  Fitness4Me
//
//  Created by Ciby on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Statistics.h"

@interface StatisticsDB : NSObject
{
    NSString * databasePath;
    
    NSString * databaseName;
    
    FMDatabase * database;
    
    NSMutableArray *arrStatistics;
}

-(void)setUpDatabase;

-(void)createDatabase;

-(NSMutableArray*)getWorkouts;

-(void)insertStatistics:(Statistics *)statistics;

@end
