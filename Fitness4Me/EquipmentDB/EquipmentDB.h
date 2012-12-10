//
//  EquipmentDB.h
//  Fitness4Me
//
//  Created by Ciby  on 03/12/12.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Equipments.h"
@interface EquipmentDB : NSObject

@property(strong,nonatomic)NSString * databasePath;
@property(strong,nonatomic)NSString * databaseName;
@property(strong,nonatomic)NSMutableArray * equipments;
@property(strong,nonatomic)FMDatabase * database;
   
    
    

-(void)setUpDatabase;
-(void)createDatabase;
-(NSMutableArray*)getequipments;
-(void)insertEquipments:(NSMutableArray *)equipments;

-(NSString*)getSelectedEquipments:(NSString*)equipmentID;
-(NSMutableArray*)getEquipmentsArray:(NSString*)equipmentsName;
@end
