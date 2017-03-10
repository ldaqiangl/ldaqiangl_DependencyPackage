//
//  DQEncryption.h
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/3.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/******（通过DES加密）先加密再base64******/
#define __DES_ENCODE(plaintext, secretkey) \
[DQEncryption DQEncrypWithDES:plaintext key:secretkey]

/******（通过DES解密）先base64再加密******/
#define __DES_DECODE(ciphertesxt, secretkey) \
[DQEncryption DQDecryptWithDES:ciphertesxt key:secretkey]


@interface DQEncryption : NSObject

    
#pragma mark - - DES+Base64
    
/**
 @author 大强
 
 @brief 将文本通过DES加密
 
 @param text 待加密的文本
 
 @return 加密后的文本
 */
+ (NSString *)DQEncrypWithDES:(NSString *)plaintext
                          key:(NSString *)key;
    
/**
 @author 大强
 
 @brief 将文本通过DES解密
 
 @param DES 待解密的文本
 
 @return 解密后的文本
 */
+ (NSString *)DQDecryptWithDES:(NSString *)ciphertext
                           key:(NSString *)key;
    
#pragma mark - - RSA
/**
 @author 大强
 
 @brief 初始化实例
 
 @param name 公钥名字
 
 @return 实例
 */
- (instancetype)initWithPublicKey:(NSString *)name;
    
/**
 @author 大强
 
 @brief 将文本通过RSA加密
 
 @param text 待加密的文本
 
 @return 加密后的文本
 */
- (NSString *)DQEncryptWithRSA:(NSString *)plaintext;
    
/**
 @author 大强
 
 @brief 将文本通过RSA解密
 
 @param ciphertesxt 待解密的文本
 
 @return 解密后的文本
 */
- (NSString *)DQDecryptWithRSA:(NSString *)ciphertext;

    
    

@end
