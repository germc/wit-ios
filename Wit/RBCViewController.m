//
//  RBCViewController.m
//  Wit
//
//  Created by Rachel Brindle on 9/12/13.
//  Copyright (c) 2013 Rachel Brindle. All rights reserved.
//

#import "RBCViewController.h"

@interface RBCViewController ()

@end

@implementation RBCViewController

-(id)init
{
    if ((self = [super init])) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Wit";
    
    tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 74, self.view.frame.size.width - 20, 40)];
    tf.borderStyle = UITextBorderStyleBezel;
    tf.delegate = self;
    tf.clearsOnBeginEditing = YES;
    tf.returnKeyType = UIReturnKeyGo;
    
    tv = [[UITextView alloc] initWithFrame:CGRectMake(0, 114, self.view.frame.size.width, self.view.frame.size.height - 114)];
    tv.editable = YES;
    [self.view addSubview:tf];
    [self.view addSubview:tv];
    
    wit = [[WITManager alloc] init];
    wit.delegate = self;
    NSString *accessKey = [[NSBundle mainBundle] pathForResource:@"accessKey" ofType:@"secret"];
    wit.accessKey = [[[NSString alloc] initWithContentsOfFile:accessKey encoding:NSUTF8StringEncoding error:nil] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    NSString *text = [textField text];
    [wit message:text];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

#pragma mark - WITDelegate

-(void)messageFailed:(NSError *)error
{
    [tv setText:[error description]];
}

-(void)messageResponse:(NSDictionary *)response
{
    [tv setText:[response description]];
}


@end
