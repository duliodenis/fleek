//
//  NicknameViewController.m
//  fleek
//
//  Created by Dulio Denis on 2/18/15.
//  Copyright (c) 2015 ddApps. All rights reserved.
//

#import <Parse/Parse.h>
#import "NicknameViewController.h"
#import "SWRevealViewController.h"

@interface NicknameViewController () <SWRevealViewControllerDelegate>

@end

@implementation NicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.revealViewController.delegate = self;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
}

@end
