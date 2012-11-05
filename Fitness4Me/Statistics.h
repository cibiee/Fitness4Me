//
//  Statistics.h
//  Fitness4Me
//
//  Created by Ciby on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Statistics : NSObject
{
   
    NSString *WorkoutID;
    
    NSString *Duration;
    
    
}


@property (nonatomic,retain) NSString *WorkoutID;


@property (nonatomic,retain) NSString *Duration;



-(id)initWithData:(NSString*)workoutID:(NSString*)duration;

@end
