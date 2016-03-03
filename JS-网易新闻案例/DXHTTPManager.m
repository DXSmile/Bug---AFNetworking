//
//  DXHTTPManager.m
//  Bug - AFNetwroking 
//
//  Created by DXSmile on 16/3/3.
//  Copyright © 2016年 DXSmile. All rights reserved.
//

#import "DXHTTPManager.h"

@implementation DXHTTPManager

// 重写父类的manager方法,添加需要的类型
+ (instancetype)manager {
    DXHTTPManager *mgr = [super manager];
    
    NSMutableSet *newSet = [NSMutableSet set];
    newSet.set = mgr.responseSerializer.acceptableContentTypes;
    [newSet addObject:@"text/html"];
    
    mgr.responseSerializer.acceptableContentTypes = newSet;
    return mgr;
}

@end
