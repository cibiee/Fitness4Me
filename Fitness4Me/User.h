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
    NSString *ID;
    NSString * Username;
    NSString * password;
    NSString * Name;
    NSString * Userlevel;
    NSString *hasMadeFullPurchase;
    NSString *email;
}


@property(assign,nonatomic)int UserID;
@property(retain, nonatomic)NSString *Username;
@property(retain, nonatomic)NSString *Name;
@property (retain ,nonatomic)NSString *Userlevel;
@property (retain ,nonatomic)NSString *hasMadeFullPurchase;
@property (retain ,nonatomic)NSString *email;
@property (retain ,nonatomic)NSString *password;
@property (retain ,nonatomic)NSString *ID;

//
// class initializer 
//

+ (User *)sharedState;

-(id)initWithUserID:(int)userID UserName:(NSString*)username Name:(NSString*)name andLevel:(NSString*)userlevel;

-(User*)getUserPreferences;



@end
