//
//  DataTableViewController.m
//  IOT-EXAMPLE
//
//  Created by Sankaet Pathak on 12/6/15.
//  Copyright © 2015 Sankaet Pathak. All rights reserved.
//

#import "DataTableViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "DataGraphViewController.h"

@interface DataTableViewController ()
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) NSMutableArray *data;
@end

@implementation DataTableViewController

-(AFHTTPRequestOperationManager *) manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_manager.requestSerializer setValue:@"id-a6603153-293c-4d3e-8d60-d189615c814f|secret-a41654b2-dac7-448f-8456-c7082dee439a" forHTTPHeaderField:@"X-IOT-CLIENT"];
    }
    
    return _manager;
}

-(NSMutableArray *) data{
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSMutableDictionary* dat = [self.data[indexPath.row] mutableCopy];
    
    [cell.textLabel setText:dat[@"_id"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showDataGraph" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"showDataGraph"]) {
        DataGraphViewController *destViewController = segue.destinationViewController;
        NSMutableDictionary *dat = [self.data[index.row] mutableCopy];
        [destViewController setData:dat];
    }
}

- (void) getData{
    [self.manager GET:@"http://162.243.3.84/v1/schemas/5664d954c6f0c02cd6e208c9/data" parameters:NULL success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.responseObject);
        self.data = [responseObject mutableCopy];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseObject);
    }];
}

@end
