//
//  AddRemindViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/24.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "AddRemindViewController.h"
#import "IWHttpTool.h"
#import "StrToDic.h"
#import "MBProgressHUD+MJ.h"

@interface AddRemindViewController () <UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *descript;

@property (strong, nonatomic) UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UILabel *holder;

@end

@implementation AddRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加提醒";
    
    [self setNav];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textHandle:) name:UITextViewTextDidChangeNotification object:self.descript];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - getter
- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        CGFloat pickerH = 160;
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.frame.size.width, pickerH)];
        _datePicker.minimumDate = [NSDate date];
        _datePicker.backgroundColor = [UIColor whiteColor];
    }
    return _datePicker;
}

#pragma mark - private
- (void)textHandle:(NSNotification *)noty
{
    UITextView *textView = (UITextView *)noty.object;
    
    self.holder.hidden = textView.text.length;
}

- (void)setNav
{
    // 左边箭头
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
    // 右边完成
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    
    [button setImage:[UIImage imageNamed:@"wancheng"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(complete)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem= barItem;
}
- (IBAction)confirmClick:(id)sender
{
    [self requestComplete];
}

// 完成
- (void)complete {
    [self requestComplete];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestComplete
{
    NSString *date = [StrToDic stringFromDate:self.datePicker.date];
    
    if (self.descript.text.length>1 ) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *arrDic = [NSMutableDictionary dictionary];
        //NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        [arrDic setObject:self.descript.text forKey:@"Content"];
        //NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        [arrDic setObject:date forKey:@"RemindTime"];
        
        
        [dic setObject:arrDic forKey:@"CustomerRemind"];
        [dic setObject:self.ID forKey:@"CustomerID"];
        
        MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        hudView.labelText = @"创建中...";
        [hudView show:YES];
        
        [IWHttpTool WMpostWithURL:@"/Customer/CreateCustomerRemind" params:dic success:^(id json) {
            NSLog(@"创建客户提醒成功 ：%@",json);
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(ringToRefreshRemind)]) {
                [self.delegate ringToRefreshRemind];
            }
            
            hudView.labelText = @"创建成功";
            [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window]
                                     animated:YES];
        } failure:^(NSError *error) {
            NSLog(@"创建客户提醒的请求失败%@",error);
        }];
    }else if (self.descript.text.length>2 ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"最起码填写3个字吧？😄" message:@"若您想放弃添加提醒，点击返回按钮可以啦！～" delegate:self cancelButtonTitle:@"谢谢，我知道了" otherButtonTitles: nil];
        [alert show];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)removePicker
{
    if (_datePicker) {
        [UIView animateWithDuration:0.3 animations:^{
            _datePicker.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [_datePicker removeFromSuperview];
            _datePicker = nil;
        }];
    }
}

- (void)tapHandle:(UITapGestureRecognizer *)ges
{
    [self.view endEditing:YES];
    [self removePicker];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        if (!_datePicker) {
            [self.view addSubview:self.datePicker];
            
            [UIView animateWithDuration:0.3 animations:^{
                _datePicker.transform = CGAffineTransformMakeTranslation(0, - _datePicker.frame.size.height);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [self removePicker];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return YES;
    }else{
        return NO;
    }
}

@end
