//
//  CustomFavourites.h
//  Fitness4Me
//
//  Created by Ciby  on 17/12/12.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Favourite.h"

@interface CustomFavourites : NSObject
{
    NSString * databasePath;
    
    NSString * databaseName;
    
    FMDatabase * database;
    
    NSMutableArray *arrStatistics;
}

-(void)setUpDatabase;

-(void)createDatabase;

-(NSMutableArray*)getWorkouts;
-(void)insertfavourite:(Favourite *)favourite;
-(void)deletefavourite;
-(void)deletefavouritewithID:(NSString*)workoutID;

@end
