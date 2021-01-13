//
//  DataForFMDB.h
//  MyBase
//
//  Created by ciwei luo on 2020/7/17.
//  Copyright © 2020 macdev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataForFMDB : NSObject
+(instancetype)sharedDataBase;
-(NSMutableArray*)getData;
-(BOOL)addData;
-(BOOL)deleteAllData;
-(BOOL)update;
@end

NS_ASSUME_NONNULL_END
