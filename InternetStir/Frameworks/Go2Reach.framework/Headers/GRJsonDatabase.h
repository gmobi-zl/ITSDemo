//
//  JsonDatabase.h
//  momock
//
//  Created by apple on 15/1/6.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef momock_GRJsonDatabase_h
#define momock_GRJsonDatabase_h

#import <Foundation/Foundation.h>
#import <sqlite3.h>

typedef BOOL (^GRIMomockFilter)(NSString* iid, NSDictionary* doc);

@interface GRMySQLiteOpenHelper : NSObject{
    sqlite3 *db;
    NSLock *lock;
}

+(GRMySQLiteOpenHelper*)getSQLiteDB;
+(void)closeSQLiteDB;

@property sqlite3* db;
@property NSLock* lock;

-(void)setData: (NSString*) dId
      saveName: (NSString*) name
      saveData: (NSString*) data;

-(NSString*)getStringData: (NSString*) dId
                  tarName: (NSString*) name;

-(void)deleteData: (NSString*) dId
          delName: (NSString*) name;

@end

@interface GRCollection : NSObject{
    GRMySQLiteOpenHelper* sqlHelper;
    NSString *name;
    NSMutableDictionary *cacheDocs;
    BOOL cacheable;
}

@property GRMySQLiteOpenHelper* sqlHelper;
@property NSString *name;
@property NSMutableDictionary *cacheDocs;
@property BOOL cacheable;

-(void) init: (GRMySQLiteOpenHelper*) helper
                  tagName: (NSString*) tName;

-(id) get: (NSString*) iid;
-(NSString*) set: (NSString*) iid
         setData: (id) data;
-(int) size;
-(NSMutableArray*) list;
-(NSMutableArray*) getDataListByStartCount: (int) start
                                 listCount: (int) count;
@end

@interface GRDocument : NSObject{
    GRCollection *col;
    NSString *iid;
    id jo;
}

@property GRCollection *col;
@property NSString *iid;
@property id jo;


-(void)init: (GRCollection*) pCol
      docId: (NSString*) documentId
    docData: (id) data;

-(NSString*) getId;
-(id) getData;

@end

@interface GRJsonDatabase : NSObject{
    NSMutableDictionary* cols;
    GRMySQLiteOpenHelper* sqlHelper;
}

@property NSMutableDictionary* cols;
@property GRMySQLiteOpenHelper* sqlHelper;

+(GRJsonDatabase*) get;

-(GRCollection*) getCollection: (NSString*) name;

-(void) forceClose;

@end

#endif
