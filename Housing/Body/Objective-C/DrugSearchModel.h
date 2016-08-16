//
//  DrugSearchModel.h
//  Housing
//
//  Created by Ethan on 16/8/11.
//  Copyright © 2016年 Housing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrugSearchModel : NSObject

@property (nonatomic,strong) NSString *showName;//药品名（展示）
@property (nonatomic,strong) NSString *commonDrugName;//药品通用名
@property (nonatomic,strong) NSString *productDrugID;//商品药物ID
@property (nonatomic,strong) NSString *drugSpecifications;//药品规格
@property (nonatomic,strong) NSString *factory;// 生产厂家

@end
