//
//  ItemChangeViewController.h
//  MyToDoList
//
//  Created by Mike_Gazdich_rMBP on 12/10/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemChangeViewControllerDelegate;

@interface ItemChangeViewController : UIViewController

- (IBAction)backgroundTouch:(UIControl *)sender;
@property (nonatomic, strong) NSMutableArray *toDoItemArray;
@property (nonatomic, strong) NSString      *item;
@property (strong, nonatomic) IBOutlet UITextField *itemTitle;
@property (strong, nonatomic) IBOutlet UITextView *description;
@property (strong, nonatomic) IBOutlet UIDatePicker *dueDate;
@property (strong, nonatomic) IBOutlet UISegmentedControl *priority;
@property (strong, nonatomic) IBOutlet UISegmentedControl *completed;

@property (nonatomic, assign) id <ItemChangeViewControllerDelegate> delegate;

@end

/*
 The Protocol must be specified after the Interface specification is ended.
 Guidelines:
 - Create a protocol name as ClassNameDelegate as we did above.
 - Create a protocol method name starting with the name of the class defining the protocol.
 - Make the first method parameter to be the object reference of the caller as we did below.
 */
@protocol ItemChangeViewControllerDelegate

- (void)changeViewController:(ItemChangeViewController *)controller didFinishWithSave:(BOOL)save;

@end
