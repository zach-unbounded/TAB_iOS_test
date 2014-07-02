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
        [self.tableView registerClass:[TABEmployeeTableViewCell class] forCellReuseIdentifier:[TABEmployeeTableViewCell reuseIdentifier]];
        [self.tableView registerNib:[UINib nibWithNibName:@"TABEmployeeTableViewCell" bundle:nil] forCellReuseIdentifier:[TABEmployeeTableViewCell reuseIdentifier]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return self.employees.count; }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TABEmployeeTableViewCell *cell = (TABEmployeeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[TABEmployeeTableViewCell reuseIdentifier]];
    if (!cell) {
        cell = [[TABEmployeeTableViewCell alloc]init];
    }

    [cell setEmployee:self.employees[indexPath.row]];
    
    return cell;
}

- (void)showErrorMessageWithError:(NSError*)paramError {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:paramError.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
