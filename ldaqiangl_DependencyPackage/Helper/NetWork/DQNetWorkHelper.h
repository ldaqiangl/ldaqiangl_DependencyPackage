//
//  DQNetWorkHelper.h
//  daqiangTest
//
//  Created by 董富强 on 2017/3/7.
//  Copyright © 2017年 董富强. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DQNetWork [DQNetWorkHelper sharedNetWorkHelper]

/** Http请求方法 */
typedef NS_ENUM(NSInteger, DQHttpMethodType)
{
    eHttpMethodTypeGET = 0,         // GET
    eHttpMethodTypePOST = 1,        // POST
    eHttpMethodTypePUT = 2,         // PUT
    eHttpMethodTypeDELETE = 3,      // DELETE
};

/** 网络类型 */
typedef NS_ENUM(NSInteger, DQNetworkStatus)
{
    eNetworkStatusUnkonw = -1,       // 未知
    eNetworkStatusNone = 0,          // 无
    eNetworkStatusMobile = 1,        // 移动网络
    eNetworkStatusWIFI = 2,          // WIFI
};


//定义block回调
/** 成功回调Block */
typedef void (^successBlock)(id responseObject);
/** 失败回调Block */
typedef void (^failureBlock)(NSHTTPURLResponse *httpResponse, NSError *error);
/** 重定向回调Block*/
typedef NSURLRequest *(^DQURLSessionTaskWillPerformHTTPRedirectionBlock)
(NSURLSession *session,NSURLSessionTask *task,NSURLResponse *response,NSURLRequest *request);
/** 接收到数据回调Block */
typedef void (^DQURLSessionDataTaskDidReceiveDataBlock)
(NSURLSession *session,NSURLSessionDataTask *dataTask,NSData *data);
/** 接收到响应回调Block*/
typedef NSURLSessionResponseDisposition (^DQURLSessionDataTaskDidReceiveResponseBlock)
(NSURLSession *session,NSURLSessionDataTask *dataTask,NSURLResponse *response);
/** 请求成功回调Block */
typedef void (^DQURLSessionTaskDidCompleteBlock)
(NSURLSession *session,NSURLSessionTask *task,NSError *error);


@interface DQNetWorkHelper : NSObject

/** 是否启用 https，默认 NO:不开启 */
@property (nonatomic, assign, getter = isUsingHttps) BOOL usingHttps;
/** cer 路径，默认取 Bundle 下的 certificate.cer */
@property (nonatomic, copy) NSString *cerFilePath;
/** 请求超时时间 单位：秒 默认：60秒 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
/** 自定义 headers */
@property (nonatomic, strong) NSArray<NSDictionary *> *customRequestHeader;


@property (readwrite, nonatomic, copy) DQURLSessionTaskWillPerformHTTPRedirectionBlock taskWillPerformHTTPRedirection;
@property (readwrite, nonatomic, copy) DQURLSessionDataTaskDidReceiveDataBlock dataTaskDidReceiveData;
@property (readwrite, nonatomic, copy) DQURLSessionDataTaskDidReceiveResponseBlock dataTaskDidReceiveResponse;
@property (readwrite, nonatomic, copy) DQURLSessionTaskDidCompleteBlock taskDidComplete;


/**
 @author daqiang
 @brief 单例
 
 @return DQNetWorkHelper
 */
+ (instancetype)sharedNetWorkHelper;


#pragma mark - AFHTTPSessionManager
/**
 @author daqiang
 
 @brief 网络请求
 
 @param httpMethod HttpMethod
 @param urlString 请求地址
 @param params    请求参数
 @param success   请求成功回调
 @param failure    请求失败回调
 */
- (void)requestWithHttpMethod:(DQHttpMethodType)httpMethod
                          url:(NSString *)urlString
                       params:(NSDictionary *)params
                      success:(successBlock)success
                      failure:(failureBlock)failure;

/**
 @author daqiang
 
 @brief a multipart POST
 
 @param urlString 请求地址
 @param params    请求参数
 @param data      要发送的二进制文件
 @param name      请求参数中二进制文件的名字
 @param mimeType  告诉服务器上传文件的类型
 @param success   请求成功回调
 @param failure   请求失败回调
 */
- (void)POST:(NSString *)urlString
      params:(NSDictionary *)params
        data:(NSData *)data
        name:(NSString *)name
    mimeType:(NSString *)mimeType
     success:(successBlock)success
     failure:(failureBlock)failure;

/**
 @author daqiang
 
 @brief HEAD
 
 @param urlString 请求地址
 @param params    请求参数
 @param success   请求成功回调
 @param failure    请求失败回调
 */
- (void)HEAD:(NSString *)urlString
      params:(NSDictionary *)params
     success:(successBlock)success
     failure:(failureBlock)failure;

/**
 @author daqiang
 
 @brief PATCH
 
 @param urlString 请求地址
 @param params    请求参数
 @param success   请求成功回调
 @param failure    请求失败回调
 */
- (void)PATCH:(NSString *)urlString
       params:(NSDictionary *)params
      success:(successBlock)success
      failure:(failureBlock)failure;

#pragma mark - AFURLSessionManager
/**
 @author daqiang
 
 @brief DataTask
 
 @param request 请求
 @param isSync  同步
 @param success 请求成功回调
 @param failure 请求失败回调
 */
- (void)dataTaskRequest:(NSURLRequest *)request
                   sync:(BOOL)isSync
                success:(successBlock)success
                failure:(failureBlock)failure;

/**
 @author daqiang
 
 @brief DataTask
 
 @param request               请求
 @param isSycn                是否同步
 @param uploadProgressBlock   上传进度
 @param downloadProgressBlock 下载进度
 @param success               请求成功回调
 @param failure               请求失败回调
 */
- (void)dataTaskRequest:(NSURLRequest *)request
                   sync:(BOOL)isSycn
         uploadProgress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock
       downloadProgress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
                success:(successBlock)success
                failure:(failureBlock)failure;

/**
 @author daqiang
 
 @brief UploadTask(FileUrl)
 
 @param request        请求
 @param fileUrl        NSURL
 @param uploadProgressBlock NSProgress
 @param success        请求成功回调
 @param failure        请求失败回调
 */
- (void)uploadTaskRequest:(NSURLRequest *)request
                 fromFile:(NSURL *)fileUrl
                 progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock
                  success:(successBlock)success
                  failure:(failureBlock)failure;

/**
 @author daqiang
 
 @brief UploadTask(BodyData)
 
 @param request             请求
 @param bodyData            NSData
 @param uploadProgressBlock 上传进度
 @param success             请求成功回调
 @param failure             请求失败回调
 */
- (void)uploadTaskRequest:(NSURLRequest *)request
                 fromData:(NSData *)bodyData
                 progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock
                  success:(successBlock)success
                  failure:(failureBlock)failure;

/**
 @author daqiang
 
 @brief uploadTask
 
 @param request             请求
 @param uploadProgressBlock 上传进度
 @param success             请求成功回调
 @param failure             请求失败回调
 */
- (void)uploadTaskRequest:(NSURLRequest *)request
                 progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock
                  success:(successBlock)success
                  failure:(failureBlock)failure;

/**
 @author daqiang
 
 @brief downloadTask
 
 @param request               请求
 @param downloadProgressBlock 下载进度
 @param success               请求成功回调
 @param failure               请求失败回调
 */
- (void)downloadTaskRequest:(NSURLRequest *)request
                   progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
                    success:(successBlock)success
                    failure:(failureBlock)failure;

#pragma mark - AFNetworkReachabilityManager
/**
 @author daqiang
 
 @brief 监测当前网络状态是否可用
 
 @param success 请求成功回调
 */
- (void)isReachable:(void (^)(bool isReachable))success;

/**
 @author daqiang
 
 @brief 检测网络连接状态
 
 @param success 请求成功回调
 */
- (void)reachabilityStatus:(void (^)(DQNetworkStatus status))success;

#pragma mark - Other
/**
 @author daqiang
 
 @brief 判断是否是标准的 URL 地址
 
 @return BOOL
 */
- (BOOL)isValidateURL:(NSString *)url;

/**
 @author daqiang
 
 @brief 暂停所有请求任务
 */
- (void)pauseAllRequestTask;

/**
 @author daqiang
 
 @brief 恢复所有请求任务
 */
- (void)resumeAllRequestTask;

/**
 @author daqiang
 
 @brief 设置网络请求拦截类
 
 @param customUrlProtocol NSURLProtocol
 */
- (void)setURLProtocol:(Class)customUrlProtocol;



@end
























