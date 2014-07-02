//
//  TABEmployeesTableViewController.m
//  TAB_iOS
//
//  Created by Zachary BURGESS on 02/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

#import "TABEmployeesTableViewController.h"
#import "TABEmployeeTableViewCell.h"
#import "TABEmplyeeDataProvider.h"
#import "TABEmployee.h"


static NSString * const TABLogoImageName          = @"logo-orange";
static NSString * const TABEmployeeURLString      = @"http://www.theappbusiness.com/our-team/";

static CGFloat const TABHeaderImageWidth          = 80.0f;
static CGFloat const TABScreenWidth               = 320.0f;
static CGFloat const TABPaddingHight              = 20.0f;


@interface TABEmployeesTableViewController ()

@property (strong, nonatomic) NSArray * employees;

@property (strong, nonatomic) UIActivityIndicatorView *activity;

- (void)refreshList:(UIRefreshControl *)sender;

- (void)showErrorMessageWithError:(NSError*)paramError;

@end

@implementation TABEmployeesTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    UINib *nib = [UINib nibWithNibName:@"TABEmployeeTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:[TABEmployeeTableViewCell reuseIdentifier]];
    
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activity setFrame:CGRectMake(0, 0, 320.0f, [UIScreen mainScreen].bounds.size.height)];
    [self.activity setTintColor:[UIColor blackColor]];
    [self.activity setColor:[UIColor blackColor]];
    [self.view addSubview:self.activity];
    [self.activity startAnimating];
    
    // table header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                  0.0f,
                                                                  TABScreenWidth,
                                                                  (TABHeaderImageWidth + (TABPaddingHight * 2)))];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((TABScreenWidth/ 2) - (TABHeaderImageWidth / 2),
                                                                           TABPaddingHight,
                                                                           TABHeaderImageWidth,
                                                                           TABHeaderImageWidth)];
    [imageView setImage:[UIImage imageNamed:TABLogoImageName]];
    [headerView addSubview:imageView];
    self.tableView.tableHeaderView = headerView;
    
    [self.refreshControl addTarget:self action:@selector(refreshList:) forControlEvents:UIControlEventValueChanged];
    
    __weak typeof(self) weakSelf = self;
    [[TABEmplyeeDataProvider sharedInstance] getEmplyeesFromPage:TABEmployeeURLString
                                                 withCompleation:^(NSArray * arrayOfEmployees, NSError * error) {
                                                     if (error) {
                                                         [weakSelf showErrorMessageWithError:error];
                                                     }
                                                     else {
                                                         weakSelf.employees = arrayOfEmployees;
                                                         [weakSelf.tableView reloadData];
                                                         [weakSelf.activity stopAnimating];
                                                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                     }
                                                 }];
}

#pragma mark - private methods

- (void)refreshList:(UIRefreshControl *)sender {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)showErrorMessageWithError:(NSError*)paramError {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:paramError.localizedDescription
                                                     message:nil
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return self.employees.count; }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TABEmployee * employee = self.employees[indexPath.row];
    return [TABEmployeeTableViewCell cellHeightWithBioText:employee.miniBio];
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TABEmployeeTableViewCell *cell = (TABEmployeeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[TABEmployeeTableViewCell reuseIdentifier] forIndexPath:indexPath];
    [cell updateCellWithEmployee:self.employees[indexPath.row]];
    return cell;
}

@end
