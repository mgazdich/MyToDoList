//
//  ToDoItemDetailViewController.m
//  MyToDoList
//
//  Created by Mike_Gazdich_rMBP on 12/10/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "ToDoItemDetailViewController.h"

@interface ToDoItemDetailViewController ()
//@property (nonatomic, strong) NSMutableArray *toDoItemArray;
//@property (nonatomic, strong) NSString      *item;

@end

@implementation ToDoItemDetailViewController

- (void)viewDidLoad
{
    self.itemTitle.text = self.item;
    self.completed.text = [self.toDoItemArray objectAtIndex:0];
    self.details.text = [self.toDoItemArray objectAtIndex:1];
    self.priority.text = [self.toDoItemArray objectAtIndex:2];
    self.dueDate.text = [self.toDoItemArray objectAtIndex:3];
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
