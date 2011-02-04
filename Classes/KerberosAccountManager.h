//
//  KerberosAccountManager.h
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/25/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KeychainItemWrapper.h"

@interface KerberosAccountManager : NSObject {
    KeychainItemWrapper * itemWrapper;
    
    NSDictionary * _itemWrappers;
}

@property (nonatomic, retain) KeychainItemWrapper * itemWrapper;

@property(nonatomic, retain) NSDictionary * itemWrappers;

@property(nonatomic, assign) NSString * username;
@property(nonatomic, assign) NSString * password;
@property(nonatomic, assign) NSString * sourceURL;

+ (KerberosAccountManager *)defaultManager;

@end
