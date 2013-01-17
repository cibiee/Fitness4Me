//
//  UserDB.m
//  Fitness4Me
//
//  Created by Ciby on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserDB.h"

@implementation UserDB

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

//
// Get user details
//
-(User*)getUser{
    
    database =[FMDatabase databaseWithPath:databasePath];
    //[database setLogsErrors:TRUE];
    //[database setTraceExecution:TRUE];
    
    if(!database.open){
        NSLog(@"Databse not Open");
    }
    else{
       // NSLog(@"Database opened sucessfully");
    }
    
    FMResultSet *resultSet=[database executeQuery:@"Select * from User"];
    while(resultSet.next)
    {
        int  userID =[resultSet intForColumnIndex:0];
        NSString *username = [resultSet stringForColumnIndex:1];
        NSString *name = [resultSet stringForColumnIndex:2];
        NSString * userlevel = [resultSet stringForColumnIndex:3];
        Userdatails = [[[User alloc]initWithUserID:userID UserName:username Name:name andLevel:userlevel]autorelease];
    }
    
    [resultSet close];
    //[database close];
    return Userdatails;
}
//
// Insert the user details into database
//
-(void)insertUser:(User *)user{
    database =[FMDatabase databaseWithPath:databasePath];
   // [database setLogsErrors:TRUE];
   // [database setTraceExecution:TRUE];
    if(!database.open){
        NSLog(@"Databse not Open");
    }
    else{
       // NSLog(@"Database opened sucessfully");
    }
    
    NSString *userID= [NSString stringWithFormat:@"%i", user.UserID];
    [database beginTransaction];
    [database executeUpdate:@"INSERT INTO User (UserID,Username,Name,Userlevel) VALUES (?,?,?,?);",
    userID,user.Username,user.Name,user.Userlevel,nil];
    [database commit];
    // Close the database.
    [database close];
}
//
// Insert the user details into database
//
-(void)updateUser:(NSString*)userlevel{
    
    database =[FMDatabase databaseWithPath:databasePath];
    // [database setLogsErrors:TRUE];
    // [database setTraceExecution:TRUE];
    if(!database.open){
        NSLog(@"Databse not Open");
    }
    else{
        // NSLog(@"Database opened sucessfully");
    }

    [database beginTransaction];    
    NSString *query=[NSString stringWithFormat:@"Update  User  set Userlevel =%@",userlevel];
    [database executeUpdate:query];
    [database commit];
    // Close the database.
    [database close];
}

@end
