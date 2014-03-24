//
//  TableViewController.h
//  MalariaScreening
//
//  Created by Puk on 3/21/14.
//  Copyright (c) 2014 Decha Tesapirat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>{
    
	IBOutlet UITableView *tableView;
	NSMutableArray *dataList;
}

- (IBAction) Edit:(id)sender;

@property (nonatomic, strong) NSArray *Title;
@property (nonatomic, strong) NSArray *Description;

@end
