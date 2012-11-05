//
//  Excersice.h
//  Fitness4Me
//
//  Created by Ciby K Jose on 02/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Excersice :  NSObject
{
    int WorkoutID;
    NSString * PosterUrl;
    NSString * PosterName;
    NSString *PosterRepeatCount;
    NSString * VideoUrl;
    NSString * Name;
    NSString *RepeatCount;
    NSString *StopVideo;
    NSString *StopName;
    NSString *StopRep ;
    NSString *OtherSidePoster ;
    NSString *OthersidePosterName;
    NSString *OthersidePosterRep;
    NSString *OthersideRep ;
    NSString *OthersideVideo;
    NSString *OthersideName;
    NSString * RecoveryVideoUrl;
    NSString * RecoveryVideoName;
    NSString *NextVideo ;
    NSString *NextName;
    NSString *NextRep ;
    NSString *CompletedVideo;
    NSString *CompletedName;
    NSString *CompletedRep;

    
    NSArray *workout_ID;
    NSArray * Poster_Url;
    NSArray * Poster_Name;
    NSArray *PosterRepeat_Count;
    NSArray * Video_Url;
    NSArray * _name;
    NSArray *Repeat_Count;
    NSArray *Stop_Video;
    NSArray *Stop_Name;
    NSArray *Stop_Rep ;
    NSArray *OtherSide_Poster ;
    NSArray *OthersidePoster_Name;
    NSArray *OthersidePoster_Rep;
    NSArray *Otherside_Rep ;
    NSArray *Otherside_Video;
    NSArray *Otherside_Name;
    NSArray * RecoveryVideo_Url;
    NSArray * RecoveryVideo_Name;
    NSArray *Next_Video ;
    NSArray *Next_Name;
    NSArray *Next_Rep ;
    NSArray *Completed_Video;
    NSArray *Completed_Name;
    NSArray *Completed_Rep;
}


@property(assign,nonatomic)int WorkoutID;
@property(retain, nonatomic)NSString *PosterUrl;
@property(retain,nonatomic)NSString *PosterName;
@property(assign,nonatomic)NSString * PosterRepeatCount;
@property(retain, nonatomic)NSString *VideoUrl;
@property( retain,nonatomic)NSString *Name;
@property(assign,nonatomic)NSString * RepeatCount;
@property(retain, nonatomic)NSString *StopVideo;
@property(retain, nonatomic)NSString *StopName;
@property(retain,nonatomic)NSString *StopRep;
@property(retain, nonatomic)NSString *OtherSidePoster;
@property(retain, nonatomic)NSString *OthersidePosterName;
@property(retain,nonatomic)NSString *OthersidePosterRep;
@property(retain, nonatomic)NSString *OthersideVideo;
@property(retain, nonatomic)NSString *OthersideName;
@property(retain,nonatomic)NSString *OthersideRep;
@property(retain, nonatomic)NSString *RecoveryVideoUrl;
@property(retain,nonatomic)NSString *RecoveryVideoName;
@property( retain,nonatomic)NSString *NextVideo;
@property(retain, nonatomic)NSString *NextName;
@property(retain,nonatomic)NSString *NextRep;
@property( retain,nonatomic)NSString *CompletedVideo;
@property(retain, nonatomic)NSString *CompletedName;
@property(retain,nonatomic)NSString *CompletedRep;






    

    //////
    ///Constructor of the class
    // Created 17-Oct-2011
    // Created by: Ciby K Jose
    // Function Name:initWithData
    // Function Description:  The constructor of the class.
    ///
    //////
-(id)initWithData:(int)workoutID:(NSString*)posterUrl:(NSString*)posterName:(NSString *)posterRepeatCount:(NSString*)videoUrl:(NSString*)name:(NSString *)repeatCount:
    (NSString*)stopVideo:(NSString*)stopName:(NSString*)stopRep:
    (NSString*)otherSidePoster:(NSString*)othersidePosterName:(NSString*)othersidePosterRep:
     (NSString*)othersideVideo:(NSString*)othersideName:(NSString*)othersideRep:
    (NSString*)recoveryVideoUrl:(NSString*)recoveryVideoName:
    (NSString*)nextVideo:(NSString*)nextName:(NSString*)nextRep:
    (NSString*)completedVideo:(NSString*)completedName:(NSString*)completedRep;


@end








