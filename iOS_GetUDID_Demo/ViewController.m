//
//  ViewController.m
//  iOS_GetUDID_Demo
//
//  Created by 黄云碧 on 2019/3/10.
//  Copyright © 2019 黄云碧. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)getUDID:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://127.0.0.1:6699/udid.get"]];

}

@end
