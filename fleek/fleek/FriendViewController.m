//
//  FriendViewController.m
//  fleek
//
//  Created by Dulio Denis on 2/20/15.
//  Copyright (c) 2015 ddApps. See included LICENSE file.
//

#import "FriendViewController.h"
#import "SWRevealViewController.h"

@interface FriendViewController () <SWRevealViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;
@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // The Menu Bar Button
    self.revealViewController.delegate = self;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.menuBarButton.target = self.revealViewController;
    self.menuBarButton.action = @selector(revealToggle:);
}

@end
