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
       // NSLog(@"Databse not Open");
    }
    
    
    FMResultSet *resultSet=[self.database executeQuery:@"Select * from focus"];
    while(resultSet.next){
        NSString * focusId =[resultSet stringForColumnIndex:0];
        NSString *focusName = [[resultSet stringForColumnIndex:1]capitalizedString];
         Focus *focus = [[Focus alloc]init];
        [focus setMuscleID:focusId];
        [focus setMuscleName:focusName];
        [self.muscles addObject:focus];
    }
    
    [resultSet close];
   // NSLog(@"%i",[self.muscles count]);
    return self.muscles;
    
    
    
}





-(NSString*)getSelectedFocus:(NSString*)muscleID{
    [self setUpDatabase];
    [self createDatabase];
    
    self.database =[FMDatabase databaseWithPath:self.databasePath];
    NSString *focus =[[NSString alloc]init];
    if(!self.database.open){
      //  NSLog(@"Databse not Open");
    }
    if ( [muscleID length] > 0){
        NSString *lastChar = [muscleID substringFromIndex:[muscleID length] - 1];
        if([lastChar isEqualToString:@","])
        {
            muscleID = [muscleID substringToIndex:[muscleID length] - 1];
        }
    }

    NSString *query =[NSString stringWithFormat:@"Select * from focus where muscleID in (%@)",muscleID];
    FMResultSet *resultSet=[self.database executeQuery:query];
     
    
        while (resultSet.next) {
            
        
        if ([focus length]==0) {
          
            focus =[focus stringByAppendingString:[resultSet stringForColumnIndex:1]];
            
        }
       else
       {
           
           focus=[focus stringByAppendingString:@", "];
           if ([resultSet stringForColumnIndex:1] !=nil) {
                focus =[focus stringByAppendingString:[resultSet stringForColumnIndex:1]];
           }
          

       }
    }
    
    NSString *capitalizedfocus= [[NSString alloc]init];
    NSArray* foo = [focus componentsSeparatedByString: @","];
    
    for (NSString *focuses in foo) {
        if ([capitalizedfocus length]==0) {
            capitalizedfocus =[[capitalizedfocus stringByAppendingString:focuses]capitalizedString];
        }else{
            capitalizedfocus=[capitalizedfocus stringByAppendingString:@","];
            capitalizedfocus =[[capitalizedfocus stringByAppendingString:focuses]capitalizedString];
        }
        
     
    }

    
    [resultSet close];

    return capitalizedfocus;
    
    
    
}

-(NSMutableArray*)getFocusArray:(NSString*)muscleName{
    [self setUpDatabase];
    [self createDatabase];
   
    self.database =[FMDatabase databaseWithPath:self.databasePath];
    NSMutableArray *focus =[[NSMutableArray alloc]init];
    if(!self.database.open){
       // NSLog(@"Databse not Open");
    }
    
    NSString *query =[NSString stringWithFormat:@"Select * from focus where muscleName in (%@)",muscleName];
    FMResultSet *resultSet=[self.database executeQuery:query];
    
    
    while (resultSet.next) {
        
    
        [focus addObject:[resultSet stringForColumnIndex:0]];
        
       
    }
    
    
    [resultSet close];
    
    return focus;
    
    
    
}



-(void)insertEquipment:(Focus *)focus{
    
    self.database =[FMDatabase databaseWithPath:self.databasePath];
    
    if(!self.database.open){
        //NSLog(@"Databse not Open");
    }
    // NSLog(@"%@",focus.muscleID);
    
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
      //  NSLog(@"Databse not Open");
    }
    
    [self.database beginTransaction];
    [self.database executeUpdate:@"Delete from Focus"];
    [self.database commit];
    [self.database close];
}


@end
