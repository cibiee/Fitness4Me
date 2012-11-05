//
//  User.h
//  Fitness4Me
//
//  Created by Ciby on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
{
    int UserID;
    NSString * Username;
    NSString * Name;
    NSString * Userlevel;
}


@property(assign,nonatomic)int UserID;
@property(retain, nonatomic)NSString *Username;
@property(retain, nonatomic)NSString *Name;
@property (retain ,nonatomic)NSString *Userlevel;

//
// class initializer 
//
-(id)initWithUserID:(int)userID UserName:(NSString*)username Name:(NSString*)name andLevel:(NSString*)userlevel;

@end
