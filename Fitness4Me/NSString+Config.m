//
//  NSString+Config.m
//  Fitness4Me
//
//  Created by Ciby on 10/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Config.h"

@implementation NSString (Config)


+(NSString*)GetURlPath
{
    
NSString *UrlPath =[[NSString alloc]init];
NSString *filePath=[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"];

if( [[NSFileManager defaultManager]fileExistsAtPath:filePath] )
{
    
    NSDictionary *dict =[[NSDictionary alloc]initWithContentsOfFile:filePath];
    
    UrlPath =[dict valueForKey:@"UrlPath"];
    
   
    
   
}

     return UrlPath;
}


+(NSString*)getVideoPath
{
    
     NSString *UrlPath =[[NSString alloc]init];
    NSString *filePath=[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"];
    
    if( [[NSFileManager defaultManager]fileExistsAtPath:filePath] )
    {
        
        NSDictionary *dict =[[NSDictionary alloc]initWithContentsOfFile:filePath];
        
        UrlPath =[dict valueForKey:@"VideoUrl"];
        
               
        
    }
    
    return UrlPath;
}



+(NSString*)getDeviceRegisterPath
{
    
     NSString *UrlPath =[[NSString alloc]init];
    NSString *filePath=[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"];
    
    if( [[NSFileManager defaultManager]fileExistsAtPath:filePath] )
    {
        
        NSDictionary *dict =[[NSDictionary alloc]initWithContentsOfFile:filePath];
        
        UrlPath =[dict valueForKey:@"IphoneRegistration"];
        
        
    }
    
    return UrlPath;
}

@end
