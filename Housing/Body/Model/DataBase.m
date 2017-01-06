//
//  DataBase.m
//  Housing
//
//  Created by Ethan on 16/8/11.
//  Copyright © 2016年 Housing. All rights reserved.
//

#import "DataBase.h"
#import "FMDatabase.h"
#import "DrugSearchModel.h"

@interface DataBase ()

@end

@implementation DataBase

static DataBase *db;

+ (instancetype)shareDataBase
{
    if (db == nil)
    {
        db = [[DataBase alloc] init];
    }
    
    return db;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"T_DrugName" ofType:@".db"];
        
        _dataBase = [[FMDatabase alloc] initWithPath:path];
        
        if ([_dataBase open])
        {
            NSLog(@"%s,isOpen",__func__);
        }
    }
    
    return self;
    
}

- (DrugSearchModel *)createModel:(FMResultSet *)set
{
    DrugSearchModel *model = [[DrugSearchModel alloc] init];
    
    
    model.showName = [set stringForColumn:@"showName"];
    model.commonDrugName = [set stringForColumn:@"commonDrugName"];
    model.productDrugID = [set stringForColumn:@"productDrugID"];
    model.drugSpecifications = [set stringForColumn:@"drugSpecifications"];
    model.factory = [set stringForColumn:@"factory"];
    
    return model;
}


- (NSArray *)getAllDataBase:(NSString *)firstWord
{
    NSMutableArray *array = [NSMutableArray array];
    NSString *str = [firstWord uppercaseString];
    
    NSString *selectSql = [NSString stringWithFormat:@"SELECT showName,commonDrugName,productName,productDrugID,drugSpecifications,factory FROM T_DrugName WHERE firstWord = ? AND type = 1  ORDER BY commonPinYin ASC,productPinYin ASC LIMIT 100000"];
    FMResultSet *set = [_dataBase executeQuery:selectSql,str];
    
    while ([set next]) {
        
        DrugSearchModel *model = [self createModel:set];
        
        [array addObject:model];
    }
    return array;
}


- (NSArray *)getDrugMessageWithpinYinOrDrugName:(NSString *)insertText
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *a = [insertText uppercaseString];
    
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM T_DrugName WHERE (commonPinYin LIKE '%@%%' OR productPinYin LIKE '%@%%' OR showName LIKE '%%%@%%') AND type = 1 ORDER BY commonPinYin ASC,productPinYin ASC",a,a,a];
    
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    
    while ([set next]) {
        
        DrugSearchModel *model = [self createModel:set];
        
        [array addObject:model];
    }
    return array;
}

- (NSArray *)getDrugMessageWithProdouctDrugIDArray:(NSString *)productDrugIDArray
{
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM T_DrugName WHERE productDrugID in (?) "];
    FMResultSet *set = [_dataBase executeQuery:selectSql,productDrugIDArray];
    
    NSMutableArray *array = [NSMutableArray array];
    
    while ([set next]) {
        
        DrugSearchModel *model = [self createModel:set];
        
        [array addObject:model];
    }
    return array;
}

- (DrugSearchModel *)getDrugMessageWithProdouctDrugID:(NSString *)productDrugID
{
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM T_DrugName WHERE productDrugID in (?) GROUP BY drugSpecifications"];
    FMResultSet *set = [_dataBase executeQuery:selectSql,productDrugID];
    
    DrugSearchModel *model = [[DrugSearchModel alloc] init];
    while ([set next]) {
        
        model = [self createModel:set];
        
    }
    return model;
}

- (NSArray *)getDrugMessageWithCommonDrugName:(NSString *)commonDrugName
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *selectSql = @"SELECT * FROM T_DrugName WHERE commonDrugName = ? GROUP BY factory,drugSpecifications ORDER BY length(factory) ASC, drugOrder DESC";
    FMResultSet *set = [_dataBase executeQuery:selectSql,commonDrugName];
    
    while ([set next]) {
        
        DrugSearchModel *model = [self createModel:set];
        
        [array addObject:model];
    }
    return array;
}

- (NSArray *)getAddDrugMessageWithpinYinOrDrugName:(NSString *)insertText
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *a = [insertText uppercaseString];
    
    NSLog(@"%@",a);
    
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM T_DrugName WHERE (commonPinYin LIKE '%@%%' OR productPinYin LIKE '%@%%' OR showName LIKE '%%%@%%' AND isValidData=1) GROUP BY showName,drugSpecifications ORDER BY commonPinYin ASC,productPinYin ASC",a,a,a];
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    
    while ([set next]) {
        
        DrugSearchModel *model = [self createModel:set];
        [array addObject:model];
    }
    return array;
}


@end
