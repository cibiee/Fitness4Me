//
//  BlogDB.m
//  Bridge
//
//  Created by Ciby K Jose on 19/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExcersiceDB.h"

@implementation ExcersiceDB

@synthesize Excersices;

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

#pragma mark 10 Minutes Workouts

-(void)getExcersices:(int)workoutID{
    
    database =[FMDatabase databaseWithPath:databasePath];
    Excersices=[[NSMutableArray alloc]init];
    NSString *query=[NSString stringWithFormat:@"Select * from Excersice where WorkoutID =%i",workoutID];
    FMResultSet *resultSet=[database executeQuery:query];
    while(resultSet.next)
    {
        int workoutID = [resultSet intForColumnIndex:0];
        NSString *posterVideoUrl =  [resultSet stringForColumnIndex:1];
        NSString *posterName =[resultSet stringForColumnIndex:2];
        NSString * posterRepeatCount =[resultSet stringForColumnIndex:3];
        NSString *videoUrl = [resultSet stringForColumnIndex:4];
        NSString *name =  [resultSet stringForColumnIndex:5];
        NSString *repeatCount  =[resultSet stringForColumnIndex:6];
        NSString *stopvideo= [resultSet stringForColumnIndex:7];
        NSString *stopname= [resultSet stringForColumnIndex:8];
        NSString *stoprep =  [resultSet stringForColumnIndex:9];
        NSString *othersideposter = [resultSet stringForColumnIndex:10];
        NSString *othersidepostername= [resultSet stringForColumnIndex:11];
        NSString *othersideposterrep =  [resultSet stringForColumnIndex:12];
        NSString *othersidevideo = [resultSet stringForColumnIndex:13];
        NSString *othersidename= [resultSet stringForColumnIndex:14];
        NSString *othersiderep =  [resultSet stringForColumnIndex:15];
        NSString *recoveryVideoName= [resultSet stringForColumnIndex:17];
        NSString *recoveryVideoUrl= [resultSet stringForColumnIndex:16]; 
        NSString *nextvideo = [resultSet stringForColumnIndex:18];
        NSString *nextname=[resultSet stringForColumnIndex:19];
        NSString *nextrep  = [resultSet stringForColumnIndex:20];
        NSString *completedvideo=[resultSet stringForColumnIndex:21];
        NSString *completedname =[resultSet stringForColumnIndex:22];
        NSString *completedrep=[resultSet stringForColumnIndex:23];
       Excersice *excersice = [[Excersice alloc]initWithData:workoutID:posterVideoUrl:posterName:posterRepeatCount:videoUrl:name:repeatCount:stopvideo:stopname:stoprep:othersideposter:othersidepostername:othersideposterrep:othersidevideo:othersidename:othersiderep:recoveryVideoUrl:recoveryVideoName:nextvideo:nextname:nextrep:completedvideo:completedname:completedrep];
  
        [Excersices addObject:excersice];
        
        [excersice release];
    }
    [resultSet close];

}

-(void)insertExcersice:(Excersice *)excersice{
    
    database =[FMDatabase databaseWithPath:databasePath];
    [database beginTransaction];
    NSString *WorkoutID =[NSString stringWithFormat:@"%i", excersice.WorkoutID];
    [database executeUpdate:@"INSERT INTO Excersice (WorkoutID,PosterUrl,PosterName,PosterRepeatCount,VideoUrl,Name,RepeatCount,StopVideo,StopName,StopRep,OtherSidePoster,OthersidePosterName,OthersidePosterRep,OtherSideVideo,OthersideName,OthersideRep,RecoveryVideoName,RecoveryVideoUrl,NextVideo,NextName,NextRep,CompletedVideo,CompletedName,CompletedRep) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);",WorkoutID,excersice.PosterUrl,excersice.PosterName,excersice.PosterRepeatCount,excersice.VideoUrl,excersice.Name,excersice.RepeatCount,excersice.StopVideo,excersice.StopName,excersice.StopRep,excersice.OtherSidePoster,excersice.OthersidePosterName,excersice.OthersidePosterRep,excersice.OthersideVideo,excersice.OthersideName,excersice.OthersideRep,excersice.RecoveryVideoName,excersice.RecoveryVideoUrl,excersice.NextVideo,excersice.NextName,excersice.NextRep,excersice.CompletedVideo,excersice.CompletedName,excersice.CompletedRep, nil];
    [database commit];
 
}


-(void)insertWorkoutExcersices:(NSMutableArray * ) excersiced
{
    Excersice *excersice ;
    for (int count=0; count<excersiced.count; count++) {
        
        excersice =[[Excersice alloc]init];
        NSString *workout =[[excersiced objectAtIndex: count] valueForKey:@"workout_id"];
        excersice.WorkoutID =  [workout intValue];
        excersice.PosterUrl= [[excersiced objectAtIndex: count] valueForKey: @"poster_video"];
        excersice.PosterName= [[excersiced objectAtIndex: count] valueForKey: @"poster_name"];
        excersice .PosterRepeatCount=[[excersiced objectAtIndex: count] valueForKey: @"poster_rep"];
        excersice.VideoUrl = [[excersiced objectAtIndex: count] valueForKey: @"main_video"];
        excersice.Name =  [[excersiced objectAtIndex: count] valueForKey: @"video_name"];
        excersice.RepeatCount =[[excersiced objectAtIndex: count] valueForKey: @"main_rep"];
        excersice.StopVideo= [[excersiced objectAtIndex: count] valueForKey: @"stop_video"];
        excersice.StopName= [[excersiced objectAtIndex: count] valueForKey: @"stop_name"];
        excersice.StopRep= [[excersiced objectAtIndex: count] valueForKey: @"stop_rep"];
        excersice.OtherSidePoster= [[excersiced objectAtIndex: count] valueForKey: @"otherside_poster"];
        excersice.OthersidePosterName= [[excersiced objectAtIndex: count] valueForKey: @"otherside_postername"];
        excersice.OthersidePosterRep= [[excersiced objectAtIndex: count] valueForKey: @"otherside_posterrep"];
        excersice.OthersideVideo= [[excersiced objectAtIndex: count] valueForKey: @"otherside_video"];
        excersice.OthersideName= [[excersiced objectAtIndex: count] valueForKey: @"otherside_name"];
        excersice.OthersideRep= [[excersiced objectAtIndex: count] valueForKey: @"otherside_rep"];
        excersice.RecoveryVideoUrl= [[excersiced objectAtIndex: count] valueForKey: @"recovery_video"];
        excersice.RecoveryVideoName= [[excersiced objectAtIndex: count] valueForKey: 
                                      @"recovery_video_name"];
        excersice.NextVideo= [[excersiced objectAtIndex: count] valueForKey: @"next_video"];
        excersice.NextName= [[excersiced objectAtIndex: count] valueForKey: @"next_name"];
        excersice.NextRep= [[excersiced objectAtIndex: count] valueForKey: @"next_rep"];
        excersice.CompletedVideo= [[excersiced objectAtIndex: count] valueForKey: @"completed_video"];
        excersice.CompletedName= [[excersiced objectAtIndex: count] valueForKey: @"completed_name"];
        excersice.CompletedRep= [[excersiced objectAtIndex: count] valueForKey: @"completed_rep"];
        [self insertExcersice:excersice];
        [excersice release];
        
    }
    
}


-(void)insertExcersices:(NSMutableArray * ) excersiced
{
    Excersice *excersice ;
    for (int count=0; count<excersiced.count; count++) {
        
        excersice =[[Excersice alloc]init];
        NSString *workout =[[excersiced objectAtIndex: count] valueForKey:@"WorkoutID"];
        excersice.WorkoutID =  [workout intValue];
        excersice.PosterUrl= [[excersiced objectAtIndex: count] valueForKey: @"PosterUrl"];
        excersice.PosterName= [[excersiced objectAtIndex: count] valueForKey: @"PosterName"];
        excersice .PosterRepeatCount=[[excersiced objectAtIndex: count] valueForKey: @"PosterRepeatCount"];
        excersice.VideoUrl = [[excersiced objectAtIndex: count] valueForKey: @"VideoUrl"];
        excersice.Name =  [[excersiced objectAtIndex: count] valueForKey: @"Name"];
        excersice.RepeatCount =[[excersiced objectAtIndex: count] valueForKey: @"RepeatCount"];
        excersice.StopVideo= [[excersiced objectAtIndex: count] valueForKey: @"StopVideo"];
        excersice.StopName= [[excersiced objectAtIndex: count] valueForKey: @"StopName"];
        excersice.StopRep= [[excersiced objectAtIndex: count] valueForKey: @"StopRep"];
        excersice.OtherSidePoster= [[excersiced objectAtIndex: count] valueForKey: @"OtherSidePoster"];
        excersice.OthersidePosterName= [[excersiced objectAtIndex: count] valueForKey: @"OthersidePosterName"];
        excersice.OthersidePosterRep= [[excersiced objectAtIndex: count] valueForKey: @"OthersidePosterRep"];
        excersice.OthersideVideo= [[excersiced objectAtIndex: count] valueForKey: @"OthersideVideo"];
        excersice.OthersideName= [[excersiced objectAtIndex: count] valueForKey: @"OthersideName"];
        excersice.OthersideRep= [[excersiced objectAtIndex: count] valueForKey: @"OthersideRep"];
        excersice.RecoveryVideoUrl= [[excersiced objectAtIndex: count] valueForKey: @"RecoveryVideoUrl"];
        excersice.RecoveryVideoName= [[excersiced objectAtIndex: count] valueForKey:
                                      @"RecoveryVideoName"];
        excersice.NextVideo= [[excersiced objectAtIndex: count] valueForKey: @"NextVideo"];
        excersice.NextName= [[excersiced objectAtIndex: count] valueForKey: @"NextName"];
        excersice.NextRep= [[excersiced objectAtIndex: count] valueForKey: @"NextRep"];
        excersice.CompletedVideo= [[excersiced objectAtIndex: count] valueForKey: @"CompletedVideo"];
        excersice.CompletedName= [[excersiced objectAtIndex: count] valueForKey: @"CompletedName"];
        excersice.CompletedRep= [[excersiced objectAtIndex: count] valueForKey: @"CompletedRep"];
        [self insertExcersice:excersice];
        [excersice release];
        
    }
    
}



-(void)deleteExcersice:(int)workoutID{
    
    database =[FMDatabase databaseWithPath:databasePath];
    [database beginTransaction];
    NSString *query=[NSString stringWithFormat:@"Delete from Excersice where WorkoutID =%i",workoutID];
    [database executeUpdate:query];
    [database commit];
}



#pragma mark custom Made Workouts
-(void)getCustomExcersices:(int)workoutID{
    
    database =[FMDatabase databaseWithPath:databasePath];
    Excersices=[[NSMutableArray alloc]init];
    NSString *query=[NSString stringWithFormat:@"Select * from CustomExcersice where WorkoutID =%i",workoutID];
    FMResultSet *resultSet=[database executeQuery:query];
    while(resultSet.next)
    {
        int workoutID = [resultSet intForColumnIndex:0];
        NSString *posterVideoUrl =  [resultSet stringForColumnIndex:1];
        NSString *posterName =[resultSet stringForColumnIndex:2];
        NSString * posterRepeatCount =[resultSet stringForColumnIndex:3];
        NSString *videoUrl = [resultSet stringForColumnIndex:4];
        NSString *name =  [resultSet stringForColumnIndex:5];
        NSString *repeatCount  =[resultSet stringForColumnIndex:6];
        NSString *stopvideo= [resultSet stringForColumnIndex:7];
        NSString *stopname= [resultSet stringForColumnIndex:8];
        NSString *stoprep =  [resultSet stringForColumnIndex:9];
        NSString *othersideposter = [resultSet stringForColumnIndex:10];
        NSString *othersidepostername= [resultSet stringForColumnIndex:11];
        NSString *othersideposterrep =  [resultSet stringForColumnIndex:12];
        NSString *othersidevideo = [resultSet stringForColumnIndex:13];
        NSString *othersidename= [resultSet stringForColumnIndex:14];
        NSString *othersiderep =  [resultSet stringForColumnIndex:15];
        NSString *recoveryVideoName= [resultSet stringForColumnIndex:17];
        NSString *recoveryVideoUrl= [resultSet stringForColumnIndex:16];
        NSString *nextvideo = [resultSet stringForColumnIndex:18];
        NSString *nextname=[resultSet stringForColumnIndex:19];
        NSString *nextrep  = [resultSet stringForColumnIndex:20];
        NSString *completedvideo=[resultSet stringForColumnIndex:21];
        NSString *completedname =[resultSet stringForColumnIndex:22];
        NSString *completedrep=[resultSet stringForColumnIndex:23];
        Excersice *excersice = [[Excersice alloc]initWithData:workoutID:posterVideoUrl:posterName:posterRepeatCount:videoUrl:name:repeatCount:stopvideo:stopname:stoprep:othersideposter:othersidepostername:othersideposterrep:othersidevideo:othersidename:othersiderep:recoveryVideoUrl:recoveryVideoName:nextvideo:nextname:nextrep:completedvideo:completedname:completedrep];
        [Excersices addObject:excersice];
        [excersice release];
    }
    [resultSet close];
}

-(void)insertCustomExcersice:(Excersice *)excersice{
    
    database =[FMDatabase databaseWithPath:databasePath];
    [database beginTransaction];
    NSString *WorkoutID =[NSString stringWithFormat:@"%i", excersice.WorkoutID];
    [database executeUpdate:@"INSERT INTO CustomExcersice (WorkoutID,PosterUrl,PosterName,PosterRepeatCount,VideoUrl,Name,RepeatCount,StopVideo,StopName,StopRep,OtherSidePoster,OthersidePosterName,OthersidePosterRep,OtherSideVideo,OthersideName,OthersideRep,RecoveryVideoName,RecoveryVideoUrl,NextVideo,NextName,NextRep,CompletedVideo,CompletedName,CompletedRep) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);",WorkoutID,excersice.PosterUrl,excersice.PosterName,excersice.PosterRepeatCount,excersice.VideoUrl,excersice.Name,excersice.RepeatCount,excersice.StopVideo,excersice.StopName,excersice.StopRep,excersice.OtherSidePoster,excersice.OthersidePosterName,excersice.OthersidePosterRep,excersice.OthersideVideo,excersice.OthersideName,excersice.OthersideRep,excersice.RecoveryVideoName,excersice.RecoveryVideoUrl,excersice.NextVideo,excersice.NextName,excersice.NextRep,excersice.CompletedVideo,excersice.CompletedName,excersice.CompletedRep, nil];
    [database commit];
}



-(void)insertCustomWorkoutExcersices:(NSMutableArray * ) excersiced
{
    Excersice *excersice ;
    for (int count=0; count<excersiced.count; count++) {
        
        excersice =[[Excersice alloc]init];
        NSString *workout =[[excersiced objectAtIndex: count] valueForKey:@"workout_id"];
        excersice.WorkoutID =  [workout intValue];
        excersice.PosterUrl= [[excersiced objectAtIndex: count] valueForKey: @"poster_video"];
        excersice.PosterName= [[excersiced objectAtIndex: count] valueForKey: @"poster_name"];
        excersice .PosterRepeatCount=[[excersiced objectAtIndex: count] valueForKey: @"poster_rep"];
        excersice.VideoUrl = [[excersiced objectAtIndex: count] valueForKey: @"main_video"];
        excersice.Name =  [[excersiced objectAtIndex: count] valueForKey: @"video_name"];
        excersice.RepeatCount =[[excersiced objectAtIndex: count] valueForKey: @"main_rep"];
        excersice.StopVideo= [[excersiced objectAtIndex: count] valueForKey: @"stop_video"];
        excersice.StopName= [[excersiced objectAtIndex: count] valueForKey: @"stop_name"];
        excersice.StopRep= [[excersiced objectAtIndex: count] valueForKey: @"stop_rep"];
        excersice.OtherSidePoster= [[excersiced objectAtIndex: count] valueForKey: @"otherside_poster"];
        excersice.OthersidePosterName= [[excersiced objectAtIndex: count] valueForKey: @"otherside_postername"];
        excersice.OthersidePosterRep= [[excersiced objectAtIndex: count] valueForKey: @"otherside_posterrep"];
        excersice.OthersideVideo= [[excersiced objectAtIndex: count] valueForKey: @"otherside_video"];
        excersice.OthersideName= [[excersiced objectAtIndex: count] valueForKey: @"otherside_name"];
        excersice.OthersideRep= [[excersiced objectAtIndex: count] valueForKey: @"otherside_rep"];
        excersice.RecoveryVideoUrl= [[excersiced objectAtIndex: count] valueForKey: @"recovery_video"];
        excersice.RecoveryVideoName= [[excersiced objectAtIndex: count] valueForKey:
                                      @"recovery_video_name"];
        excersice.NextVideo= [[excersiced objectAtIndex: count] valueForKey: @"next_video"];
        excersice.NextName= [[excersiced objectAtIndex: count] valueForKey: @"next_name"];
        excersice.NextRep= [[excersiced objectAtIndex: count] valueForKey: @"next_rep"];
        excersice.CompletedVideo= [[excersiced objectAtIndex: count] valueForKey: @"completed_video"];
        excersice.CompletedName= [[excersiced objectAtIndex: count] valueForKey: @"completed_name"];
        excersice.CompletedRep= [[excersiced objectAtIndex: count] valueForKey: @"completed_rep"];
        
        [self insertCustomExcersice:excersice];
        
        [excersice release];
        
    }
    
}


-(void)insertCustomExcersices:(NSMutableArray * ) excersiced
{

    Excersice *excersice ;
    for (int count=0; count<excersiced.count; count++) {
        
        excersice =[[Excersice alloc]init];
        NSString *workout =[[excersiced objectAtIndex: count] valueForKey:@"WorkoutID"];
        excersice.WorkoutID =  [workout intValue];
        excersice.PosterUrl= [[excersiced objectAtIndex: count] valueForKey: @"PosterUrl"];
        excersice.PosterName= [[excersiced objectAtIndex: count] valueForKey: @"PosterName"];
        excersice .PosterRepeatCount=[[excersiced objectAtIndex: count] valueForKey: @"PosterRepeatCount"];
        excersice.VideoUrl = [[excersiced objectAtIndex: count] valueForKey: @"VideoUrl"];
        excersice.Name =  [[excersiced objectAtIndex: count] valueForKey: @"Name"];
        excersice.RepeatCount =[[excersiced objectAtIndex: count] valueForKey: @"RepeatCount"];
        excersice.StopVideo= [[excersiced objectAtIndex: count] valueForKey: @"StopVideo"];
        excersice.StopName= [[excersiced objectAtIndex: count] valueForKey: @"StopName"];
        excersice.StopRep= [[excersiced objectAtIndex: count] valueForKey: @"StopRep"];
        excersice.OtherSidePoster= [[excersiced objectAtIndex: count] valueForKey: @"OtherSidePoster"];
        excersice.OthersidePosterName= [[excersiced objectAtIndex: count] valueForKey: @"OthersidePosterName"];
        excersice.OthersidePosterRep= [[excersiced objectAtIndex: count] valueForKey: @"OthersidePosterRep"];
        excersice.OthersideVideo= [[excersiced objectAtIndex: count] valueForKey: @"OthersideVideo"];
        excersice.OthersideName= [[excersiced objectAtIndex: count] valueForKey: @"OthersideName"];
        excersice.OthersideRep= [[excersiced objectAtIndex: count] valueForKey: @"OthersideRep"];
        excersice.RecoveryVideoUrl= [[excersiced objectAtIndex: count] valueForKey: @"RecoveryVideoUrl"];
        excersice.RecoveryVideoName= [[excersiced objectAtIndex: count] valueForKey:
                                      @"RecoveryVideoName"];
        excersice.NextVideo= [[excersiced objectAtIndex: count] valueForKey: @"NextVideo"];
        excersice.NextName= [[excersiced objectAtIndex: count] valueForKey: @"NextName"];
        excersice.NextRep= [[excersiced objectAtIndex: count] valueForKey: @"NextRep"];
        excersice.CompletedVideo= [[excersiced objectAtIndex: count] valueForKey: @"CompletedVideo"];
        excersice.CompletedName= [[excersiced objectAtIndex: count] valueForKey: @"CompletedName"];
        excersice.CompletedRep= [[excersiced objectAtIndex: count] valueForKey: @"CompletedRep"];
        [self insertCustomExcersice:excersice];
        [excersice release];
        
    }
    
}


-(void)deleteCustomExcersice:(int)workoutID{
    
    database =[FMDatabase databaseWithPath:databasePath];
    [database beginTransaction];
    NSString *query=[NSString stringWithFormat:@"Delete from CustomExcersice where WorkoutID =%i",workoutID];
    [database executeUpdate:query];
    [database commit];
}



#pragma mark Self Made Workouts

-(void)getSelfMadeExcersices:(int)workoutID{
    
    database =[FMDatabase databaseWithPath:databasePath];
    Excersices=[[NSMutableArray alloc]init];
    NSString *query=[NSString stringWithFormat:@"Select * from SelfMadeWorkout where WorkoutID =%i",workoutID];
    FMResultSet *resultSet=[database executeQuery:query];
    while(resultSet.next)
    {
        int workoutID = [resultSet intForColumnIndex:0];
        NSString *posterVideoUrl =  [resultSet stringForColumnIndex:1];
        NSString *posterName =[resultSet stringForColumnIndex:2];
        NSString * posterRepeatCount =[resultSet stringForColumnIndex:3];
        NSString *videoUrl = [resultSet stringForColumnIndex:4];
        NSString *name =  [resultSet stringForColumnIndex:5];
        NSString *repeatCount  =[resultSet stringForColumnIndex:6];
        NSString *stopvideo= [resultSet stringForColumnIndex:7];
        NSString *stopname= [resultSet stringForColumnIndex:8];
        NSString *stoprep =  [resultSet stringForColumnIndex:9];
        NSString *othersideposter = [resultSet stringForColumnIndex:10];
        NSString *othersidepostername= [resultSet stringForColumnIndex:11];
        NSString *othersideposterrep =  [resultSet stringForColumnIndex:12];
        NSString *othersidevideo = [resultSet stringForColumnIndex:13];
        NSString *othersidename= [resultSet stringForColumnIndex:14];
        NSString *othersiderep =  [resultSet stringForColumnIndex:15];
        NSString *recoveryVideoName= [resultSet stringForColumnIndex:17];
        NSString *recoveryVideoUrl= [resultSet stringForColumnIndex:16];
        NSString *nextvideo = [resultSet stringForColumnIndex:18];
        NSString *nextname=[resultSet stringForColumnIndex:19];
        NSString *nextrep  = [resultSet stringForColumnIndex:20];
        NSString *completedvideo=[resultSet stringForColumnIndex:21];
        NSString *completedname =[resultSet stringForColumnIndex:22];
        NSString *completedrep=[resultSet stringForColumnIndex:23];
        Excersice *excersice = [[Excersice alloc]initWithData:workoutID:posterVideoUrl:posterName:posterRepeatCount:videoUrl:name:repeatCount:stopvideo:stopname:stoprep:othersideposter:othersidepostername:othersideposterrep:othersidevideo:othersidename:othersiderep:recoveryVideoUrl:recoveryVideoName:nextvideo:nextname:nextrep:completedvideo:completedname:completedrep];
        [Excersices addObject:excersice];
        [excersice release];
    }
    [resultSet close];
}

-(void)insertSelfMadeExcersice:(Excersice *)excersice{
    
    database =[FMDatabase databaseWithPath:databasePath];
    [database setLogsErrors:TRUE];
    [database setTraceExecution:TRUE];
    [database beginTransaction];
    NSString *WorkoutID =[NSString stringWithFormat:@"%i", excersice.WorkoutID];
    [database executeUpdate:@"INSERT INTO SelfMadeWorkout (WorkoutID,PosterUrl,PosterName,PosterRepeatCount,VideoUrl,Name,RepeatCount,StopVideo,StopName,StopRep,OtherSidePoster,OthersidePosterName,OthersidePosterRep,OtherSideVideo,OthersideName,OthersideRep,RecoveryVideoName,RecoveryVideoUrl,NextVideo,NextName,NextRep,CompletedVideo,CompletedName,CompletedRep) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);",WorkoutID,excersice.PosterUrl,excersice.PosterName,excersice.PosterRepeatCount,excersice.VideoUrl,excersice.Name,excersice.RepeatCount,excersice.StopVideo,excersice.StopName,excersice.StopRep,excersice.OtherSidePoster,excersice.OthersidePosterName,excersice.OthersidePosterRep,excersice.OthersideVideo,excersice.OthersideName,excersice.OthersideRep,excersice.RecoveryVideoName,excersice.RecoveryVideoUrl,excersice.NextVideo,excersice.NextName,excersice.NextRep,excersice.CompletedVideo,excersice.CompletedName,excersice.CompletedRep, nil];
    [database commit];
}




-(void)insertSelfMadeExcersices:(NSMutableArray * ) excersiced
{
    
    Excersice *excersice ;
    for (int count=0; count<excersiced.count; count++) {
        excersice =[[Excersice alloc]init];
        NSString *workout =[[excersiced objectAtIndex: count] valueForKey:@"WorkoutID"];
        excersice.WorkoutID =  [workout intValue];
        excersice.PosterUrl= [[excersiced objectAtIndex: count] valueForKey: @"PosterUrl"];
        excersice.PosterName= [[excersiced objectAtIndex: count] valueForKey: @"PosterName"];
        excersice .PosterRepeatCount=[[excersiced objectAtIndex: count] valueForKey: @"PosterRepeatCount"];
        excersice.VideoUrl = [[excersiced objectAtIndex: count] valueForKey: @"VideoUrl"];
        excersice.Name =  [[excersiced objectAtIndex: count] valueForKey: @"Name"];
        excersice.RepeatCount =[[excersiced objectAtIndex: count] valueForKey: @"RepeatCount"];
        excersice.StopVideo= [[excersiced objectAtIndex: count] valueForKey: @"StopVideo"];
        excersice.StopName= [[excersiced objectAtIndex: count] valueForKey: @"StopName"];
        excersice.StopRep= [[excersiced objectAtIndex: count] valueForKey: @"StopRep"];
        excersice.OtherSidePoster= [[excersiced objectAtIndex: count] valueForKey: @"OtherSidePoster"];
        excersice.OthersidePosterName= [[excersiced objectAtIndex: count] valueForKey: @"OthersidePosterName"];
        excersice.OthersidePosterRep= [[excersiced objectAtIndex: count] valueForKey: @"OthersidePosterRep"];
        excersice.OthersideVideo= [[excersiced objectAtIndex: count] valueForKey: @"OthersideVideo"];
        excersice.OthersideName= [[excersiced objectAtIndex: count] valueForKey: @"OthersideName"];
        excersice.OthersideRep= [[excersiced objectAtIndex: count] valueForKey: @"OthersideRep"];
        excersice.RecoveryVideoUrl= [[excersiced objectAtIndex: count] valueForKey: @"RecoveryVideoUrl"];
        excersice.RecoveryVideoName= [[excersiced objectAtIndex: count] valueForKey:
                                      @"RecoveryVideoName"];
        excersice.NextVideo= [[excersiced objectAtIndex: count] valueForKey: @"NextVideo"];
        excersice.NextName= [[excersiced objectAtIndex: count] valueForKey: @"NextName"];
        excersice.NextRep= [[excersiced objectAtIndex: count] valueForKey: @"NextRep"];
        excersice.CompletedVideo= [[excersiced objectAtIndex: count] valueForKey: @"CompletedVideo"];
        excersice.CompletedName= [[excersiced objectAtIndex: count] valueForKey: @"CompletedName"];
        excersice.CompletedRep= [[excersiced objectAtIndex: count] valueForKey: @"CompletedRep"];
        [self insertSelfMadeExcersice:excersice];
        [excersice release];
        
    }
    
}





-(void)deleteSelfMadeExcersice:(int)workoutID{
    
    database =[FMDatabase databaseWithPath:databasePath];
    [database beginTransaction];
     NSString *query=[NSString stringWithFormat:@"Delete from SelfMadeWorkout where WorkoutID =%i",workoutID];
    [database executeUpdate:query];
    [database commit];
}


@end
