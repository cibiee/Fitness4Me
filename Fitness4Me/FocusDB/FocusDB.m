//
//  FocusDB.m
//  Fitness4Me
//
//  Created by Ciby  on 04/12/12.
//
//

#import "FocusDB.h"

@implementation FocusDB
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
    self.databaseName =@"Fitness.sqlite";
    NSArray *docPath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir =[docPath objectAtIndex:0];
    self.databasePath =[docDir stringByAppendingPathComponent:self.databaseName];
    
    
}


-(void)createDatabase{
    
    BOOL success;
    NSFileManager *filemanager =[NSFileManager defaultManager];
    success =[filemanager  fileExistsAtPath:self.databasePath];
    if(success){
        return;
    }
    
    NSString *databaseFromPath=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:self.databaseName];
    [filemanager copyItemAtPath:databaseFromPath toPath:self.databasePath error:nil];
}


-(NSMutableArray*)getFocus{
    
    self.database =[FMDatabase databaseWithPath:self.databasePath];
    self.muscles=[[NSMutableArray alloc]init];
    
    if(!self.database.open){
        NSLog(@"Databse not Open");
    }
    
    
    FMResultSet *resultSet=[self.database executeQuery:@"Select * from focus"];
    while(resultSet.next){
        NSString * focusId =[resultSet stringForColumnIndex:0];
        NSString *focusName = [resultSet stringForColumnIndex:1];
         Focus *focus = [[Focus alloc]init];
        [focus setMuscleID:focusId];
        [focus setMuscleName:focusName];
        [self.muscles addObject:focus];
    }
    
    [resultSet close];
    NSLog(@"%i",[self.muscles count]);
    return self.muscles;
    
    
    
}


-(void)insertEquipment:(Focus *)focus{
    
    self.database =[FMDatabase databaseWithPath:self.databasePath];
    
    if(!self.database.open){
        NSLog(@"Databse not Open");
    }
     NSLog(@"%@",focus.muscleID);
    
    [self.database beginTransaction];
    
    [self.database executeUpdate:@"INSERT INTO focus (muscleID,muscleName) VALUES (?,?);",
     
     focus.muscleID,focus.muscleName, nil];
    
    
    [self.database commit];
    
    
    // Close the database.
    [self.database close];
    
    
}


-(void)insertFocusArea:(NSMutableArray *)muscles
{
    int musclesCount =muscles.count;
    [self deleteFocus];
    
    Focus *focus;
    
    for (int count=0; count<musclesCount; count++) {
        
        focus =[Focus new];
        
        // NSString *excersiceIdnetity =[[excersices objectAtIndex: count] valueForKey:@"ExcersiceID"];
        focus.muscleID =  [[muscles objectAtIndex: count] valueForKey:@"muscleID"];
        focus.muscleName = [[muscles objectAtIndex: count] valueForKey: @"muscleName"];
        
        [self insertEquipment:focus];
        
    }
    
}





-(void)deleteFocus{
    
    self.database =[FMDatabase databaseWithPath:self.databasePath];
    
    if(!self.database.open){
        NSLog(@"Databse not Open");
    }
    
    [self.database beginTransaction];
    [self.database executeUpdate:@"Delete from Focus"];
    [self.database commit];
    [self.database close];
}


@end
