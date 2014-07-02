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

@interface TABEmployeesTableViewController ()

@property (copy, nonatomic) NSArray * employees;

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
    
    // table header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 120.0f)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((320.0f/ 2)-(80.0f / 2), 20.0f, 80.0f, 80.0f)];
    [imageView setImage:[UIImage imageNamed: @"logo-orange"]];
    [headerView addSubview:imageView];
    self.tableView.tableHeaderView = headerView;
    
    
    UIImageView *refreshImageView = [[UIImageView alloc] initWithFrame:CGRectMake((320.0f/ 2)-(80.0f / 2), 20.0f, 80.0f, 80.0f)];
    [refreshImageView setImage:[UIImage imageNamed: @"logo-orange"]];
    [self.refreshControl insertSubview:refreshImageView atIndex:0];
    [self.refreshControl addTarget:self action:@selector(changeSorting:) forControlEvents:UIControlEventValueChanged];
    
    __weak typeof(self) weakSelf = self;
    [[TABEmplyeeDataProvider sharedInstance] getEmplyeesFromPage:@"http://www.theappbusiness.com/our-team/"
                                                 withCompleation:^(NSArray * arrayOfEmployees, NSError * error) {
                                                     if (error) {
                                                         [weakSelf showErrorMessageWithError:error];
                                                     }
                                                     else {
                                                         weakSelf.employees = arrayOfEmployees;
                                                         [weakSelf.tableView reloadData];
                                                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                     }
                                                 }];
}

- (void)changeSorting:(id)sender {
    NSLog(@"changing");
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return self.employees.count; }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TABEmployee * employee = self.employees[indexPath.row];
    NSLog(@"%@ row hight: %f being calculated, for row: %d",employee.name,[TABEmployeeTableViewCell cellHeightWithBioText:employee.miniBio],indexPath.row);
    return [TABEmployeeTableViewCell cellHeightWithBioText:employee.miniBio];
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TABEmployeeTableViewCell *cell = (TABEmployeeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[TABEmployeeTableViewCell reuseIdentifier] forIndexPath:indexPath];

    [cell setEmployee:self.employees[indexPath.row]];
    
    return cell;
}

- (void)showErrorMessageWithError:(NSError*)paramError {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:paramError.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
