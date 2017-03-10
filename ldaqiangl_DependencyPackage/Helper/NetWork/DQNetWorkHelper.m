//
//  DQNetWorkHelper.m
//  daqiangTest
//
//  Created by 董富强 on 2017/3/7.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import "DQNetWorkHelper.h"
#import "AFNetworking.h"

@interface DQNetWorkHelper ()

@property (strong, nonatomic) AFHTTPSessionManager *httpSessionManager;
@property (strong, nonatomic) AFURLSessionManager *urlSessionManager;

@end

@implementation DQNetWorkHelper

#pragma mark - -> initialization
- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _timeoutInterval = 60;
        _usingHttps = NO;
        _cerFilePath = [[NSBundle mainBundle] pathForResource:@"certificate"
                                                       ofType:@"cer"];
    }
    return self;
}

+ (instancetype)sharedNetWorkHelper {
    
    static DQNetWorkHelper *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        
        _instance = [[DQNetWorkHelper alloc] init];
    });
    
    return _instance;
}


#pragma mark - -> LazyLoading
- (AFHTTPSessionManager *)httpSessionManager {
    
    /**
     要使用常规的AFN网络访问
     
     1. AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     
     所有的网络请求,均有manager发起
     
     2. 需要注意的是,默认提交请求的数据是二进制的,返回格式是JSON
     
     1> 如果提交数据是JSON的,需要将请求格式设置为AFJSONRequestSerializer
     2> 如果返回格式不是JSON的,
     
     3. 请求格式
     
     AFHTTPRequestSerializer            二进制格式
     AFJSONRequestSerializer            JSON
     AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
     
     4. 返回格式
     
     AFHTTPResponseSerializer           二进制格式
     AFJSONResponseSerializer           JSON
     AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
     AFXMLDocumentResponseSerializer (Mac OS X)
     AFPropertyListResponseSerializer   PList
     AFImageResponseSerializer          Image
     AFCompoundResponseSerializer       组合
     */
    
    if (_httpSessionManager == nil)
    {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _httpSessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
        _httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    return _httpSessionManager;
}

- (AFURLSessionManager *)urlSessionManager
{
    if (_urlSessionManager == nil)
    {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _urlSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
        
        __weak typeof(self) weakSelf = self;
        [_urlSessionManager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest *(NSURLSession *session,
                                                                                   NSURLSessionTask *task,
                                                                                   NSURLResponse *response,
                                                                                   NSURLRequest *request)
         {
             if (weakSelf.taskWillPerformHTTPRedirection)
                 return weakSelf.taskWillPerformHTTPRedirection(session, task, response, request);
             return request;
         }];
        
        [_urlSessionManager setDataTaskDidReceiveDataBlock:^(NSURLSession *session,
                                                             NSURLSessionDataTask *dataTask,
                                                             NSData *data)
         {
             if (weakSelf.dataTaskDidReceiveData)
                 weakSelf.dataTaskDidReceiveData(session, dataTask, data);
         }];
        
        [_urlSessionManager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession *session,
                                                                                                NSURLSessionDataTask *dataTask,
                                                                                                NSURLResponse *response)
         {
             if (weakSelf.dataTaskDidReceiveResponse)
                 return weakSelf.dataTaskDidReceiveResponse(session, dataTask, response);
             return NSURLSessionResponseAllow;
         }];
        
        [_urlSessionManager setTaskDidCompleteBlock:^(NSURLSession *session,
                                                      NSURLSessionTask *task,
                                                      NSError *error)
         {
             if (weakSelf.taskDidComplete)
                 weakSelf.taskDidComplete(session, task, error);
         }];
    }
    
    return _urlSessionManager;
}

- (void)setUsingHttps:(BOOL)usingHttps
{
    _usingHttps = usingHttps;
    
    if (_usingHttps) _httpSessionManager.securityPolicy = [self securityPolicy];
}

- (void)setCerFilePath:(NSString *)cerFilePath
{
    _cerFilePath = cerFilePath;
    
    _httpSessionManager.securityPolicy = [self securityPolicy];
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval
{
    _timeoutInterval = timeoutInterval;
    
    _httpSessionManager.requestSerializer.timeoutInterval = _timeoutInterval;
}

- (void)setCustomRequestHeader:(NSArray<NSDictionary *> *)customRequestHeader
{
    _customRequestHeader = customRequestHeader;
    
    for (NSDictionary *dict in _customRequestHeader)
    {
        NSArray *keyArrI = dict.allKeys;
        for (NSString *key in keyArrI)
        {
            [_httpSessionManager.requestSerializer setValue:[dict objectForKey:key]
                                         forHTTPHeaderField:key];
        }
    }
}

#pragma mark - -> AFHTTPSessionManager
/** http请求 */
- (void)requestWithHttpMethod:(DQHttpMethodType)httpMethod
                          url:(NSString *)urlString
                       params:(NSDictionary *)params
                      success:(successBlock)success
                      failure:(failureBlock)failure
{
    // 选择不同HttpMethod
    switch (httpMethod)
    {
        case eHttpMethodTypePOST:
            [self POST:urlString params:params success:success failure:failure];
            break;
        case eHttpMethodTypeDELETE:
            [self DELETE:urlString params:params success:success failure:failure];
            break;
        case eHttpMethodTypePUT:
            [self PUT:urlString params:params success:success failure:failure];
            break;
        case eHttpMethodTypeGET:
            [self GET:urlString params:params success:success failure:failure];
            break;
        default:
            break;
    }
}

/** POST */
- (void)POST:(NSString *)urlString
      params:(NSDictionary *)params
     success:(successBlock)success
     failure:(failureBlock)failure
{
    [[self httpSessionManager]
     POST:urlString
     parameters:params
     progress:^(NSProgress *uploadProgress) {}
     success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if (success) success(responseObject);
     }
     failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
         if (failure) failure(response, error);
     }];
}

/** DELETE */
- (void)DELETE:(NSString *)urlString
        params:(NSDictionary *)params
       success:(successBlock)success
       failure:(failureBlock)failure
{
    [[self httpSessionManager]
     DELETE:urlString
     parameters:params
     success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if (success) success(responseObject);
     }
     failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
         if (failure) failure(response, error);
     }];
}

/** PUT */
- (void)PUT:(NSString *)urlString
     params:(NSDictionary *)params
    success:(successBlock)success
    failure:(failureBlock)failure
{
    [[self httpSessionManager]
     PUT:urlString
     parameters:params
     success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if (success) success(responseObject);
     }
     failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
         if (failure) failure(response, error);
     }];
}

/** GET */
- (void)GET:(NSString *)urlString
     params:(NSDictionary *)params
    success:(successBlock)success
    failure:(failureBlock)failure
{
    [[self httpSessionManager]
     GET:urlString
     parameters:params
     progress:^(NSProgress *downloadProgress) {}
     success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if (success) success(responseObject);
     }
     failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
         if (failure) failure(response, error);
     }];
}

/** POST(multipart) */
- (void)POST:(NSString *)urlString
      params:(NSDictionary *)params
        data:(NSData *)data
        name:(NSString *)name
    mimeType:(NSString *)mimeType
     success:(successBlock)success
     failure:(failureBlock)failure
{
    __block NSString *tempName = name;
    [[self httpSessionManager]
     POST:urlString
     parameters:params
     constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         // 要上传保存在服务器中的名称
         // 使用时间来作为文件名 2014-04-30 14:20:57.png
         // 让不同的用户信息,保存在不同目录中
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
         NSString *fileName = [formatter stringFromDate:[NSDate date]];
         if (nil == name || name.length <=0 ) tempName = fileName;
         [formData appendPartWithFileData:data name:tempName
                                 fileName:fileName mimeType:mimeType];
     }
     progress:^(NSProgress *uploadProgress) {}
     success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if (success) success(responseObject);
     }
     failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
         if (failure) failure(response, error);
     }];
}

/** HEAD */
- (void)HEAD:(NSString *)urlString
      params:(NSDictionary *)params
     success:(successBlock)success
     failure:(failureBlock)failure
{
    [[self httpSessionManager]
     HEAD:urlString
     parameters:params
     success:^(NSURLSessionDataTask *task)
     {
         if (success) success(task);
     }
     failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
         if (failure) failure(response, error);
     }];
}

/** PATCH */
- (void)PATCH:(NSString *)urlString
       params:(NSDictionary *)params
      success:(successBlock)success
      failure:(failureBlock)failure
{
    [[self httpSessionManager]
     PATCH:urlString
     parameters:params
     success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if (success) success(responseObject);
     }
     failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
         if (failure) failure(response, error);
     }];
}

#pragma mark - -> AFURLSessionManager
/** DataTask */
- (void)dataTaskRequest:(NSURLRequest *)request
                   sync:(BOOL)isSync
                success:(successBlock)success
                failure:(failureBlock)failure
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^
                   {
                       __block dispatch_semaphore_t semapthore = dispatch_semaphore_create(0);
                       [[[self urlSessionManager]
                         dataTaskWithRequest:request
                         completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                         {
                             if (!error)
                             {
                                 if (success) success(responseObject);
                             }
                             else
                             {
                                 if (failure) failure((NSHTTPURLResponse *)response, error);
                             }
                             
                             dispatch_semaphore_signal(semapthore);
                         }] resume];
                       
                       if (isSync) dispatch_semaphore_wait(semapthore, DISPATCH_TIME_FOREVER);
                   });
}

/** DataTask，有上传或下载进度 */
- (void)dataTaskRequest:(NSURLRequest *)request
                   sync:(BOOL)isSycn
         uploadProgress:(void (^)(NSProgress *))uploadProgressBlock
       downloadProgress:(void (^)(NSProgress *))downloadProgressBlock
                success:(successBlock)success
                failure:(failureBlock)failure
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^
                   {
                       __block dispatch_semaphore_t semapthore = dispatch_semaphore_create(0);
                       NSURLSessionDataTask *dataTask =
                       [[self urlSessionManager]
                        dataTaskWithRequest:request
                        uploadProgress:^(NSProgress *uploadProgress)
                        {
                            if (uploadProgressBlock)
                            {
                                uploadProgressBlock(uploadProgress);
                                if (uploadProgress.fractionCompleted == 1.0)
                                    dispatch_semaphore_signal(semapthore);
                            }
                        }
                        downloadProgress:^(NSProgress *downloadProgress)
                        {
                            if (downloadProgressBlock)
                            {
                                downloadProgressBlock(downloadProgress);
                                if (downloadProgress.fractionCompleted == 1.0)
                                    dispatch_semaphore_signal(semapthore);
                            }
                        }
                        completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                        {
                            if (!error)
                            {
                                if (success) success(responseObject);
                            }
                            else
                            {
                                if (failure) failure((NSHTTPURLResponse *)response, error);
                            }
                        }];
                       
                       [dataTask resume];
                       if (isSycn) dispatch_semaphore_wait(semapthore, DISPATCH_TIME_FOREVER);
                   });
}

/** UploadTask(FileUrl) */
- (void)uploadTaskRequest:(NSURLRequest *)request
                 fromFile:(NSURL *)fileUrl
                 progress:(void (^)(NSProgress *))uploadProgressBlock
                  success:(successBlock)success
                  failure:(failureBlock)failure
{
    NSURLSessionUploadTask *uploadTask =
    [[self urlSessionManager]
     uploadTaskWithRequest:request
     fromFile:fileUrl
     progress:^(NSProgress *uploadProgress)
     {
         if (uploadProgressBlock) uploadProgressBlock(uploadProgress);
     }
     completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
     {
         if (!error)
         {
             if (success) success(responseObject);
         }
         else
         {
             if (failure) failure((NSHTTPURLResponse *)response, error);
         }
     }];
    
    [uploadTask resume];
}

/** UploadTask(BodyData) */
- (void)uploadTaskRequest:(NSURLRequest *)request
                 fromData:(NSData *)bodyData
                 progress:(void (^)(NSProgress *))uploadProgressBlock
                  success:(successBlock)success
                  failure:(failureBlock)failure
{
    NSURLSessionUploadTask *uploadTask =
    [[self urlSessionManager]
     uploadTaskWithRequest:request
     fromData:bodyData
     progress:^(NSProgress *uploadProgress)
     {
         if (uploadProgressBlock) uploadProgressBlock(uploadProgress);
     }
     completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
     {
         if (!error)
         {
             if (success) success(responseObject);
         }
         else
         {
             if (failure) failure((NSHTTPURLResponse *)response, error);
         }
     }];
    
    [uploadTask resume];
}

/** UploadTask */
- (void)uploadTaskRequest:(NSURLRequest *)request
                 progress:(void (^)(NSProgress *))uploadProgressBlock
                  success:(successBlock)success
                  failure:(failureBlock)failure
{
    NSURLSessionUploadTask *uploadTask =
    [[self urlSessionManager]
     uploadTaskWithStreamedRequest:request
     progress:^(NSProgress *uploadProgress)
     {
         if (uploadProgressBlock) uploadProgressBlock(uploadProgress);
     }
     completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
     {
         if (!error)
         {
             if (success) success(responseObject);
         }
         else
         {
             if (failure) failure((NSHTTPURLResponse *)response, error);
         }
     }];
    
    [uploadTask resume];
}

/** downloadTask */
- (void)downloadTaskRequest:(NSURLRequest *)request
                   progress:(void (^)(NSProgress *))downloadProgressBlock
                    success:(successBlock)success
                    failure:(failureBlock)failure
{
    NSURLSessionDownloadTask *downloadTask =
    [[self urlSessionManager]
     downloadTaskWithRequest:request
     progress:^(NSProgress * downloadProgress)
     {
         if (downloadProgressBlock) downloadProgressBlock(downloadProgress);
     }
     destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
     {
         NSFileManager *fileM = [NSFileManager defaultManager];
#if 0
         NSURL *documentsDirectoryURL = [fileM URLForDirectory:NSDocumentDirectory
                                                      inDomain:NSUserDomainMask
                                             appropriateForURL:nil
                                                        create:NO
                                                         error:nil];
         NSURL *URL = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
#endif
         NSString *doucumentDirectory =
         [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
          lastObject];
         NSString *fullPath =
         [doucumentDirectory stringByAppendingPathComponent:[response suggestedFilename]];
         if ([fileM fileExistsAtPath:fullPath]) [fileM removeItemAtPath:fullPath error:NULL];
         NSURL *fileURL = [NSURL fileURLWithPath:fullPath];
         
         return fileURL;
     }
     completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
     {
         NSLog(@"<%@>文件保存到:%@", [response suggestedFilename], filePath);
         if (!error)
         {
             if (success) success(filePath);
         }
         else
         {
             
             if (failure) failure((NSHTTPURLResponse *)response, error);
         }
     }];
    
    [downloadTask resume];
}

#pragma mark - -> AFNetworkReachabilityManager
/** 监测网络连接是否可用 */
- (void)isReachable:(void (^)(bool isReachable))success
{
    // 实例网络状态管理者
    AFNetworkReachabilityManager *reachabilityMgr = [AFNetworkReachabilityManager sharedManager];
    
    // 网络变化回调
    [reachabilityMgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         BOOL isReachable;
         switch (status)
         {
             case AFNetworkReachabilityStatusUnknown:
             case AFNetworkReachabilityStatusReachableViaWWAN:
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 isReachable = YES;
                 break;
             case AFNetworkReachabilityStatusNotReachable:
                 isReachable = NO;
                 break;
         }
         
         if (success) success(isReachable);
     }];
    
    // 开启检测
    [reachabilityMgr startMonitoring];
}

/** 判断网络连接类型 */
- (void)reachabilityStatus:(void (^)(DQNetworkStatus status))success
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
     */
    
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:
     ^(AFNetworkReachabilityStatus status)
     {
         NSString *network = nil;
         switch (status)
         {
             case AFNetworkReachabilityStatusUnknown:
                 network = @"未知网络";
                 break;
             case AFNetworkReachabilityStatusNotReachable:
                 network = @"无网络";
                 break;
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 network = @"移动网络";
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 network = @"WIFI";
                 break;
         }
         
         NSLog(@"当前网络状态:%@", network);
         
         // 返回当前网络类型
         if (success) success((NSInteger)status);
     }];
}

#pragma mark - Other
/** 判断是否是标准的 URL 地址 */
- (BOOL)isValidateURL:(NSString *)url
{
    NSString *regular = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    BOOL match = [predicate evaluateWithObject:url];
    
    return match;
}

/** 暂停所有请求任务 */
- (void)pauseAllRequestTask
{
    NSMutableArray *tasksArrM = [NSMutableArray array];
    [tasksArrM addObjectsFromArray:self.httpSessionManager.tasks];
    [tasksArrM addObjectsFromArray:self.urlSessionManager.tasks];
    
    [tasksArrM enumerateObjectsUsingBlock:^(NSURLSessionTask *dataTask,
                                            NSUInteger idx,
                                            BOOL * _Nonnull stop)
     {
         [dataTask suspend];
     }];
}

/**
 @author daqiang
 
 @brief 恢复所有请求任务
 */
- (void)resumeAllRequestTask
{
    NSMutableArray *tasksArrM = [NSMutableArray array];
    [tasksArrM addObjectsFromArray:self.httpSessionManager.tasks];
    [tasksArrM addObjectsFromArray:self.urlSessionManager.tasks];
    
    [tasksArrM enumerateObjectsUsingBlock:^(NSURLSessionTask *dataTask,
                                            NSUInteger idx,
                                            BOOL * _Nonnull stop)
     {
         [dataTask resume];
     }];
}

/** 设置网络请求拦截类 */
- (void)setURLProtocol:(Class)customUrlProtocol
{
    if ([customUrlProtocol isKindOfClass:[NSURLProtocol class]])
    {
        
    }
}

#pragma mark - -> Private
/**
 配置请求的安全策略
 
 @return AFSecurityPolicy
 */
- (AFSecurityPolicy *)securityPolicy
{
    if (!self.cerFilePath || !self.cerFilePath.length) return nil;
    NSLog(@"certificate 路径:%@", self.cerFilePath);
    NSData *caCert = [NSData dataWithContentsOfFile:self.cerFilePath];
    NSAssert(caCert != nil, @"证书文件不存在!");
    NSSet *certSet = [NSSet setWithObject:caCert];
    AFSecurityPolicy *securityPolicy =
    [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate
                     withPinnedCertificates:certSet];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    
#if 0
    __weak typeof(self) weakSelf = self;
    [_httpSessionManager setSessionDidReceiveAuthenticationChallengeBlock:
     ^NSURLSessionAuthChallengeDisposition(NSURLSession *session,
                                           NSURLAuthenticationChallenge *challenge,
                                           NSURLCredential **_credential)
     {
         // 获取服务器的 trust object
         SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
         
         // 导入自签名证书
         NSData* caCert = [NSData dataWithContentsOfFile:self.cerFilePath];
         NSSet *certSet = [NSSet setWithObject:caCert];
         _httpSessionManager.securityPolicy.pinnedCertificates = certSet;
         
         SecCertificateRef caRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)caCert);
         NSCAssert(caRef != nil, @"caRef is nil");
         NSArray *caArray = @[(__bridge id)(caRef)];
         NSCAssert(caArray != nil, @"caArray is nil");
         
         OSStatus status = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)caArray);
         SecTrustSetAnchorCertificatesOnly(serverTrust,NO);
         NSCAssert(errSecSuccess == status, @"SecTrustSetAnchorCertificates failed");
         
         // 选择质询认证的处理方式
         NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
         __autoreleasing NSURLCredential *credential = nil;
         
         // NSURLAuthenticationMethodServerTrust质询认证方式
         if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
         {
             // 基于客户端的安全策略来决定是否信任该服务器，不信任则不响应质询
             if ([_httpSessionManager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust
                                                               forDomain:challenge.protectionSpace.host])
             {
                 // 创建质询证书
                 credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                 // 确认质询方式
                 if (credential)
                 {
                     disposition = NSURLSessionAuthChallengeUseCredential;
                 }
                 else
                 {
                     disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                 }
             }
             else
             {
                 //取消质询
                 disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
             }
         }
         else
         {
             disposition = NSURLSessionAuthChallengePerformDefaultHandling;
         }
         
         return disposition;
     }];
#endif
    
    return securityPolicy;
}


@end







































