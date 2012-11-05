//
//  ExcersicePlay.m
//  Fitness4Me
//
//  Created by Ciby on 23/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExcersicePlay.h"

@implementation ExcersicePlay

@synthesize repeatIntervel,videoName,intro,intro_name,main,main_name,main_other,main_other_name;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


-(id)initWithData:(NSString*)intros:(NSString*)intro_names:(NSString *)mains:(NSString*)main_names:(NSString*)main_others:(NSString*)main_other_names
{
    
    self.intro =intros;
    self.intro_name=intro_names;
    self.main= mains;
    self.main_name=main_names;
    self.main_other=main_others;
    self.main_other_name=main_other_names;
    
    return self;
}


@end
