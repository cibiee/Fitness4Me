//
//  WorkoutDB.m
//  Fitness4Me
//
//  Created by Ciby on 23/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkoutDB.h"
#import "FocusDB.h"
#import "EquipmentDB.h"

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


#pragma mark ten minutes  section

-(void)getWorkoutsOfDuration:(NSString*)durations{
    
    
     [self selectWorkout];
    database =[FMDatabase databaseWithPath:databasePath];
    Workouts=[[NSMutableArray alloc]init];
    
    if(!database.open){
      //  NSLog(@"Databse not Open");
    }
    NSString *query =[NSString stringWithFormat:@"Select * from Workout where Duration =%@ order by IsLocked ASC",durations];
    FMResultSet *resultSet=[database executeQuery:query];

    while(resultSet.next)
    {
        NSString * workoutID =[resultSet stringForColumnIndex:0];
        NSString *name = [resultSet stringForColumnIndex:1];
        NSString *description = [resultSet stringForColumnIndex:2];
        NSString *rate =  [resultSet stringForColumnIndex:3];
        NSString *islocked;
        NSString *lockimageUrl;
            islocked =[resultSet stringForColumnIndex:4];
            if([islocked isEqualToString :@"false"]){
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
        NSString *duration=[resultSet stringForColumnIndex:11];
        Workout *workout = [[Workout alloc]initWithData:workoutID:name:rate:ImageUrl:Imagename:islocked:description:descriptionToDo:lockimageUrl:descriptionBig:thumbImageUrl:props:duration];
        [Workouts addObject:workout];
        [workout release];
    }
    
    [resultSet close];
}

-(void)insertWorkout:(Workout *)workout{
    
    database =[FMDatabase databaseWithPath:databasePath];
    if(!database.open){
        //NSLog(@"Databse not Open");
    }
    
    [database beginTransaction];
    [database executeUpdate:@"INSERT INTO Workout (WorkoutID,Name,Description,Rate,IsLocked,DescriptionToDo,ImageUrl,ImageName,DescriptionBig,ImageThumbUrl,Props,Duration) VALUES (?,?,?,?,?,?,?,?,?,?,?,?);",

       workout.WorkoutID,workout.Name,workout.Description,workout.Rate,workout.IsLocked,workout.DescriptionToDo,workout.ImageUrl,workout.ImageName,workout.DescriptionBig,workout.ThumbImageUrl, workout.Props,workout.Duration,nil];
    [database commit];
    [database close];
}





-(void)insertWorkouts:(NSMutableArray *)workouts
{
    int workoutCount =workouts.count;
    [self deleteWorkout];
    Workout *workout;
    for (int count=0; count<workoutCount; count++) {
        workout =[Workout new];
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
        workout.Duration = [[workouts objectAtIndex: count] valueForKey: @"Duration"];
        [self insertWorkout:workout];
       
        
    }
    
}




-(void)updateWorkout:(NSString *)workoutID :(NSString *)isLocked{
    database =[FMDatabase databaseWithPath:databasePath];
    if(!database.open){
       // NSLog(@"Databse not Open");
    }
    
    [database beginTransaction];
    NSString *Query;
    if ([workoutID isEqualToString:@"All"]) {
        Query =[NSString stringWithFormat:@"Update  Workout  set IsLocked = '%@'",isLocked];
    }
    else{
          Query =[NSString stringWithFormat:@"Update  Workout  set IsLocked = '%@' where WorkoutID = '%@'",isLocked,workoutID];
    }

    [database executeUpdate:Query];
    [database commit];
    [database close];

}



-(void)deleteWorkout{
    
    database =[FMDatabase databaseWithPath:databasePath];
    
    if(!database.open){
        //NSLog(@"Databse not Open");
    }
    
    [database beginTransaction];
    [database executeUpdate:@"Delete from Workout"];
    [database commit];
    [database close];
    
    
}

-(void)selectWorkout{
    
    database =[FMDatabase databaseWithPath:databasePath];

    if(!database.open){
      //  NSLog(@"Databse not Open");
    }
    FMResultSet *resultSet=[database executeQuery:@"select count(WorkoutID) from Workout where islocked ='false'"];
    while(resultSet.next){
        temp =[resultSet intForColumnIndex:0];
    }
    [resultSet close];    
}


#pragma mark CustomWorkout  section

-(void)insertCustomWorkout:(Workout *)workout{
    
    database =[FMDatabase databaseWithPath:databasePath];
    if(!database.open){
      //  NSLog(@"Databse not Open");
    }
    [database beginTransaction];
    [database executeUpdate:@"INSERT INTO CustomWorkout (WorkoutID,Name,Description,Rate,IsLocked,DescriptionToDo,ImageUrl,ImageName,DescriptionBig,ImageThumbUrl,Props,Duration,Focus) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?);",
     
     workout.WorkoutID,workout.Name,workout.Description,workout.Rate,workout.IsLocked,workout.DescriptionToDo,workout.ImageUrl,workout.ImageName,workout.DescriptionBig,workout.ThumbImageUrl, workout.Props,workout.Duration,workout.Focus,nil];
    NSLog([workout Focus]);
    [database commit];
    [database close];
    
}

-(void)insertCustomWorkouts:(NSMutableArray *)workouts
{
    int workoutCount =workouts.count;
    [self deleteCustomWorkout];
    Workout *workout;
    
    for (int count=0; count<workoutCount; count++) {
        
        workout =[Workout new];
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
        workout.Duration = [[workouts objectAtIndex: count] valueForKey: @"Duration"];
        workout.Focus = [[workouts objectAtIndex: count] valueForKey: @"Focus"];
        
        [self insertCustomWorkout:workout];
        [workout release];
        
    }
}

-(void)getCustomWorkouts{
    
    FocusDB *focusDB=[[FocusDB alloc]init];
    EquipmentDB *equipmentDB=[[EquipmentDB alloc]init];
    database =[FMDatabase databaseWithPath:databasePath];
    Workouts=[[NSMutableArray alloc]init];
    
    if(!database.open){
        // NSLog(@"Databse not Open");
    }
  
    FMResultSet *resultSet=[database executeQuery:@"Select * from CustomWorkout order by IsLocked DESC"];
    while(resultSet.next)
    {
        NSString * workoutID =[resultSet stringForColumnIndex:0];
        NSString *name = [resultSet stringForColumnIndex:1];
        NSString *description = [resultSet stringForColumnIndex:2];
        NSString *rate =  [resultSet stringForColumnIndex:3];
        NSString *islocked;
        NSString *lockimageUrl;
        islocked =[resultSet stringForColumnIndex:4];
        if([islocked isEqualToString :@"false"]){
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
        NSString *props =[equipmentDB getSelectedEquipments:[resultSet stringForColumnIndex:10]]; 
        NSString *duration =  [resultSet stringForColumnIndex:11];
        NSString *focus = [focusDB getSelectedFocus:[resultSet stringForColumnIndex:12]];
                
        Workout *workout = [[Workout alloc]initWithCustomData:workoutID:name:rate:ImageUrl:Imagename:islocked:description:descriptionToDo:lockimageUrl:descriptionBig:thumbImageUrl:props:duration:focus];
        [Workouts addObject:workout];
        [workout release];
        
    }
    
    [resultSet close];
    
    // [database close];
    
}

-(void)deleteCustomWorkout{
    
    database =[FMDatabase databaseWithPath:databasePath];
    if(!database.open){
        //NSLog(@"Databse not Open");
    }
    
    [database beginTransaction];
    [database executeUpdate:@"Delete from CustomWorkout"];
    [database commit];
    [database close];
}







-(Workout*)getCustomWorkoutByID:(NSString*)workoutID{
    
    FocusDB *focusDB=[[FocusDB alloc]init];
    EquipmentDB *equipmentDB=[[EquipmentDB alloc]init];
    database =[FMDatabase databaseWithPath:databasePath];
    Workout *workout;
    
    if(!database.open){
      //  NSLog(@"Databse not Open");
    }
        
    NSString *query =[NSString stringWithFormat:@"Select * from CustomWorkout where WorkoutID in (%@)",workoutID];
    FMResultSet *resultSet=[database executeQuery:query];
    while(resultSet.next)
    {
        NSString * workoutID =[resultSet stringForColumnIndex:0];
        NSString *name = [resultSet stringForColumnIndex:1];
        NSString *description = [resultSet stringForColumnIndex:2];
        NSString *rate =  [resultSet stringForColumnIndex:3];
        NSString *islocked;
        NSString *lockimageUrl;
        islocked =[resultSet stringForColumnIndex:4];
        if([islocked isEqualToString :@"false"]){
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
        NSString *props =[equipmentDB getSelectedEquipments:[resultSet stringForColumnIndex:10]];
        NSString *duration =  [resultSet stringForColumnIndex:11];
        NSString *focus = [focusDB getSelectedFocus:[resultSet stringForColumnIndex:12]];
        
       workout= [[Workout alloc]initWithCustomData:workoutID:name:rate:ImageUrl:Imagename:islocked:description:descriptionToDo:lockimageUrl:descriptionBig:thumbImageUrl:props:duration:focus];
    }
    [resultSet close];
    return workout;
}


-(void)updateCustomWorkout:(NSString *)workoutID :(NSString *)isLocked{
    database =[FMDatabase databaseWithPath:databasePath];
    if(!database.open){
        // NSLog(@"Databse not Open");
    }
    [database beginTransaction];
    NSString *Query;
    Query =[NSString stringWithFormat:@"Update  CustomWorkout  set IsLocked = '%@' where WorkoutID = '%@'",isLocked,workoutID];
    [database executeUpdate:Query];
    [database commit];
    // Close the database.
    [database close];
    
}




#pragma mark selfmade workout section


-(void)insertSelfMadeWorkout:(Workout *)workout{
    
    database =[FMDatabase databaseWithPath:databasePath];
    if(!database.open){
          NSLog(@"Databse not Open");
    }
    // [database setLogsErrors:TRUE];
    // [database setTraceExecution:TRUE];

    
    [database beginTransaction];
    [database executeUpdate:@"INSERT INTO SelfMadeExcersice (WorkoutID,Name,Description,Rate,IsLocked,DescriptionToDo,ImageUrl,ImageName,DescriptionBig,ImageThumbUrl,Props,Duration,Focus) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?);",
     
     workout.WorkoutID,workout.Name,workout.Description,workout.Rate,workout.IsLocked,workout.DescriptionToDo,workout.ImageUrl,workout.ImageName,workout.DescriptionBig,workout.ThumbImageUrl, workout.Props,workout.Duration,workout.Focus,nil];
    
    [database commit];
    [database close];
    
}

-(void)insertSelfMadeWorkouts:(NSMutableArray *)workouts
{
    int workoutCount =workouts.count;
    [self deleteSelfMadeWorkout];
    
    Workout *workout;
    
    for (int count=0; count<workoutCount; count++) {
        
        workout =[Workout new];
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
        workout.Duration = [[workouts objectAtIndex: count] valueForKey: @"Duration"];
        workout.Focus = [[workouts objectAtIndex: count] valueForKey: @"Focus"];
        [self insertSelfMadeWorkout:workout];
        [workout release];
        
    }
    
}

-(void)getSelfMadeWorkouts{
    
    FocusDB *focusDB=[[FocusDB alloc]init];
    EquipmentDB *equipmentDB=[[EquipmentDB alloc]init];
    
    database =[FMDatabase databaseWithPath:databasePath];
    Workouts=[[NSMutableArray alloc]init];
    
    if(!database.open){
        // NSLog(@"Databse not Open");
    }
        
    FMResultSet *resultSet=[database executeQuery:@"Select * from SelfMadeExcersice order by IsLocked DESC"];
    while(resultSet.next)
    {
        NSString * workoutID =[resultSet stringForColumnIndex:0];
        NSString *name = [resultSet stringForColumnIndex:1];
        NSString *description = [resultSet stringForColumnIndex:2];
        NSString *rate =  [resultSet stringForColumnIndex:3];
        NSString *islocked;
        NSString *lockimageUrl=@"";
        islocked =[resultSet stringForColumnIndex:4];
        NSString *descriptionToDo = [resultSet stringForColumnIndex:5];
        NSString *ImageUrl = [resultSet stringForColumnIndex:6];
        NSString *Imagename =  [resultSet stringForColumnIndex:7];
        NSString *descriptionBig = [resultSet stringForColumnIndex:8];
        NSString *thumbImageUrl =  [resultSet stringForColumnIndex:9];
        NSString *props =[equipmentDB getSelectedEquipments:[resultSet stringForColumnIndex:10]];
        NSString *duration =  [resultSet stringForColumnIndex:11];
        NSString *focus = [focusDB getSelectedFocus:[resultSet stringForColumnIndex:12]];
        
        Workout *workout = [[Workout alloc]initWithCustomData:workoutID:name:rate:ImageUrl:Imagename:islocked:description:descriptionToDo:lockimageUrl:descriptionBig:thumbImageUrl:props:duration:focus];
        [Workouts addObject:workout];
        [workout release];
    }
    
    [resultSet close];
}


-(Workout*)getSelfMadeByID:(NSString*)workoutID{
    
    FocusDB *focusDB=[[FocusDB alloc]init];
    EquipmentDB *equipmentDB=[[EquipmentDB alloc]init];
    database =[FMDatabase databaseWithPath:databasePath];
    Workout *workout;
    
    if(!database.open){
          NSLog(@"Databse not Open");
    }
    
    NSString *query =[NSString stringWithFormat:@"Select * from SelfMadeExcersice where WorkoutID in (%@)",workoutID];
    FMResultSet *resultSet=[database executeQuery:query];
    
    while(resultSet.next)
    {
        NSString * workoutID =[resultSet stringForColumnIndex:0];
        NSString *name = [resultSet stringForColumnIndex:1];
        NSString *description = [resultSet stringForColumnIndex:2];
        NSString *rate =  [resultSet stringForColumnIndex:3];
        NSString *islocked;
        NSString *lockimageUrl=@"";
        islocked =[resultSet stringForColumnIndex:4];
        NSString *descriptionToDo = [resultSet stringForColumnIndex:5];
        NSString *ImageUrl = [resultSet stringForColumnIndex:6];
        NSString *Imagename =  [resultSet stringForColumnIndex:7];
        NSString *descriptionBig = [resultSet stringForColumnIndex:8];
        NSString *thumbImageUrl =  [resultSet stringForColumnIndex:9];
        NSString *props =[equipmentDB getSelectedEquipments:[resultSet stringForColumnIndex:10]];
        NSString *duration =  [resultSet stringForColumnIndex:11];
        NSString *focus = [focusDB getSelectedFocus:[resultSet stringForColumnIndex:12]];
        
        workout= [[Workout alloc]initWithCustomData:workoutID:name:rate:ImageUrl:Imagename:islocked:description:descriptionToDo:lockimageUrl:descriptionBig:thumbImageUrl:props:duration:focus];
    }
    [resultSet close];
    return workout;
}


-(void)updateSelfMadeWorkout:(NSString *)workoutID :(NSString *)isLocked{
    database =[FMDatabase databaseWithPath:databasePath];
    if(!database.open){
        // NSLog(@"Databse not Open");
    }
    
    
    [database beginTransaction];
    NSString *Query;
    Query =[NSString stringWithFormat:@"Update  SelfMadeExcersice  set IsLocked = '%@' where WorkoutID = '%@'",isLocked,workoutID];
    [database executeUpdate:Query];
    [database commit];
    // Close the database.
    [database close];
    
}



-(void)deleteSelfMadeWorkout{
    
    database =[FMDatabase databaseWithPath:databasePath];
    
    if(!database.open){
        //NSLog(@"Databse not Open");
    }
    [database beginTransaction];
    [database executeUpdate:@"Delete from SelfMadeExcersice"];
    [database commit];
    // Close the database.
    [database close];
}



@end
