//
//  DueDateViewController.m
//  MyToDoList
//
//  Created by Mike_Gazdich_rMBP on 12/10/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "DueDateViewController.h"
#import "AppDelegate.h"
#import "ToDoItemDetailViewController.h"

@interface DueDateViewController ()

@property (nonatomic, strong) NSMutableDictionary *toDo;
@property (nonatomic, strong) NSMutableArray *toDoItems;
@property (nonatomic, strong) NSString *itemTitle;

@property (nonatomic, strong) NSMutableArray *priorityArray;

@end

@implementation DueDateViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    // Obtain an object reference to the App Delegate object
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Set the local instance variable to the obj ref of the countryCities dictionary
    // data structure created in the App Delegate class
    self.toDo = appDelegate.toDo;
    
    // Obtain a sorted list of country names and store them in a mutable array
    NSMutableArray *sortedToDoItemNames = (NSMutableArray *)[[self.toDo allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    // Set the mutable sorted array to countries
    self.toDoItems = sortedToDoItemNames;
    
    // Instantiate the City Data object to pass to the downstream view controller
    self.priorityArray = [[NSMutableArray alloc] init];
    NSMutableArray *sortedDate;
    for (int i = 0; i < self.toDoItems.count;  i++) {
        NSString *select = [self.toDoItems objectAtIndex:i];
        [self.priorityArray addObject:[[self.toDo objectForKey:select] objectAtIndex:3]];
    }
    sortedDate = (NSMutableArray*)[self.priorityArray sortedArrayUsingSelector:@selector(compare:)];
    [self.priorityArray removeAllObjects];
    for (int j = 0; j < sortedDate.count;  j++) {
        NSString *selectDate = [sortedDate objectAtIndex:j];
//        [self.priorityArray addObject:[[self.toDo objectForKey:selectDate] objectAtIndex:3]];
        for (int i = 0; i < self.toDoItems.count;  i++) {
            NSString *timeToBe = [[self.toDo objectForKey:[self.toDoItems objectAtIndex:i]] objectAtIndex:3];
            if ([timeToBe isEqualToString:selectDate]) {
                [self.priorityArray addObject:[self.toDoItems objectAtIndex:i]];
            }
        }
    }
    
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.priorityArray removeAllObjects];
    NSMutableArray *sortedDate;
    for (int i = 0; i < self.toDoItems.count;  i++) {
        NSString *select = [self.toDoItems objectAtIndex:i];
        [self.priorityArray addObject:[[self.toDo objectForKey:select] objectAtIndex:3]];
    }
    sortedDate = (NSMutableArray*)[self.priorityArray sortedArrayUsingSelector:@selector(compare:)];
    [self.priorityArray removeAllObjects];
    for (int j = 0; j < sortedDate.count;  j++) {
        NSString *selectDate = [sortedDate objectAtIndex:j];
        //        [self.priorityArray addObject:[[self.toDo objectForKey:selectDate] objectAtIndex:3]];
        for (int i = 0; i < self.toDoItems.count;  i++) {
            NSString *timeToBe = [[self.toDo objectForKey:[self.toDoItems objectAtIndex:i]] objectAtIndex:3];
            if ([timeToBe isEqualToString:selectDate]) {
                [self.priorityArray addObject:[self.toDoItems objectAtIndex:i]];
            }
        }
    }
    [self.tableView reloadData];
    [super viewDidAppear:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.priorityArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toDoCell"];
    
    // Configure the cell
    NSUInteger rowNumber = [indexPath row];
    
    NSString *markedItem = [self.priorityArray objectAtIndex:rowNumber];
    NSMutableArray *markedItemArray = [self.toDo objectForKey:markedItem];
    
    /*
     Note that city names must not be sorted. The order shows how favorite the city is.
     The higher the order the more favorite the city is. The user specifies the ordering
     in the Edit mode by moving a row from one location to another for the same country.
     */
    if([[markedItemArray objectAtIndex:0] isEqualToString:@"YES"]){
        cell.imageView.image = [UIImage imageNamed:@"checkedBox"];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"checkBox"];
    }
    
    cell.textLabel.text = markedItem;
    cell.detailTextLabel.text = [markedItemArray objectAtIndex:3];
    NSString *textColor = [markedItemArray objectAtIndex:2];
    if ([textColor isEqualToString:@"High"]){
        cell.textLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    else if ([textColor isEqualToString:@"Normal"]) {
        cell.textLabel.textColor = [UIColor brownColor];
        cell.detailTextLabel.textColor = [UIColor brownColor];
        
    }
    else {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        
    }
    
    /*
     Set up a detail disclosure button to be displayed on the right side of each row.
     The button is handled in the method tableView: accessoryButtonTappedForRowWithIndexPath:
     */
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
#pragma mark - UITableViewDelegate Protocol Methods

// Tapping a row displays an alert panel informing the user for the selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedToDoItemName = [self.priorityArray objectAtIndex:[indexPath row]];
    self.itemTitle = selectedToDoItemName;
    
    // Perform the segue named trailer
    [self performSegueWithIdentifier:@"viewDetails" sender:self];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Preparing for Segue

// This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
// You never call this method. It is invoked by the system.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueIdentifier = [segue identifier];
    
    if ([segueIdentifier isEqualToString:@"viewDetails"]) {
        
        // Obtain the object reference of the destination view controller
        ToDoItemDetailViewController *itemDetailViewController = [segue destinationViewController];
        itemDetailViewController.item = self.itemTitle;
        itemDetailViewController.toDoItemArray = [self.toDo objectForKey:self.itemTitle];
        
    }
}

@end
