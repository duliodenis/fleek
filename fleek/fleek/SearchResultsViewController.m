//
//  SearchResultsViewController.m
//  fleek
//
//  Created by Dulio Denis on 1/29/15.
//  Copyright (c) 2015 ddApps. All rights reserved.
//

#import "SearchResultsViewController.h"

@interface SearchResultsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SearchResultsViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSLog (@"In ViewWillAppear searchResults count = %lu", (unsigned long)self.searchResults.count);
    [self.tableView reloadData];
}


- (void)setSearchResults:(NSMutableArray *)searchResults {
    _searchResults = searchResults;
}


#pragma mark - UITableViewDataSource Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.searchResults[indexPath.row];
    return cell;
}


- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"In viewWillDisappear searchResult count = %lu", (unsigned long)self.searchResults.count);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

@end
