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



+ (instancetype)headlineWithDcit:(NSDictionary *)dict;

+ (void)headlineWithURLString:(NSString *)urlString successBlock:(void(^)(NSArray *array))successBlock errorBlock:(void(^)(NSError *error))errorBlock;


@end
