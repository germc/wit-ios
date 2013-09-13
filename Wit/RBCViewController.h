//
//  RBCViewController.h
//  Wit
//
//  Created by Rachel Brindle on 9/12/13.
//  Copyright (c) 2013 Rachel Brindle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WITAI.h"

@interface RBCViewController : UIViewController <UITextFieldDelegate, WITDelegate>
{
    WITManager *wit;
    UITextField *tf;
    UITextView *tv;
}

@end
