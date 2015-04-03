//
//  OrgSettingViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "OrgSettingViewController.h"
#import "CityViewController.h"
#import "MeHttpTool.h"

@interface OrgSettingViewController () <UIScrollViewDelegate,CityViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *comanyName;

@property (weak, nonatomic) IBOutlet UILabel *place;

@property (weak, nonatomic) IBOutlet UITextField *address;

@property (weak, nonatomic) IBOutlet UITextField *banName;

@property (weak, nonatomic) IBOutlet UITextField *touchMan;

@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) IBOutlet UITextField *qq;

@property (weak, nonatomic) IBOutlet UITextField *wechat;

@property (weak, nonatomic) IBOutlet UITextView *remark;

@end

@implementation OrgSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(submit)];
    
    [self loadDataSource];
}

#pragma mark - loadDataSource
- (void)loadDataSource
{
    [MeHttpTool getBusinessWithsuccess:^(id json) {
        if (json) {
            NSLog(@"-----%@",json);
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - private
- (void)submit
{
//    NSDictionary *param = @{};
//    [MeHttpTool setBusinessWithParam:param success:^(id json) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
}

#pragma mark - tableviewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        NSLog(@"----");
        CityViewController *city = [[CityViewController alloc] init];
        city.delegate = self;
        [self.navigationController pushViewController:city animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - CityViewControllerDelegate
- (void)didSelectedWithCity:(NSString *)city
{
    self.place.text = city;
}

@end
