//
//  DataBase.h
//  Housing
//
//  Created by Ethan on 16/8/11.
//  Copyright © 2016年 Housing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DrugSearchModel,FMDatabase;

@interface DataBase : NSObject

@property (strong, nonatomic) FMDatabase *dataBase;

+ (instancetype)shareDataBase;
// 首字母查询
- (NSArray *)getAllDataBase:(NSString *)firstWord;

/**
 *  通过拼音和药品名查询药品信息
 *
 *  @param insertText 输入项
 *
 *  @return 查询药品数组
 */
- (NSArray *)getDrugMessageWithpinYinOrDrugName:(NSString *)insertText;


- (NSArray *)getDrugMessageWithProdouctDrugIDArray:(NSString *)productDrugIDArray;

/**
 *  通过药品的商品药物ID获得药品信息
 *
 *  @param ProdouctDrugID  商品药物ID
 *
 *  @return 药品信息
 */
- (DrugSearchModel *)getDrugMessageWithProdouctDrugID:(NSString *)productDrugID;


/**
 *  通过通用药品名和type查询查看更多药品
 *
 *  @param commonDrugName 通用药品名
 *
 *  @return 药品信息
 */
- (NSArray *)getDrugMessageWithCommonDrugName:(NSString *)commonDrugName;

/**
 *  添加药品时通过拼音和药品名查询药品信息
 *
 *  @param insertText 输入项
 *
 *  @return 查询药品数组
 */
- (NSArray *)getAddDrugMessageWithpinYinOrDrugName:(NSString *)insertText;
@end
