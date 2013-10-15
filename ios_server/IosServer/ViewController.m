//
//  ViewController.m
//  IosServer
//
//  Created by chengkai on 13-6-24.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

extern void start_server();

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_start_server:(id)sender {
    start_server();
}
@end
