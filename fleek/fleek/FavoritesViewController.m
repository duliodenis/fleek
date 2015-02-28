//
//  FavoritesViewController.m
//  fleek
//
//  Created by Dulio Denis on 2/28/15.
//  Copyright (c) 2015 ddApps. See included LICENSE file.
//

#import <Parse/Parse.h>
#import "FavoritesViewController.h"
#import "FavoritesTableViewCell.h"

@interface FavoritesViewController () <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *favorites;
@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loadFavorites];
}

#pragma mark - Parse POI Update Methods
//TODO: Refactor into a Parse Utility Class - MapVC uses this too

- (void)loadFavorites {
    PFQuery *query = [PFQuery queryWithClassName:@"POI"];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"user" equalTo:user];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // put into mutable array - each element is an NSDictionary with name & subtitle
            NSMutableArray *favoritesFromParse = [NSMutableArray new];
            for (PFObject *favorite in objects) {
                NSMutableDictionary *favoriteElement = [[NSMutableDictionary alloc] init];
                [favoriteElement setObject:[favorite objectForKey:@"name"] forKey:@"name"];
                [favoriteElement setObject:[favorite objectForKey:@"subtitle"] forKey:@"subtitle"];
                [favoritesFromParse addObject:favoriteElement];
            }
            self.favorites = favoritesFromParse;
            [self.tableView reloadData];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favorites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    
    FavoritesTableViewCell *cell = (FavoritesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[FavoritesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.title.text = [NSString stringWithFormat:@"%@", [self.favorites[indexPath.row] valueForKey:@"name"]];
    cell.subtitle.text = [self.favorites[indexPath.row] valueForKey:@"subtitle"];
    
    cell.delegate = self;
    return cell;
}

@end
