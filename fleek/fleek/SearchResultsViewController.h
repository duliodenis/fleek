//
//  SearchResultsViewController.h
//  fleek
//
//  Created by Dulio Denis on 1/29/15.
//  Copyright (c) 2015 ddApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsViewController : UIViewController

@property (nonatomic) NSMutableArray *searchResults;
- (void)setSearchResults:(NSMutableArray *)searchResults;
@end
