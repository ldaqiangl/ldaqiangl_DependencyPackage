//
//  DQEncryption.m
//  XZLDependencyPackage
//
//  Created by 董富强 on 2017/3/3.
//  Copyright © 2017年 daqiang@ldaqiangl.com. All rights reserved.
//

#import "DQEncryption.h"

#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

@implementation DQEncryption
{
    SecKeyRef publicKey;
    SecCertificateRef certificate;
    SecPolicyRef policy;
    SecTrustRef trust;
    size_t maxPlainLen;
}
    
#pragma mark - 初始化
- (id)initWithPublicKey:(NSString *)name {
    
    self = [super init];
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:name ofType:@"der"];
    
    if (publicKeyPath == nil)
    {
        NSLog(@"Can not find pub.der");
        return nil;
    }
    
    NSData *publicKeyFileContent = [NSData dataWithContentsOfFile:publicKeyPath];
    if (publicKeyFileContent == nil)
    {
        NSLog(@"Can not read from pub.der");
        return nil;
    }
    
    certificate = SecCertificateCreateWithData(kCFAllocatorDefault, ( __bridge CFDataRef)publicKeyFileContent);
    if (certificate == nil)
    {
        NSLog(@"Can not read certificate from pub.der");
        return nil;
    }
    
    policy = SecPolicyCreateBasicX509();
    OSStatus returnCode = SecTrustCreateWithCertificates(certificate, policy, &trust);
    if (returnCode != 0)
    {
        NSLog(@"SecTrustCreateWithCertificates fail. Error Code: %d", (int)returnCode);
        return nil;
    }
    
    SecTrustResultType trustResultType;
    returnCode = SecTrustEvaluate(trust, &trustResultType);
    if (returnCode != 0)
    {
        return nil;
    }
    
    publicKey = SecTrustCopyPublicKey(trust);
    if (publicKey == nil)
    {
        NSLog(@"SecTrustCopyPublicKey fail");
        return nil;
    }
    
    maxPlainLen = SecKeyGetBlockSize(publicKey) - 12;
    return self;
}
    
- (void)dealloc {
    
    CFRelease(certificate);
    CFRelease(trust);
    CFRelease(policy);
    CFRelease(publicKey);
}
    
#pragma mark - Public
    
#pragma DES
+ (NSString *)DQEncrypWithDES:(NSString *)plaintext key:(NSString *)key {
    
    NSData *data = [plaintext dataUsingEncoding:NSUTF8StringEncoding];
    data = [self DESEncrypt:data WithKey:key];
    NSString *result = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return result;
}
    
+ (NSString *)DQDecryptWithDES:(NSString *)ciphertext key:(NSString *)key {
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:ciphertext
                                                       options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self DESDecrypt:data
                    WithKey:key];
    NSString *result = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    
    return result;
}
    
#pragma RSA
+ (NSString *)DQEncryptWithRSA:(NSString *)plaintext {
    
    return [[[self alloc] init] DQEncryptWithRSA:plaintext];
}
    
+ (NSString *)DQDecryptWithRSA:(NSString *)ciphertext {
    
    return [[[self alloc] init] DQDecryptWithRSA:ciphertext];
}
    
#pragma mark - Private
/**
 *  @author 大强
 *
 *  @brief 文本数据进行DES加密
 *
 *  @param data NSData
 *  @param key  NSString
 *
 *  @return NSData
 *  @remark 此函数不可用于过长文本
 */
+ (NSData *)DESEncrypt:(NSData *)data
               WithKey:(NSString *)key {
    
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr
          maxLength:sizeof(keyPtr)
           encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeDES,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer
                                    length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}
    
/**
 *  @author 大强
 *
 *  @brief 文本数据进行DES解密
 *
 *  @param data NSData
 *  @param key  NSString
 *
 *  @return NSData
 *  @remark 此函数不可用于过长文本
 */
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key {
    
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr
          maxLength:sizeof(keyPtr)
           encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeDES,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer
                                    length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}
    
- (NSString *)DQEncryptWithRSA:(NSString *)plaintext {
    
    NSData *data = [plaintext dataUsingEncoding:NSUTF8StringEncoding];
    data = [self RSAEncrypt:data];
    NSString *result = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return result;
}
    
- (NSString *)DQDecryptWithRSA:(NSString *)ciphertext {
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:ciphertext
                                                       options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self RSADecrypt:data];
    NSString *result = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    
    return result;
}
    
- (NSData *)RSAEncrypt:(NSData *)data {
    
    size_t plainLen = [data length];
    if (plainLen > maxPlainLen) {
        NSLog(@"content(%ld) is too long, must < %ld", plainLen, maxPlainLen);
        return nil;
    }
    
    void *plain = malloc(plainLen);
    [data getBytes:plain
            length:plainLen];
    
    size_t cipherLen = 256; // 目前使用的RSA加密長度為2048bits(即256bytes)
    void *cipher = malloc(cipherLen);
    
    OSStatus returnCode = SecKeyEncrypt(publicKey,
                                        kSecPaddingPKCS1,
                                        plain,
                                        plainLen,
                                        cipher,
                                        &cipherLen);
    NSData *result = nil;
    if (returnCode != 0) {
        NSLog(@"SecKeyEncrypt fail. Error Code: %d", (int)returnCode);
    } else {
        result = [NSData dataWithBytes:cipher length:cipherLen];
    }
    
    free(plain);
    free(cipher);
    
    return result;
}
    
- (NSData *)RSADecrypt:(NSData *)data {
    
    size_t plainLen = [data length];
    if (plainLen > maxPlainLen) {
        NSLog(@"content(%ld) is too long, must < %ld", plainLen, maxPlainLen);
        return nil;
    }
    
    void *plain = malloc(plainLen);
    [data getBytes:plain
            length:plainLen];
    
    size_t cipherLen = 256; // 目前使用的RSA加密長度為2048bits(即256bytes)
    void *cipher = malloc(cipherLen);
    
    OSStatus returnCode = SecKeyDecrypt(publicKey,
                                        kSecPaddingPKCS1,
                                        plain,
                                        plainLen,
                                        cipher,
                                        &cipherLen);
    NSData *result = nil;
    if (returnCode != 0) {
        NSLog(@"SecKeyDncrypt fail. Error Code: %d", (int)returnCode);
    }
    else {
        result = [NSData dataWithBytes:cipher length:cipherLen];
    }
    
    free(plain);
    free(cipher);
    
    return result;
}

    

@end
