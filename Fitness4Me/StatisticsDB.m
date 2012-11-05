//
//  StatisticsDB.m
//  Fitness4Me
//
//  Created by Ciby on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatisticsDB.h"

@implementation StatisticsDB

    - (id)init
    {
        self = [super init];
        if (self) {
            // Initialization code here.
        }
        
        return self;
    }
    
    -(void)setUpDatabase
    {
        databaseName =@"Fitness.sqlite";
        
        NSArray *docPath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *docDir =[docPath objectAtIndex:0];
        
        databasePath =[docDir stringByAppendingPathComponent:databaseName];
    }
    
    
    
    
    -(void)createDatabase{
        
        BOOL success;
        
        NSFileManager *filemanager =[NSFileManager defaultManager];
        
        success =[filemanager  fileExistsAtPath:databasePath];
        
        if(success)
        {
            return;
        }
        
        NSString *databaseFromPath=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:databaseName];
        
        [filemanager copyItemAtPath:databaseFromPath toPath:databasePath error:nil];
    }
    

-(NSMutableArray*)getWorkouts{
    
        
    database =[FMDatabase databaseWithPath:databasePath];
    
    arrStatistics=[[NSMutableArray alloc]init];
    
    // [database setLogsErrors:TRUE];
    
    // [database setTraceExecution:TRUE];
    
    if(!database.open)
    {
        NSLog(@"Databse not Open");
    }
    else
        
    {
      //  NSLog(@"Database opened sucessfully");
    }
    
    
    
    FMResultSet *resultSet=[database executeQuery:@"Select WorkoutID,sum(Duration) from Statistics group by WorkoutID"];
    
    
    
    while(resultSet.next)
    {
        
        NSString * workoutID =[resultSet stringForColumnIndex:0];
        
        NSString *duration = [resultSet stringForColumnIndex:1];
        
            
        Statistics *statistics = [[Statistics alloc]initWithData:workoutID:duration];
        
        [arrStatistics addObject:statistics];
        
        [statistics release];
        
    }
    
    [resultSet close];
    
    // [database close];
    
    
    return arrStatistics;
    
}


-(void)insertStatistics:(Statistics *)statistics{
    
    database =[FMDatabase databaseWithPath:databasePath];
    
    //  [database setLogsErrors:TRUE];
    
    //  [database setTraceExecution:TRUE];
    
    if(!database.open)
    {
        NSLog(@"Databse not Open");
    }
    else
        
    {
       // NSLog(@"Database opened sucessfully");
    }
    
    
    [database beginTransaction];

    
    [database executeUpdate:@"INSERT INTO Statistics (WorkoutID,Duration) VALUES (?,?);",
     
     statistics.WorkoutID,statistics.Duration, nil];


    [database commit];
    
    
    // Close the database.
    [database close];
    
    
}


-(void)deleteStatistics{
    
    database =[FMDatabase databaseWithPath:databasePath];
    
    //[database setLogsErrors:TRUE];
    
    // [database setTraceExecution:TRUE];
    
    if(!database.open)
    {
        NSLog(@"Databse not Open");
    }
    else
        
    {
       // NSLog(@"Database opened sucessfully");
    }
    
    
    [database beginTransaction];
    
    [database executeUpdate:@"Delete from Statistics"];
    
    [database commit];
    
    
    // Close the database.
    [database close];
    
    
}





@end
