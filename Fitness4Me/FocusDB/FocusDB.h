//
//  FocusDB.h
//  Fitness4Me
//
//  Created by Ciby  on 04/12/12.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Focus.h"
@interface FocusDB : NSObject

@property(strong,nonatomic)NSString * databasePath;
@property(strong,nonatomic)NSString * databaseName;
@property(strong,nonatomic)NSMutableArray * muscles;
@property(strong,nonatomic)FMDatabase * database;




-(void)setUpDatabase;
-(void)createDatabase;
-(NSMutableArray*)getFocus;
-(void)insertFocusArea:(NSMutableArray *)muscles;



@end
