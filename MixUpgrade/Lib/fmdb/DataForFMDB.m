//
//  DataForFMDB.m
//  MyBase
//
//  Created by ciwei luo on 2020/7/17.
//  Copyright © 2020 macdev. All rights reserved.
//

#import "DataForFMDB.h"
#import "FMDB.h"

@interface DataForFMDB ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation DataForFMDB

static DataForFMDB *theData = nil;
+(instancetype)sharedDataBase{
    @synchronized(self) {
        if(!theData) {
            theData = [[DataForFMDB alloc] init];
            [theData initDataBase];
        }
    }
    return theData;
}


-(void)initDataBase{
    //获得Documents目录路径
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"data.sqlite"];
    //实例化FMDataBase对象
    NSLog(@"---path:%@",filePath);
    // 创建数据库实例
    self.queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    
    // 创建数据库表
    // 提供了一个多线程安全的数据库实例
    [_queue inDatabase:^(FMDatabase *db) {
        
        BOOL flag =  [db executeUpdate:@"create table if not exists t_data (id integer primary key autoincrement,name text,money integer)"];
        
        if (flag) {
            NSLog(@"success");
        }else{
            NSLog(@"failure");
        }
        
    }];
}


-(NSMutableArray*)getData{

    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *result =   [db executeQuery:@"select * from t_data"];
        
        while ([result next]) {
            NSString *name = [result stringForColumn:@"name"];
            int money = [result intForColumn:@"money"];
            NSLog(@"%@--%d",name,money);
        }
        
    }];

    return nil;
}





//调用
//self.dataArray = [[DataForFMDB sharedDataBase] getAllStudent];

-(BOOL)addData{
    __block BOOL is_add = YES;
    [_queue inDatabase:^(FMDatabase *db) {
        
        BOOL flag = [db executeUpdate:@"insert into t_data (name,money) values (?,?)",@"a",@1000];
        if (flag) {
            NSLog(@"success");
            is_add = YES;
        }else{
            NSLog(@"failure");
            is_add = NO;
        }
        
       // [db executeUpdate:@"insert into t_data (name,money) values (?,?)",@"b",@500];
        
    }];
    return is_add;
}


-(BOOL)deleteAllData{
    __block BOOL is_delete = YES;
    [_queue inDatabase:^(FMDatabase *db) {//NSString *SQL = @"delete from student where sId = ?";
        BOOL flag = [db executeUpdate:@"delete from t_data;"];
        if (flag) {
            NSLog(@"success");
            is_delete = YES;
        }else{
            NSLog(@"failure");
            is_delete = NO;
        }
        
    }];
    return is_delete;
}


-(BOOL)update{
    // update t_user set money = 500 where name = 'a';
    //  update t_user set money = 1000 where name = 'b';
    // a -> b 500 a 500
    // b + 500 = b 1000
    
    __block BOOL is_update = YES;
    [_queue inDatabase:^(FMDatabase *db) {
        
        // 开启事务
        [db beginTransaction];
        BOOL flag = [db executeUpdate:@"update t_data set money = ? where name = ?;",@500,@"a"];
        if (flag) {
            NSLog(@"success");
            is_update = YES;
        }else{
            NSLog(@"failure");
            is_update = NO;
            // 回滚
            [db rollback];
        }
        
//        BOOL flag1 = [db executeUpdate:@"updat t_user set money = ? where name = ?;",@1000,@"b"];
//        if (flag1) {
//            NSLog(@"success");
//        }else{
//            NSLog(@"failure");
//            [db rollback];
//        }
        
        // 全部操作完成时候再去
        [db commit];
    }];
    
    return is_update;
    
}

@end
