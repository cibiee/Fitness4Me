//
//  User.m
//  Fitness4Me
//
//  Created by Ciby on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize UserID,Username,Name,Userlevel;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

//////
///Constructor of the class
// Created 2-Mar-2011
// Created by: Ciby K Jose
// Function Name:initWithData
// Function Description:  The constructor of the class.
///
//////

-(id)initWithUserID:(int)userID UserName:(NSString*)username Name:(NSString*)name andLevel:(NSString*)userlevel{
    self.UserID =userID; 
    self.Username= username;
    self.Name=name;
    self.Userlevel =userlevel;
    return self;
}



@end
