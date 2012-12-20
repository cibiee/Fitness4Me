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
        if(success){
            return;
        }
        NSString *databaseFromPath=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:databaseName];
        [filemanager copyItemAtPath:databaseFromPath toPath:databasePath error:nil];
    }
    

-(NSMutableArray*)getWorkouts{
    
    database =[FMDatabase databaseWithPath:databasePath];
    arrStatistics=[[NSMutableArray alloc]init];
    if(!database.open){
        NSLog(@"Databse not Open");
    }else{
      //  NSLog(@"Database opened sucessfully");
    }

    FMResultSet *resultSet=[database executeQuery:@"Select WorkoutID,sum(Duration) from Statistics group by WorkoutID"];
    
    while(resultSet.next){
        Statistics *statistics =[[Statistics alloc]init];
        statistics.WorkoutID =[resultSet stringForColumnIndex:0];
        double duration=[[resultSet stringForColumnIndex:1]doubleValue];
        statistics .Duration =(float)duration;
        [arrStatistics addObject:statistics];
        [statistics release];
    }
    
    [resultSet close];
    return arrStatistics;
}


-(void)insertStatistics:(Statistics *)statistics{
    
    database =[FMDatabase databaseWithPath:databasePath];
    if(!database.open){
        NSLog(@"Databse not Open");
    }
    [database beginTransaction];
    [database executeUpdate:@"INSERT INTO Statistics (WorkoutID,Duration) VALUES (?,?);",
     statistics.WorkoutID,[NSString stringWithFormat:@"%f",statistics.Duration], nil];
    [database commit];
    
    [database close];
}


-(void)deleteStatistics{
    
    database =[FMDatabase databaseWithPath:databasePath];
    if(!database.open){
        NSLog(@"Databse not Open");
    }else{
       // NSLog(@"Database opened sucessfully");
    }
    [database beginTransaction];
    [database executeUpdate:@"Delete from Statistics"];
    [database commit];
    // Close the database.
    [database close];
    
    
}


-(NSMutableArray*)getCustomWorkouts{
    
    database =[FMDatabase databaseWithPath:databasePath];
    arrStatistics=[[NSMutableArray alloc]init];
    if(!database.open){
        NSLog(@"Databse not Open");
    }else{
        //  NSLog(@"Database opened sucessfully");
    }
    
    FMResultSet *resultSet=[database executeQuery:@"Select WorkoutID,sum(Duration) from CustomStatistics group by WorkoutID"];
    
    while(resultSet.next){
        Statistics *statistics =[[Statistics alloc]init];
        statistics.WorkoutID =[resultSet stringForColumnIndex:0];
        double duration=[[resultSet stringForColumnIndex:1]doubleValue];
        statistics .Duration =(float)duration;
        [arrStatistics addObject:statistics];
        [statistics release];
    }
    
    [resultSet close];
    return arrStatistics;
}


-(void)insertCustomStatistics:(Statistics *)statistics{
    
    database =[FMDatabase databaseWithPath:databasePath];
    if(!database.open){
        NSLog(@"Databse not Open");
    }
    [database beginTransaction];
    [database executeUpdate:@"INSERT INTO CustomStatistics (WorkoutID,Duration) VALUES (?,?);",
     statistics.WorkoutID,[NSString stringWithFormat:@"%f",statistics.Duration], nil];
    [database commit];
    
    [database close];
}


-(void)deleteCustomStatistics{
    
    database =[FMDatabase databaseWithPath:databasePath];
    if(!database.open){
        NSLog(@"Databse not Open");
    }else{
        // NSLog(@"Database opened sucessfully");
    }
    [database beginTransaction];
    [database executeUpdate:@"Delete from CustomStatistics"];
    [database commit];
    // Close the database.
    [database close];
    
    
}





@end
