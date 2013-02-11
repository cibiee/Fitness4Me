//
//  Membership.h
//  Fitness4Me
//
//  Created by Ciby  on 29/01/13.
//
//

#import <Foundation/Foundation.h>

@interface Membership : NSObject

@property(nonatomic,retain) NSString *membershipID;
@property(nonatomic,retain) NSString *rate;
@property(nonatomic,retain) NSString *discount;
@property(nonatomic,retain) NSString *free;
@property(nonatomic,retain) NSString *advanceMonths;
@property(nonatomic,retain) NSString *description;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *currency;
@property(nonatomic,retain) NSString *appleID;

@end
