//
//  DXHeadlineViewController.m
//  Bug - AFNetwroking 
//
//  Created by DXSmile on 16/3/3.
//  Copyright © 2016年 DXSmile. All rights reserved.
//

#import "DXHeadlineViewController.h"
#import "UIImageView+WebCache.h"
#import "DXHTTPManager.h"
#import "DXHeadline.h"

@interface DXHeadlineViewController ()

@property (nonatomic,strong) NSArray *headline;

@end

@implementation DXHeadlineViewController

- (void)setHeadline:(NSArray *)headline {
    _headline = headline;
    
    // 重新加载tableview
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"头条新闻";
    
    // 暂时设定tableview的行高
    self.tableView.rowHeight = 70;
    
    // 控制器拿到新闻头条地址,调用方法加载数据
    [self setUpData:@"http://c.m.163.com/nc/article/headline/T1348647853363/0-140.html"];

}

// 当获取到新闻头条地址之后,发送异步请求 加载数据
- (void)setUpData:(NSString *)urlString {
    // 先讲headline设置为空
    self.headline = nil;
    
    // 异步加载数据
    [DXHeadline headlineWithURLString:urlString successBlock:^(NSArray *array) {
        self.headline = array;
    } errorBlock:^(NSError *error) {
        NSLog(@"连接出错 %@", error);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.headline.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headline" ];

    DXHeadline *model = self.headline[indexPath.row];
    
    
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.digest;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    
    return cell;
}




@end
