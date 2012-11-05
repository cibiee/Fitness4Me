//
//  Statistics.m
//  Fitness4Me
//
//  Created by Ciby on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Statistics.h"

@implementation Statistics

@synthesize WorkoutID,Duration;


-(id)initWithData:(NSString*)workoutID:(NSString*)duration{
    self = [super init];
    if (self)
    {
        self.WorkoutID=workoutID;
        self.Duration=duration;
    }
    return self;
}

@end
