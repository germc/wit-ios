//
//  RSBWit.m
//  Wit-OSX
//
//  Created by Rachel Brindle on 9/12/13.
//  Copyright (c) 2013 Rachel Brindle. All rights reserved.
//

#import "WITAI.h"

#import "RSBRestful.h"

@interface WITManager ()
{
    NSString *baseURL;
    NSDictionary *methods;
    
    NSMutableDictionary *rfs;
}

@end

@implementation WITManager

-(id)init
{
    if (([super init])) {
        baseURL = @"https://api.wit.ai/";
        rfs = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(NSString *)encodeForURL:(NSString *)str
{
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) str,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                                    kCFStringEncodingUTF8));
    
    return escapedString;
}

-(void)message:(NSString *)content
{
    NSString *url = [baseURL stringByAppendingString:[@"message?q=" stringByAppendingString:[self encodeForURL:content]]];
    RSBRestful *rf = [[RSBRestful alloc] initWithURL:[NSURL URLWithString:url] method:@"GET"];
    [rf addHeaderFields:@{@"Authorization": [@"Bearer " stringByAppendingString:_accessKey]}];
    // fuck it. Produces less problems.
    NSNumber *k = @1;
    for (NSNumber *i in rfs) {
        if ([i isEqual:k]) {
            k = @([k integerValue] + 1);
        }
    }
    [rf setOnSuccess:^(NSData *data){
        NSError *err;
        NSDictionary *foo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&err];
        if (!foo)
            [_delegate messageFailed:err];
        else
            [_delegate messageResponse:foo];
        [rfs removeObjectForKey:k];
    }];
    [rf setOnError:^(NSError *error){
        [_delegate messageFailed:error];
        [rfs removeObjectForKey:k];
    }];
    [rfs setObject:rf forKey:k];
    [rf startConnection];
}

@end
