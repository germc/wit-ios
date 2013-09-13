//
//  WITAI.h
//
//  Created by Rachel Brindle on 9/12/13.
//  Copyright (c) 2013 Rachel Brindle. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WITDelegate <NSObject>

-(void)messageResponse:(NSDictionary *)response;
-(void)messageFailed:(NSError *)error;

@end

@interface WITManager : NSObject

@property (nonatomic, strong) NSString *accessKey;
@property (nonatomic, weak) id<WITDelegate> delegate;

-(void)message:(NSString *)content;

@end
