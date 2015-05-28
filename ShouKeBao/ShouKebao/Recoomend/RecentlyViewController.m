//
//  RecentlyViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "RecentlyViewController.h"
#import "RecentlyCell.h"
@interface RecentlyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
- (IBAction)timeAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
- (IBAction)priceAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic,strong) NSMutableArray *dataArr;
@end
//↓近到远，高到低 ↑远到近，低到高
@implementation RecentlyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.timeBtn setSelected:YES];
    
   
    [self loadDataSource];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


-(void)loadDataSource
{

}

- (IBAction)timeAction:(id)sender {
    [self.priceBtn setSelected:NO];
   

    if (_timeBtn.selected == YES && [_timeBtn.titleLabel.text isEqualToString:@"时间↓"]) {
        
        [self.timeBtn setTitle:@"时间↑" forState:UIControlStateNormal];
        
    }else if( _timeBtn.selected == YES && [_timeBtn.titleLabel.text isEqualToString:@"时间↑"]){
       
        [self.timeBtn setTitle:@"时间↓" forState:UIControlStateNormal];
            
        }

    else if (_timeBtn.selected == NO){
      
        [self.timeBtn setSelected:YES];
        
    }
   }
//@"时间↓" @"价格↓" @"时间↑" @"价格↑"
- (IBAction)priceAction:(id)sender {
    
    [_timeBtn setSelected:NO];
    
    if (_priceBtn.selected == YES && [_priceBtn.titleLabel.text isEqualToString:@"价格↓"]) {
        
                   [self.priceBtn setTitle:@"价格↑" forState:UIControlStateNormal];
            
            
    }else if(_priceBtn.selected == YES && [_priceBtn.titleLabel.text isEqualToString:@"价格↑"]){
        
        [self.priceBtn setTitle:@"价格↓" forState:UIControlStateNormal];
        }
    else if (_priceBtn.selected == NO){
        
        [self.priceBtn setSelected:YES];
        
    }
    
  
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecentlyCell *cell = [RecentlyCell cellWithTableView:tableView];
    cell.modal = self.dataArr[indexPath.row];
    return cell;
}

@end
