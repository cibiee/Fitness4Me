//
//  Workout.m
//  Fitness4Me
//
//  Created by Ciby on 23/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Workout.h"

@implementation Workout
@synthesize WorkoutID,Description,DescriptionToDo,LockImageUrl,ThumbImageUrl,DescriptionBig;
@synthesize Name,ImageUrl,ImageName,Rate,IsLocked,Props,Duration,Focus,PropsName,FocusName;
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

-(id)initWithData:(NSString*)workoutID:(NSString*)name:(NSString *)rate:(NSString*)imageUrl:(NSString*)imageName:(NSString*)isLocked:(NSString*)description:(NSString*)descriptionToDo:(NSString *)lockImageUrl:(NSString*)descriptionBig:(NSString *)thumbImageUrl:(NSString *)props

{
    
    self.WorkoutID =workoutID;
    self.Description=description;
    self.Name= name;
    self.Rate=rate;
    self.ImageName=imageName;
    self.ImageUrl=imageUrl;
    self.DescriptionToDo=descriptionToDo;
    self.IsLocked=isLocked;
    self.LockImageUrl=lockImageUrl;
    self.DescriptionBig=descriptionBig;
    self.ThumbImageUrl=thumbImageUrl;
     self.Props=props;
        return self;
}

-(id)initWithCustomData:(NSString*)workoutID:(NSString*)name:(NSString *)rate:(NSString*)imageUrl:(NSString*)imageName:(NSString*)isLocked:(NSString*)description:(NSString*)descriptionToDo:(NSString *)lockImageUrl:(NSString*)descriptionBig:(NSString *)thumbImageUrl:(NSString *)props:(NSString *)durations:(NSString *)focusarea 

{
    
    self.WorkoutID =workoutID;
    self.Description=description;
    self.Name= name;
    self.Rate=rate;
    self.ImageName=imageName;
    self.ImageUrl=imageUrl;
    self.DescriptionToDo=descriptionToDo;
    self.IsLocked=isLocked;
    self.LockImageUrl=lockImageUrl;
    self.DescriptionBig=descriptionBig;
    self.ThumbImageUrl=thumbImageUrl;
    self.Props=props;
    self.Focus=focusarea;
    self.Duration=durations;
    
    return self;
}


@end
