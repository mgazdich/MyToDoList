//
//  ToDoListViewController.m
//  MyToDoList
//
//  Created by Mike_Gazdich_rMBP on 12/10/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "ToDoListViewController.h"
#import "AppDelegate.h"
#import "ToDoItemDetailViewController.h"

@interface ToDoListViewController ()

@property (nonatomic, strong) NSMutableDictionary *toDo;
@property (nonatomic, strong) NSMutableArray *toDoItems;
@property (nonatomic, strong) NSString *itemTitle;

// cityData is the data object to be passed to the downstream view controller
@property (nonatomic, strong) NSMutableArray *toDoSingleItemArray;

// This method is invoked when the user taps the Add button created at run time.
- (void)addToDoItem:(id)sender;

@end

@implementation ToDoListViewController

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
    
    // You can set the navigation bar's title either here or in the storyboard
    // self.title = @"My Favorite Cities";
    
    // Set up the Edit system button on the left of the navigation bar
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    /*
     editButtonItem is provided by the system with its own functionality. Tapping it triggers editing by
     displaying the red minus sign icon on all rows. Tapping the minus sign displays the Delete button.
     The Delete button is handled in the method tableView: commitEditingStyle: forRowAtIndexPath:
     */
    
    // Instantiate an Add button (with plus sign icon) to invoke the addCity: method when tapped.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self action:@selector(addToDoItem:)];
    
    // Set up the Add custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = addButton;
    
    // Obtain a sorted list of country names and store them in a mutable array
    NSMutableArray *sortedToDoItemNames = (NSMutableArray *)[[self.toDo allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    // Set the mutable sorted array to countries
    self.toDoItems = sortedToDoItemNames;
    
    // Instantiate the City Data object to pass to the downstream view controller
    self.toDoSingleItemArray = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
}

#pragma mark - Add ToDo Item Method

// The addCity: method is invoked when the user taps the Add button created at run time.
- (void)addToDoItem:(id)sender
{
    // Perform the segue named AddCity
    [self performSegueWithIdentifier:@"addItem" sender:self];
}

#pragma mark - ChangeItemViewControllerDelegate Protocol Method

/*
 This is the AddCityViewController's delegate method we created. AddCityViewController informs
 the delegate CityViewController that the user tapped the Save button if the parameter is YES.
 */
- (void)changeViewController:(ItemChangeViewController *)controller didFinishWithSave:(BOOL)save
{
    if (save) {
        // Get the country name entered by the user on the AddCityViewController's UI
        if ([controller.title isEqualToString:@"Add"]) {
            [self.toDo setValue:controller.toDoItemArray forKey:controller.item];

        }
        else {
            [self.toDo removeObjectForKey:self.itemTitle];
            [self.toDo setValue:controller.toDoItemArray forKey:controller.item];
        }
        
    
        // Obtain a sorted list of country names and store them in a mutable array
        NSMutableArray *sortedToDOItems = (NSMutableArray *)[[self.toDo allKeys]
                                                                sortedArrayUsingSelector:@selector(compare:)];
        
        self.toDoItems = sortedToDOItems;  // Set the mutable sorted array to countries
        
        // Reload the rows and sections of the Table View countryCityTableView
        [self.tableView reloadData];
    }
    
    /*
     Pop the current view controller AddCityViewController from the stack
     and show the next view controller in the stack, which is ViewController.
     */
    [self.navigationController popViewControllerAnimated:YES];
}

//#pragma mark - AddItemViewControllerDelegate Protocol Method
//
///*
// This is the AddCityViewController's delegate method we created. AddCityViewController informs
// the delegate CityViewController that the user tapped the Save button if the parameter is YES.
// */
//- (void)addViewController:(AddItemViewController *)controller didFinishWithSave:(BOOL)save
//{
//    if (save) {
//        // Get the country name entered by the user on the AddCityViewController's UI
//        
//        [self.toDo removeObjectForKey:self.itemTitle];
//        [self.toDo setValue:controller.toDoItemArray forKey:controller.item];
//        
//        // Obtain a sorted list of country names and store them in a mutable array
//        NSMutableArray *sortedToDOItems = (NSMutableArray *)[[self.toDo allKeys]
//                                                             sortedArrayUsingSelector:@selector(compare:)];
//        
//        self.toDoItems = sortedToDOItems;  // Set the mutable sorted array to countries
//        
//        // Reload the rows and sections of the Table View countryCityTableView
//        [self.tableView reloadData];
//    }
//    
//    /*
//     Pop the current view controller AddCityViewController from the stack
//     and show the next view controller in the stack, which is ViewController.
//     */
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark - UITableViewDataSource Protocol Methods

/*
 We are implementing a Grouped table view style. In the storyboard file,
 select the Table View. Under the Attributes Inspector, set the Style attribute to Grouped.
 */

// Each table view section corresponds to a country
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// Number of items is the number of rows in the given
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.toDoItems count];
}

// Customize the appearance of the table view cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toDoCell"];
    
    // Configure the cell
    NSUInteger rowNumber = [indexPath row];
    
    NSString *markedItem = [self.toDoItems objectAtIndex:rowNumber];
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
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    return cell;
}


// We allow each row (city) of the table view to be editable, i.e., deletable or movable
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


// This is the method invoked when the user taps the Delete button in the Edit mode
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {  // Handle the Delete action
        
        NSString *itemToDelete = [self.toDoItems objectAtIndex:[indexPath row]];
        
        [self.toDo removeObjectForKey:itemToDelete];  // Remove the city marked for delete
        self.toDoItems = (NSMutableArray *)[[self.toDo allKeys] sortedArrayUsingSelector:@selector(compare:)];

        
        // Reload the rows and sections of the Table View countryCityTableView
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate Protocol Methods

// Tapping a row displays an alert panel informing the user for the selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedToDoItemName = [self.toDoItems objectAtIndex:[indexPath row]];
    self.itemTitle = selectedToDoItemName;
    self.toDoSingleItemArray = [self.toDo objectForKey:selectedToDoItemName];
    
    // Perform the segue named trailer
    [self performSegueWithIdentifier:@"viewDetails" sender:self];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedToDoItemName = [self.toDoItems objectAtIndex:[indexPath row]];
    self.itemTitle = selectedToDoItemName;
    self.toDoSingleItemArray = [self.toDo objectForKey:selectedToDoItemName];
    
    // Perform the segue named trailer
    [self performSegueWithIdentifier:@"accessoryButton" sender:self];
    
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
        itemDetailViewController.toDoItemArray = self.toDoSingleItemArray;

    } else if ([segueIdentifier isEqualToString:@"accessoryButton"]) {
        
        // Obtain the object reference of the destination view controller
        ItemChangeViewController *itemChangeViewController = [segue destinationViewController];
        
        // Pass the cityData array obj ref to downstream CityMapViewController
        itemChangeViewController.title = @"Change";
        itemChangeViewController.item= self.itemTitle;
        itemChangeViewController.toDoItemArray = self.toDoSingleItemArray;
        itemChangeViewController.delegate = self;
    }
    else if ([segueIdentifier isEqualToString:@"addItem"]) {

        // Obtain the object reference of the destination view controller
        ItemChangeViewController *addItemViewController = [segue destinationViewController];
        
        addItemViewController.title = @"Add";
        // Pass the cityData array obj ref to downstream CityMapViewController
        addItemViewController.item= self.itemTitle;
        addItemViewController.toDoItemArray = self.toDoSingleItemArray;
        addItemViewController.delegate = self;
    }
}


@end
