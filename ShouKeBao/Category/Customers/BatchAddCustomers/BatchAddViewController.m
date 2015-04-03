//
//  BatchAddViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BatchAddViewController.h"
#import "batchCell.h"
#import "batchModel.h"
#import <AddressBook/AddressBook.h>
#import "IWHttpTool.h"
#import <AddressBookUI/AddressBookUI.h>

@interface BatchAddViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSMutableArray *dataArr;
@property (strong,nonatomic) NSMutableArray *editArr;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation BatchAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"批量添加客户";
    self.table.rowHeight = 98;
    [self loadData];
    [self.table setEditing:YES animated:YES];
    [self setUpRightButton];
}
-(void)setUpRightButton{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [button setBackgroundImage:[UIImage imageNamed:@"gou"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(EditCustomerDetail)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem= barItem;
    
    
  }


-(void)EditCustomerDetail
{
    NSMutableArray *arr = [NSMutableArray array];
  
    for(int i = 0 ;i<_editArr.count;i++){
       
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        batchModel *model = _editArr[i];
        
        [dic setValue:model.name forKey:@"Name"];
         [dic setValue:model.tel forKey:@"Mobile"];
        [arr addObject:dic];
        
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];//@"/Customer/CreateCustomerList"
        [dic setObject:arr forKey:@"CustomerList"];
   
    [IWHttpTool WMpostWithURL:@"/Customer/CreateCustomerList" params:dic success:^(id json) {
        NSLog(@"批量导入客户成功 返回json is %@",json);
    } failure:^(NSError *error) {
        NSLog(@"批量导入客户失败，返回error is %@",error);
    }];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void )loadData
{ABAddressBookRef addressBooks = nil;
addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
    //获取通讯录权限
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    for(NSInteger i = 0; i<nPeople; i++)
        {
        //创建一个addressBook shuxing类
        batchModel *addressBooks = [[batchModel alloc]init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonAddressProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
            } else {
            if ((__bridge id)abLastName != nil)
                {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
                }}
        
        addressBooks.name = nameString;
        addressBooks.recordID = [NSString stringWithFormat:@"%d",ABRecordGetRecordID(person)];;
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
            };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;}
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                        case 0: {// Phone number
                        addressBooks.tel = (__bridge NSString*)value;
                        break;}
                        case 1: {// Email
                        addressBooks.email = (__bridge NSString*)value;
                        break;
                        }
                        }
                CFRelease(value);
                }
            CFRelease(valuesRef);
            }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [self.dataArr addObject:addressBooks];
        }
}


-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)editArr
{
    if (_editArr == nil) {
        self.editArr = [NSMutableArray array];
    }
    return _editArr;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    batchCell *cell = [batchCell cellWithTableView:tableView];
    cell.model = _dataArr[indexPath.row];
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[self.editArr addObject:_dataArr[indexPath.row]];
    batchModel *model = _dataArr[indexPath.row];
    [self.editArr addObject:model];
    
    NSLog(@"--------editArr is %@--------indexpath.row's model is %@---",_editArr,_dataArr[indexPath.row]);
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    batchModel *model = _dataArr[indexPath.row];
    [self.editArr removeObject:model];
    NSLog(@"--------editArr is %@--------indexpath.row's model is %@---",_editArr,_dataArr[indexPath.row]);
    
}



@end
