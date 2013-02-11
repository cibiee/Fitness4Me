//
//  ExcersicePlay.h
//  Fitness4Me
//
//  Created by Ciby on 23/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExcersicePlay : NSObject
{
    int repeatIntervel;
    NSString *videoName;
    
    NSString *intro;
    NSString *intro_name;
    NSString *main;
    NSString *main_name;
    NSString *main_other;
    NSString *main_other_name;

}

@property (nonatomic,assign)int repeatIntervel;
@property (nonatomic,retain) NSString *videoName;

@property (nonatomic,retain) NSString *intro;
@property (nonatomic,retain) NSString *intro_name;
@property (nonatomic,retain) NSString *main;
@property (nonatomic,retain) NSString *main_name;
@property (nonatomic,retain) NSString *main_other;
@property (nonatomic,retain) NSString *main_other_name;

-(id)initWithData:(NSString*)intros :(NSString*)intro_names :(NSString *)mains :(NSString*)main_names :(NSString*)main_others :(NSString*)main_other_names;

@end
