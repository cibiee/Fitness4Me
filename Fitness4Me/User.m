//
//  User.m
//  Fitness4Me
//
//  Created by Ciby on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User
static User *sharedState;
@synthesize UserID,Username,Name,Userlevel,hasMadeFullPurchase,email,password,ID;
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


+ (User *)sharedState {
    
    @synchronized(self) {
        if (sharedState == nil)
            sharedState = [[self alloc] init];
    }
    return sharedState;
    
    
}

-(User*)getUserPreferences{
    User *user = [[User alloc]init];
    
     NSUserDefaults *userInfo =[NSUserDefaults standardUserDefaults];
    [user setName:[userInfo valueForKey:@"Name"]];
    [user setUserlevel:[userInfo valueForKey:@"Userlevel"]];
    [user setUsername:[userInfo valueForKey:@"Username"]];
    [user setPassword:[userInfo valueForKey:@"password"]];
    [user setID:[userInfo valueForKey:@"UserID"]];
    [user setEmail:[userInfo valueForKey:@"email"]];
    [user setHasMadeFullPurchase:[userInfo valueForKey:@"hasMadeFullPurchase"]];
    return user;
}


@end
