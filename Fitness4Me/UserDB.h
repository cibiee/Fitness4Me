//
//  UserDB.h
//  Fitness4Me
//
//  Created by Ciby on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "User.h"

@interface UserDB : NSObject
{
    User *Userdatails;
    NSString * databasePath;
    NSString * databaseName;
    FMDatabase * database;
}
-(void)setUpDatabase;
-(void)createDatabase;
-(User *)getUser;
-(void)insertUser:(User *)user;
-(void)updateUser:(NSString*)userlevel;

@end
