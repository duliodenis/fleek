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
@property (nonatomic) NSString* nickname;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;

@end

@implementation NicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.revealViewController.delegate = self;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // PFQuery *query = [PFQuery queryWithClassName:@"User"];
    PFQuery *query = [PFUser query];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"objectId" equalTo:user.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count) {
                PFObject *user = [objects firstObject];
                self.nickname = [user objectForKey:@"nickname"];
                NSLog(@"User has the nickname: %@", self.nickname);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.nicknameTextField.text = self.nickname;
                });
                
            }
            else NSLog(@"User has no nickname");
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
    
}

- (IBAction)updateNickname:(id)sender {
    PFUser *user = [PFUser currentUser];
    self.nickname = self.nicknameTextField.text;
    [user setObject:self.nickname forKey:@"nickname"];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Updated nickname on Parse Successful.");
        } else {
            NSLog(@"Update nickname to Parse Failure.");
        }
    }];
    
}

@end
