//
//  WorkoutDB.m
//  Fitness4Me
//
//  Created by Ciby on 23/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkoutDB.h"

@implementation WorkoutDB

@synthesize Workouts,temp;

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


-(void)getWorkouts{
    
    
     [self selectWorkout];
    database =[FMDatabase databaseWithPath:databasePath];
    Workouts=[[NSMutableArray alloc]init];
    
    if(!database.open)
    {
      //  NSLog(@"Databse not Open");
    }
    else
        
    {
       // NSLog(@"Database opened sucessfully");
    }

    FMResultSet *resultSet=[database executeQuery:@"Select * from Workout order by IsLocked ASC"];

    while(resultSet.next)
    {
        NSString * workoutID =[resultSet stringForColumnIndex:0];
        NSString *name = [resultSet stringForColumnIndex:1];
        NSString *description = [resultSet stringForColumnIndex:2];
        NSString *rate =  [resultSet stringForColumnIndex:3];
        NSString *islocked;

         NSString *lockimageUrl;
        
               
            islocked =[resultSet stringForColumnIndex:4];
            
            
            if([islocked isEqualToString :@"false"])
            {
                lockimageUrl  = @"unlocked.png";
                
            }
            else {
                
                lockimageUrl  = @"locked.png";
                
            }

        NSString *descriptionToDo = [resultSet stringForColumnIndex:5];
        NSString *ImageUrl = [resultSet stringForColumnIndex:6];
        NSString *Imagename =  [resultSet stringForColumnIndex:7];
        NSString *descriptionBig = [resultSet stringForColumnIndex:8];
        NSString *thumbImageUrl =  [resultSet stringForColumnIndex:9];
        NSString *props =  [resultSet stringForColumnIndex:10];
        Workout *workout = [[Workout alloc]initWithData:workoutID:name:rate:ImageUrl:Imagename:islocked:description:descriptionToDo:lockimageUrl:descriptionBig:thumbImageUrl:props];
        [Workouts addObject:workout];
        
        [workout release];
        
    }
    
    [resultSet close];
    
   // [database close];
    
}

-(void)insertWorkout:(Workout *)workout{
    
    database =[FMDatabase databaseWithPath:databasePath];
   // [database setLogsErrors:TRUE];
    
   //[database setTraceExecution:TRUE];
    
    if(!database.open)
    {
        //NSLog(@"Databse not Open");
    }
    else
        
    {
      //  NSLog(@"Database opened sucessfully");
    }
    
    [database beginTransaction];
     [database executeUpdate:@"INSERT INTO Workout (WorkoutID,Name,Description,Rate,IsLocked,DescriptionToDo,ImageUrl,ImageName,DescriptionBig,ImageThumbUrl,Props) VALUES (?,?,?,?,?,?,?,?,?,?,?);",

       workout.WorkoutID,workout.Name,workout.Description,workout.Rate,workout.IsLocked,workout.DescriptionToDo,workout.ImageUrl,workout.ImageName,workout.DescriptionBig,workout.ThumbImageUrl, workout.Props,nil];
    //   
    [database commit];
    // Close the database.
    [database close];
    
}




-(void)insertWorkouts:(NSMutableArray *)workouts
{
    int workoutCount =workouts.count;
    [self deleteWorkout];
    
    Workout *workout;
    
    for (int count=0; count<workoutCount; count++) {
        
        workout =[Workout new];
        
        // NSString *excersiceIdnetity =[[excersices objectAtIndex: count] valueForKey:@"ExcersiceID"];    
        workout.WorkoutID =  [[workouts objectAtIndex: count] valueForKey:@"WorkoutID"];
        workout.Name = [[workouts objectAtIndex: count] valueForKey: @"Name"];
        workout.Rate =  [[workouts objectAtIndex: count] valueForKey: @"Rate"];
        workout.Description =   [[workouts objectAtIndex: count] valueForKey: @"Description"];
        workout.IsLocked= [[workouts objectAtIndex: count] valueForKey: @"IsLocked"];
        workout.DescriptionToDo = [[workouts objectAtIndex: count] valueForKey: @"DescriptionToDo"];
        workout.ImageUrl = [[workouts objectAtIndex: count] valueForKey: @"ImageUrl"];
        workout.ImageName = [[workouts objectAtIndex: count] valueForKey: @"ImageName"];
        workout.DescriptionBig = [[workouts objectAtIndex: count] valueForKey: @"DescriptionBig"];
        workout.ThumbImageUrl = [[workouts objectAtIndex: count] valueForKey: @"ThumbImageUrl"];
        workout.Props = [[workouts objectAtIndex: count] valueForKey: @"Props"];
        [self insertWorkout:workout];
        [workout release];
        
    }
    
}


-(void)updateWorkout:(NSString *)workoutID:(NSString *)isLocked{
    database =[FMDatabase databaseWithPath:databasePath];
        
  //  [database setLogsErrors:TRUE];
  //  [database setTraceExecution:TRUE];
    if(!database.open)
    {
       // NSLog(@"Databse not Open");
    }
    else
        
    {
       // NSLog(@"Database opened sucessfully");
    }
    

    [database beginTransaction];
    NSString *Query;
    if ([workoutID isEqualToString:@"All"]) {
        Query =[NSString stringWithFormat:@"Update  Workout  set IsLocked = '%@'",isLocked];
    }
    else
    {
          Query =[NSString stringWithFormat:@"Update  Workout  set IsLocked = '%@' where WorkoutID = '%@'",isLocked,workoutID];
    }

    [database executeUpdate:Query];
    [database commit];
    // Close the database.
    [database close];

}



-(void)deleteWorkout{
    
    database =[FMDatabase databaseWithPath:databasePath];
    
    //[database setLogsErrors:TRUE];
    
   // [database setTraceExecution:TRUE];
    
    if(!database.open)
    {
        //NSLog(@"Databse not Open");
    }
    else
        
    {
       // NSLog(@"Database opened sucessfully");
    }

    [database beginTransaction];
    [database executeUpdate:@"Delete from Workout"];
    [database commit];
    // Close the database.
    [database close];
    
    
}

-(void)selectWorkout{
    
    database =[FMDatabase databaseWithPath:databasePath];

    if(!database.open)
    {
      //  NSLog(@"Databse not Open");
    }
    else
        
    {
      //  NSLog(@"Database opened sucessfully");
    }
    FMResultSet *resultSet=[database executeQuery:@"select count(WorkoutID) from Workout where islocked ='false'"];
    
    while(resultSet.next)
    {
        temp =[resultSet intForColumnIndex:0];
    }
    [resultSet close];
    
  // [database close];    
}



@end
