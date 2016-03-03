//
//  DXHeadline.h
//  Bug - AFNetwroking 
//
//  Created by DXSmile on 16/3/3.
//  Copyright © 2016年 DXSmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXHeadline : NSObject
/** 新闻标题 */
@property (nonatomic , copy) NSString *title;
/** 新闻摘要 */
@property (nonatomic , copy) NSString *digest;
/** 图片 */
@property (nonatomic , copy) NSString *imgsrc;
/** 新闻url */
@property (nonatomic , copy) NSString *url;
/** 新闻url */
@property (nonatomic , copy) NSString *url_3w;
/** 新闻id */
@property (nonatomic , copy) NSString *docid;

// 字典转模型的方法
+ (instancetype)headlineWithDcit:(NSDictionary *)dict;

//发送异步请求，获取数据，字典转模型
+ (void)headlineWithURLString:(NSString *)urlString successBlock:(void(^)(NSArray *array))successBlock errorBlock:(void(^)(NSError *error))errorBlock;


@end
