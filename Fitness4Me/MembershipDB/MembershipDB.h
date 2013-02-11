//
//  MembershipDB.h
//  Fitness4Me
//
//  Created by Ciby  on 29/01/13.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Membership.h"

@interface MembershipDB : NSObject
{
    NSString * databasePath;
    NSString * databaseName;
    FMDatabase * database;
    NSMutableArray *memberships;
}
@property (retain, nonatomic) NSMutableArray *memberships;

-(void)setUpDatabase;
-(void)createDatabase;

-(NSMutableArray*)getMemberships;
-(void)insertMembership:(Membership *)favourite;
-(void)insertMemberships:(NSMutableArray *)arrMemberships;
@end
