//
//  FitnessServer.m
//  Fitness4Me
//
//  Created by Ciby  on 17/12/12.
//
//

#import "FitnessServer.h"

@implementation FitnessServer

static FitnessServer *sharedState;

#pragma mark -
#pragma mark FitnessServerCommunication singleton method

+ (FitnessServer *)sharedState {
    
    @synchronized(self) {
        if (sharedState == nil)
            sharedState = [[self alloc] init];
        
    }
    return sharedState;
}




@end
