//
//  AESGcm.h
//  Monal
//
//  Created by Anurodh Pokharel on 4/19/19.
//  Copyright © 2019 Monal.im. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <monalxmpp/MLEncryptedPayload.h>

NS_ASSUME_NONNULL_BEGIN

@interface AESGcm : NSObject
/**
 key size should be 16 or 32
 */
+ (MLEncryptedPayload *) encrypt:(NSData *)body keySize:(int) keySize;
+ (NSData *) decrypt:(NSData *)body withKey:(NSData *) key andIv:(NSData *)iv withAuth:(NSData * _Nullable )  auth;

@end

NS_ASSUME_NONNULL_END
