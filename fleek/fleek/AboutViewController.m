//
//  AboutViewController.m
//  fleek
//
//  Created by Dulio Denis on 2/20/15.
//  Copyright (c) 2015 ddApps. See included LICENSE file.
//

#import "AboutViewController.h"
#import "SWRevealViewController.h"

@interface AboutViewController () <SWRevealViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;
@property (weak, nonatomic) IBOutlet UILabel *buildLabel;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // The Menu Bar Button
    self.revealViewController.delegate = self;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.menuBarButton.target = self.revealViewController;
    self.menuBarButton.action = @selector(revealToggle:);
    
    // set the build number from the Info.plist string key_name "ddAppBuild"
    NSString *buildNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ddAppBuild"];
    self.buildLabel.text = buildNumber;
}

@end
