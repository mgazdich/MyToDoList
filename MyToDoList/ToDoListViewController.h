//
//  ToDoListViewController.h
//  MyToDoList
//
//  Created by Mike_Gazdich_rMBP on 12/10/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemChangeViewController.h"
#import "AppDelegate.h"

@interface ToDoListViewController : UITableViewController <ItemChangeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
