# Bug---AFNetworking

以上为个人愚见, 如有不妥,望大家斧正!!! 

如需转载,请注明转载自[DXSmile](https://github.com/DXSmile)GitHub项目


##阐述:
在获取网络数据的时候, 我们一般会使用到一个非常著名的框架: AFNetworking框架, 可以说,这是作为iOS攻城狮必备的框架之一;
这个框架是非常强大的一个框架, 对于发送异步请求来说,简直没有比这个更好用的了, 不过,在使用的过程中,我们可能会遇到这样一个bug: 如下
```
连接出错 Error Domain=com.alamofire.error.serialization.response Code=-1016 
"Request failed: unacceptable content-type: text/html" UserInfo=
{com.alamofire.serialization.response.error.response=<NSHTTPURLResponse: 0x7f93fad1c4b0> 
{ URL: http://c.m.163.com/nc/article/headline/T1348647853363/0-140.html } 
{ status code: 200, headers { .....}
...... 
 22222c22 626f6172 64696422 3a226e65 77735f73 68656875 69375f62 6273222c 22707469 6d65223a 22323031 362d3033 2d303320 31313a30 323a3435 227d5d7d>,
 NSLocalizedDescription=Request failed: unacceptable content-type: text/html}
```
####说明:
  由于数据很多,所以返回的请求体,和响应体部分我用省略号(......)代替了, 但是,通过上面的返回的信息,我们不难看出,状态码是200, 而且也有一堆数据, 但是在tableviewCell中就是没有显示, 在最后的时候还出现"NSLocalizedDescription=Request failed: unacceptable content-type: text/html} " 这样一句话;
#### 分析:那么这个错误是什么原因造成的呢?
通过这句话:unacceptable content-type: text/html,我们可以看出报错原因:是不接收的内容类型,也就是说AFNetworking框架不支持解析text/html这种格式. 那么怎样解决呢? 

##### 首先我们需要明白: AFNetworking为什么能够解析服务器返回的东西呢?
**因为manager有一个responseSerializer属性.它只设置了一些固定的解析格式.其中不包含text/html这种数据的格式.因为解析报错了.**
我们来看一下AFNetworking解析格式的底层:
```
 self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
```
通过底层,我们也可以看见,确实是没有text/html这种数据的格式的,


#####那如何解决这个问题呢?
错误的解决方法
下面我尝试了三种方法: 
##### 解决方法1:   直接给acceptableContentTypes属性添加类型

解决之前: 
```
 self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
```

![解决之前](http://upload-images.jianshu.io/upload_images/1483059-0dce8d862ce1eb70.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

着手解决:
```
   AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManagermanager];

    // 添加 text/html 类型到可接收内容类型中
    mgr.responseSerializer.acceptableContentTypes= [NSSetsetWithObjects:@"text/html", nil];
```
运行结果: 

![解决之后:](http://upload-images.jianshu.io/upload_images/1483059-eb03908cf75c4646.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

通过执行结果可以很明显的看得出,我们已经非常成功的获取到了数据;
##### 对方法1的思考:
 **首先,我们可以明显的看出,方法1确实是可以解决问题的,但是这样解决真的好吗?   不一定! 
为什么呢? 很简单, 如果我们只是发送一条网络请求,无疑方法1是最恰当的解决方案了,  但是实际开发中,我们不可能只发一次请求, 那么就需要我们每次发请求的时候都来写一次这些代码; 当然,如果您愿意写,那我也没办法多说什么了;
很显然,这个方法是存在不足的! **

于是我们有了第二种方法: 
#### 解决办法2: 直接到框架的源代码中添加类型
解决之前: 
```
 self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
```

解决之后: 
```
 self.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json" ,@"text/javascript", nil];
```
##### 分析方法2:
不得不说,这也是一种办法, 而且釜底抽薪,效果方面呢,当然也是显而易见了, 但是, 注意了,这个方法2 又真的恰当吗? 真的好吗?  

**我们来假设一种情况, 而且实际开发中必然会发生的情况: 这个框架更新了!!!
对,就是更新了!!!  更新了显然又会回到之前的状态 
傻眼了吧?   **
实际开发中,我们都会用cocoaPods来管理我们的第三方框架,  当某个框架更新之后, cocoaPods会下载最新的框架源码镶嵌到我们的项目中, 我们并不能保证AFNetworking这个框架一定会把我们需要的类型添加上去, 所以**每一次更新,我们都需要针对源码再做一次修改**
很显然,这也是费力不讨好的;

那么有没有一劳永逸的方法呢?  别急,马上就来!!!

#### 解决办法3: 自定义一个manager ,拓展一个类型
##### >>这里需要考虑到两种情况: 如下
###### >1. 如果你的APP只需要适配iOS7.0之前的版本,为了能够适配旧系统,需要使用 AFHTTPRequestOperationManager 

 
###### >2. 如果你的APP只需要适配iOS7.0之后的版本,那么你需要 自定义的类是继承AFHTTPSessionManager的

这里我只简单的介绍iOS7.0之后的版本,

1>	自定义manager,继承自AFHTTPSessionManager
```
@interface DXHTTPManager : AFHTTPSessionManager
```
2>	在.m文件中,重写父类的manager方法  目的 : 添加类型
```
+ (instancetype)manager {
    DXHTTPManager *mgr = [super manager];
    // 创建NSMutableSet对象
    NSMutableSet *newSet = [NSMutableSet set];
    // 添加我们需要的类型 
    newSet.set = mgr.responseSerializer.acceptableContentTypes;
    [newSet addObject:@"text/html"];
    
    // 重写给 acceptableContentTypes赋值
    mgr.responseSerializer.acceptableContentTypes = newSet;
    
    return mgr;
}
```
3>	在发送请求的时候,使用我们自定义的类来发送请求
```
[[DXHTTPManager manager] GET:@"http://...." 
parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) 
{
    NSLog(@"请求成功 -- %@",responseObject);
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"请求失败 -- %@",error);
}];
```

执行结果: 


![方法3执行结果:](http://upload-images.jianshu.io/upload_images/1483059-7d8b56fa24d99588.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#####  结论:
 使用方法3来解决这个bug,虽然看似比第一种,第二种要繁琐一些,实则可拓展性,和维护方面,要好得多,以后我们开发项目的时候, 只需要将我们自定义的这个类拖进去就可以了, 假如有需要新的类型的时候, 也只是简单的多配置一下类型即可, 
而这也正是我们代码重构, 和优化项目架构的思路之一!!!



 





 








