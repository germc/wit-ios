//
//  RSBRestful.m
//  RSBRestful
//
//  Created by Rachel Brindle on 12/16/11.
//  Copyright (c) 2011 Rachel Brindle. All rights reserved.
//

#import "RSBRestful.h"

@implementation RSBRestful

-(id)initWithURL:(NSURL *)url method:(NSString *)method
{
    if ((self = [super init]) != nil) {
        r = [[NSMutableURLRequest alloc] initWithURL:url];
        method = [method uppercaseString];
#ifndef RSB_OVERRIDE_METHOD_CHECK
        NSAssert([method isEqualToString:@"OPTIONS"] | [method isEqualToString:@"GET"] | 
                 [method isEqualToString:@"HEAD"] | [method isEqualToString:@"POST"] |
                 [method isEqualToString:@"PUT"] | [method isEqualToString:@"DELETE"] |
                 [method isEqualToString:@"TRACE"] | [method isEqualToString:@"CONNECT"],
                 @"Method is not a valid HTTP/1.1 method.");
        // RFC compliance. As the ifdefs note, this can be overrided if desired. (though not recommended.)
        // E.G. Siri uses a non-standard http method for its communication.
#endif /* ST_OVERIDE_METHOD_CHECK */
        [r setHTTPMethod:method];
        if ([method isEqualToString:@"PUT"]) {
            [r setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            // some weird foundation bug happens where, if you try a PUT without above line, it doesn't send.
            // This should get fixed, I hate having voodoo code.
        }
    }
    return self;
}

-(void)addHeaderFields:(NSDictionary *)headers
{
    for (NSString *key in headers.allKeys) {
        [r setValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
}

-(void)addHTTPBody:(NSString *)str
{
    [r setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void)startConnection
{
    NSAssert(r != nil, @"request was nil.");
    uc = [[NSURLConnection alloc] initWithRequest:r delegate:self];
    if (uc) {
        [uc start];
    } else {
        NSLog(@"Error connecting to server...");
        //STRestfulAlertView *av = [[STRestfulAlertView alloc] init];
        //[av show];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _onError(error);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (!rcvd) {
        rcvd = [[NSMutableData alloc] init];
    }
    [rcvd setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [rcvd appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_onSuccess != nil)
        _onSuccess(rcvd);
    // you can do whatever you want with the data.
    // If you're getting JSON data back, I recommend (and use) the SBJson stuff.
    // It's free/open source, which is cool.
    // available here: https://github.com/stig/json-framework/
}

-(id)init
{
    NSAssert(NO, @"Don't call init with RSBRestful. Use initWithURL.");
    return nil;
}

@end
