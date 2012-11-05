//
//  Workout.h
//  Fitness4Me
//
//  Created by Ciby on 23/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Workout : NSObject
{
    NSString *WorkoutID;
    
    NSString * Name;
    
    NSString * Rate;
    
    NSString *ImageUrl;
    
    NSString *ImageName;
    
    NSString * IsLocked;
    
    NSString *Description;
    
    NSString *DescriptionToDo;
    
    NSString *LockImageUrl;
    
    NSString *DescriptionBig;
    
    NSString *ThumbImageUrl;
    
    NSString *Props;
    
}

@property(retain,nonatomic)NSString *WorkoutID;


@property(retain, nonatomic)NSString *Name;

@property(retain,nonatomic) NSString *Rate;

@property(retain,nonatomic)NSString *ImageUrl;

@property(retain,nonatomic)NSString *ImageName;

@property( retain,nonatomic)NSString *Description;

@property(retain, nonatomic)NSString *DescriptionToDo;

@property(retain, nonatomic)NSString *IsLocked;

@property(retain,nonatomic)NSString *LockImageUrl;

@property(retain, nonatomic)NSString *DescriptionBig;

@property(retain,nonatomic)NSString *ThumbImageUrl;

@property(retain,nonatomic)NSString *Props;

//////
///Constructor of the class
// Created 17-Oct-2011
// Created by: Ciby K Jose
// Function Name:initWithData
// Function Description:  The constructor of the class.
///
//////
-(id)initWithData:(NSString*)workoutID:(NSString*)name:(NSString *)rate:(NSString*)imageUrl:(NSString*)imageName:(NSString*)isLocked:(NSString*)description:(NSString*)descriptionToDo:(NSString *)lockImageUrl:(NSString*)descriptionBig:(NSString *)thumbImageUrl:(NSString *)Props;


@end
