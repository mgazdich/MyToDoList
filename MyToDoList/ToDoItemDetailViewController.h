//
//  ToDoItemDetailViewController.h
//  MyToDoList
//
//  Created by Mike_Gazdich_rMBP on 12/10/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToDoItemDetailViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *toDoItemArray;
@property (nonatomic, strong) NSString      *item;
@property (strong, nonatomic) IBOutlet UILabel *itemTitle;
@property (strong, nonatomic) IBOutlet UITextView *details;
@property (strong, nonatomic) IBOutlet UILabel *dueDate;
@property (strong, nonatomic) IBOutlet UILabel *priority;
@property (strong, nonatomic) IBOutlet UILabel *completed;
@end
