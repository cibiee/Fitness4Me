//
//  CustomFavourites.m
//  Fitness4Me
//
//  Created by Ciby  on 17/12/12.
//
//

#import "CustomFavourites.h"

@implementation CustomFavourites
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
    
    FMResultSet *resultSet=[database executeQuery:@"Select * from favourites"];
    while(resultSet.next){
        Favourite *favourite =[[Favourite alloc]init];
        favourite.WorkoutID =[resultSet stringForColumnIndex:0];
        favourite.status  =[[resultSet stringForColumnIndex:1]intValue];
        [arrStatistics addObject:favourite];
      
    }
    [resultSet close];
    return arrStatistics;
}


-(void)insertfavourite:(Favourite *)favourite{
    
    database =[FMDatabase databaseWithPath:databasePath];
    if(!database.open){
        NSLog(@"Databse not Open");
    }
    [database beginTransaction];
    [database executeUpdate:@"INSERT INTO favourites (workoutID,status) VALUES (?,?);",
     favourite.workoutID,[NSString stringWithFormat:@"%i",favourite.status], nil];
    [database commit];
    
    [database close];
}


-(void)deletefavourite{
    
    database =[FMDatabase databaseWithPath:databasePath];
    if(!database.open){
        NSLog(@"Databse not Open");
    }else{
        // NSLog(@"Database opened sucessfully");
    }
    [database beginTransaction];
    [database executeUpdate:@"Delete from favourites"];
    [database commit];
    // Close the database.
    [database close];
    
    
}

-(void)deletefavouritewithID:(NSString*)workoutID{
    
    database =[FMDatabase databaseWithPath:databasePath];
    if(!database.open){
        NSLog(@"Databse not Open");
    }else{
        // NSLog(@"Database opened sucessfully");
    }
    [database beginTransaction];
    NSString *query =[NSString stringWithFormat:@"Delete from favourites where workoutID = %@",workoutID];
    [database executeUpdate:query];
    [database commit];
    // Close the database.
    [database close];
    
    
}

@end
