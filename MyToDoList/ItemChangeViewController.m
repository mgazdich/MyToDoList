//
//  ItemChangeViewController.m
//  MyToDoList
//
//  Created by Mike_Gazdich_rMBP on 12/10/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "ItemChangeViewController.h"
#import "ToDoListViewController.h"

@interface ItemChangeViewController ()

@end

@implementation ItemChangeViewController

- (void)viewDidLoad
{
    if ( [self.title isEqualToString:@"Add"]){
        self.description.text = @"add some toDO item.";
    }
    else{
    self.itemTitle.text = self.item;
    NSString *complete = [self.toDoItemArray objectAtIndex:0];
    if ([complete isEqualToString:@"YES"]) {
        [self.completed setSelectedSegmentIndex:0];
    }
    else {
        [self.completed setSelectedSegmentIndex:1];
    }
    
    self.description.text = [self.toDoItemArray objectAtIndex:1];
    NSString *priorityStr = [self.toDoItemArray objectAtIndex:2];
    if ([priorityStr isEqualToString:@"Low"]) {
        [self.priority setSelectedSegmentIndex:0];
    }
    else if ([priorityStr isEqualToString:@"Normal"]){
        [self.priority setSelectedSegmentIndex:1];
    }
    else {
        [self.priority setSelectedSegmentIndex:2];
    }
    
    NSString *dueDate = [self.toDoItemArray objectAtIndex:3];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    NSDate *date = [dateFormatter dateFromString:dueDate];
    [self.dueDate setDate:date animated:YES];
    }
    
    // Instantiate a Save button to invoke the save: method when tapped
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self action:@selector(save:)];
    // Set up the Save custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = saveButton;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - save selector

- (void)save:(id)sender
{
    if ([self.itemTitle.text isEqualToString:@""] || [self.description.text isEqualToString:@""] || [self.priority selectedSegmentIndex] == -1 || [self.completed selectedSegmentIndex] == -1){
        // Create the Alert View
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fill all textboxes"
                                                        message:@"No text is entered in any of the two text fields"
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        // Inform the delegate that the user tapped the Save button
        
        self.item = self.itemTitle.text;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
        NSDate *date = [self.dueDate date];
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        NSString *prior = [self.priority titleForSegmentAtIndex:self.priority.selectedSegmentIndex];
        NSString *complete = [self.completed titleForSegmentAtIndex:self.completed.selectedSegmentIndex];

        NSMutableArray *itemValues = [[NSMutableArray alloc] initWithObjects:complete, self.description.text, prior,formattedDateString, nil];
        self.toDoItemArray = itemValues;
        
        [self.delegate changeViewController:self didFinishWithSave:YES];
    }
}

#pragma mark - Custom Methods

// This method is invoked when the user taps Done on the keyboard
- (IBAction)keyboardDone:(id)sender
{
    // Deactivate the UITextField object and remove the Keyboard
    [sender resignFirstResponder];
}
- (IBAction)backgroundTouch:(UIControl *)sender {
    // Deactivate the UITextField object and remove the Keyboard
    [self.itemTitle resignFirstResponder];
    [self.description resignFirstResponder];
}


@end
