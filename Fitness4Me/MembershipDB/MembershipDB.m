//
//  MembershipDB.m
//  Fitness4Me
//
//  Created by Ciby  on 29/01/13.
//
//

#import "MembershipDB.h"

@implementation MembershipDB
@synthesize memberships;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)setUpDatabase
{
    databaseName =@"Fitness.sqlite";
    NSArray *docPath= NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDir =[docPath objectAtIndex:0];
    databasePath =[docDir stringByAppendingPathComponent:databaseName];
}


-(void)createDatabase{
    
    BOOL success;
    NSFileManager *filemanager =[NSFileManager defaultManager];
    success =[filemanager  fileExistsAtPath:databasePath];
    if(success){
        return;
    }
    NSString *databaseFromPath=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:databaseName];
    [filemanager copyItemAtPath:databaseFromPath toPath:databasePath error:nil];
}









-(NSMutableArray*)getMemberships{
    
    database =[FMDatabase databaseWithPath:databasePath];
    memberships=[[NSMutableArray alloc]init];
    if(!database.open){
        NSLog(@"Databse not Open");
    }else{
        //  NSLog(@"Database opened sucessfully");
    }
    
    FMResultSet *resultSet=[database executeQuery:@"Select * from Membership"];
    while(resultSet.next){
        Membership *membership =[[Membership alloc]init];
        membership.membershipID =[resultSet stringForColumnIndex:0];
        membership.rate=[resultSet stringForColumnIndex:1];
        membership.discount  =[resultSet stringForColumnIndex:2];
        membership.free =[resultSet stringForColumnIndex:3];
        membership.advanceMonths=[resultSet stringForColumnIndex:4] ;
        membership.description  =[resultSet stringForColumnIndex:5];
        membership.name  =[resultSet stringForColumnIndex:6];
        membership.currency=[resultSet stringForColumnIndex:7];
        membership.appleID =[resultSet stringForColumnIndex:8];
        [memberships addObject:membership];
        
    }
    [resultSet close];
    return memberships;
}


-(void)insertMembership:(Membership *)membership{
    
    database =[FMDatabase databaseWithPath:databasePath];
    if(!database.open){
        NSLog(@"Databse not Open");
    }
    [database beginTransaction];
    [database executeUpdate:@"INSERT INTO Membership (membershipID,rate,discount,free,advanceMonths,description,name,currency,appleID) VALUES (?,?,?,?,?,?,?,?,?);",
     membership.membershipID,membership.rate,membership.discount,
     membership.free,membership.advanceMonths,membership.description,membership.name,membership.currency,
     membership.appleID,nil];
    [database commit];
    [database close];
}


-(void)insertMemberships:(NSMutableArray *)arrMemberships;
{
    
    [self deleteMembership];
    
     Membership *membership;
    
    for (int count=0; count<[arrMemberships count]; count++) {
        
        membership =[Membership new];
        
               
        membership.membershipID =[[arrMemberships objectAtIndex: count] valueForKey:@"membershipID"];
        membership.rate=[[arrMemberships objectAtIndex: count] valueForKey:@"rate"];
        membership.discount  =[[arrMemberships objectAtIndex: count] valueForKey:@"discount"];
        membership.free =[[arrMemberships objectAtIndex: count] valueForKey:@"free"];
        membership.advanceMonths=[[arrMemberships objectAtIndex: count] valueForKey:@"advanceMonths"];
        membership.description  =[[arrMemberships objectAtIndex: count] valueForKey:@"description"];
        membership.name  =[[arrMemberships objectAtIndex: count] valueForKey:@"name"];
        membership.currency=[[arrMemberships objectAtIndex: count] valueForKey:@"currency"];
        membership.appleID =[[arrMemberships objectAtIndex: count] valueForKey:@"appleID"];
        [self insertMembership:membership];
        
    }
    
}


-(void)deleteMembership{
    
    database =[FMDatabase databaseWithPath:databasePath];
    if(!database.open){
        NSLog(@"Databse not Open");
    }else{
        // NSLog(@"Database opened sucessfully");
    }
    [database beginTransaction];
    [database executeUpdate:@"Delete from Membership"];
    [database commit];
    // Close the database.
    [database close];
    
    
}


@end
