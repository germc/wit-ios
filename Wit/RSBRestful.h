//
//  RSBRestful.h
//  RSBRestful
//
//  Created by Rachel Brindle on 12/16/11.
//  Copyright (c) 2011 Rachel Brindle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSBRestful : NSObject <NSURLConnectionDelegate>
{
    NSMutableURLRequest *r;
    NSURLConnection *uc;
    NSMutableData *rcvd;
}

@property (nonatomic, strong) void (^onError)(NSError *);
@property (nonatomic, strong) void (^onSuccess)(NSData *);

-(id)initWithURL:(NSURL *)url method:(NSString *)method;
-(void)addHeaderFields:(NSDictionary *)headers;
-(void)addHTTPBody:(NSString *)str;
-(void)startConnection;


@end
