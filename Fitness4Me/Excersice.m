//
//  Excersice.m
//  Fitness4Me
//
//  Created by Ciby K Jose on 02/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Excersice.h"

@implementation Excersice


@synthesize VideoUrl,Name,PosterUrl,PosterName,RepeatCount,PosterRepeatCount,WorkoutID,RecoveryVideoUrl,RecoveryVideoName,CompletedName,CompletedRep,CompletedVideo,NextName,NextRep,NextVideo,OtherSidePoster,OthersidePosterRep,OthersidePosterName,StopRep,StopName,StopVideo,OthersideRep,OthersideName,OthersideVideo;
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

-(id)initWithData:(int)workoutID :(NSString*)posterUrl :(NSString*)posterName :(NSString *)posterRepeatCount :(NSString*)videoUrl :(NSString*)name :(NSString*)repeatCount :
    (NSString*)stopVideo :(NSString*)stopName :(NSString*)stopRep :
    (NSString*)otherSidePoster :(NSString*)othersidePosterName :(NSString*)othersidePosterRep :
    (NSString*)othersideVideo :(NSString*)othersideName :(NSString*)othersideRep :
    (NSString*)recoveryVideoUrl :(NSString*)recoveryVideoName :
    (NSString*)nextVideo :(NSString*)nextName :(NSString*)nextRep :
    (NSString*)completedVideo :(NSString*)completedName :(NSString*)completedRep
{
    self = [super init];
    if (self)
    {
   
        self.WorkoutID =workoutID;
        
        self.PosterName=posterName;
        self.PosterUrl=posterUrl;
        self.PosterRepeatCount=posterRepeatCount;
        
        self.VideoUrl= videoUrl;
        self.Name=name;
        self.RepeatCount=repeatCount;
        
        self.StopName= stopName;
        self.StopRep=stopRep;
        self.StopVideo=stopVideo;
        
        self.OthersidePosterRep= otherSidePoster;
        self.OthersidePosterName=othersidePosterName;
        self.OtherSidePoster=otherSidePoster;
        
        
        self.OthersideRep= othersideRep;
        self.OthersideVideo=othersideVideo;
        self.OthersideName=othersideName;

        self.NextRep= nextRep;
        self.NextName=nextName;
        self.NextVideo=nextVideo;
        
        self.RecoveryVideoName=recoveryVideoName;
        self.RecoveryVideoUrl=recoveryVideoUrl;

        self.CompletedVideo= completedVideo;
        self.CompletedName=completedName;
        self.CompletedRep=completedRep;


     
    }
    return self;
}



@end