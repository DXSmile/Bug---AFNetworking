//
//  DXHeadline.m
//  Bug - AFNetwroking 
//
//  Created by DXSmile on 16/3/3.
//  Copyright © 2016年 DXSmile. All rights reserved.
//

#import "DXHeadline.h"
#import "DXHTTPManager.h"

@implementation DXHeadline


+ (instancetype)headlineWithDcit:(NSDictionary *)dict {
    DXHeadline *headline = [[self alloc] init];

    [headline setValuesForKeysWithDictionary:dict];
    
    return headline;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

// 发送异步请求,加载数据, 字典转模型
+ (void)headlineWithURLString:(NSString *)urlString successBlock:(void (^)(NSArray *))successBlock errorBlock:(void (^)(NSError *))errorBlock {
    
    // 使用自定义的manager发送请求
    [[DXHTTPManager manager] GET:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        
        // 新闻字典数组
        NSArray *dictArray = responseObject[@"T1348647853363"];
        NSMutableArray *mArray = [NSMutableArray array];
        [dictArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DXHeadline *model = [self headlineWithDcit:obj];
            [mArray addObject:model];
        }];
        // 成功的回调
        if (successBlock) {
            successBlock(mArray.copy);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 错误的回调
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    
}



@end
