//
//  ExcersiceList.h
//  Fitness4Me
//
//  Created by Ciby  on 12/12/12.
//
//

#import <Foundation/Foundation.h>

@interface ExcersiceList : NSObject

@property(strong,nonatomic)NSString *excersiceID;
@property(strong,nonatomic)NSString *time;
@property(strong, nonatomic)NSString *equipments;
@property(strong,nonatomic)NSString *name;
@property(strong, nonatomic)NSString *focus;
@property(strong,nonatomic)NSString *imageUrl;
@property(strong,nonatomic)NSString *imageName;
@property(nonatomic)BOOL isChecked;


@end
