
//
//  EditCellViewController.m
//  EditCellCustom
//
//  Created by mark on 15/10/11.
//  Copyright © 2015年 mark. All rights reserved.
//

#import "MCEditViewController.h"
#import "MCContact.h"
#import "MCCustomEditTableViewCell.h"
#import "MCEditCellDefine.h"

@interface MCEditViewController ()<UITableViewDataSource ,UITableViewDelegate ,MCCustomEditTableViewCellDelegate>
@property (nonatomic,weak)  UITableView *tableView;


/**
 *  联系人数组
 */
@property (nonatomic,strong) NSMutableArray *contacts;

/**
 *  侧滑cell按钮的个数
 */
@property (nonatomic,strong) NSMutableArray *rowActions;

@property (nonatomic,strong) MCCustomEditTableViewCell *editCell;

@end

@implementation MCEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化tableView
    [self setupTableView];

}

// 初始化tableView
- (void)setupTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    //    tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    tableView.delegate = self;
    tableView.dataSource = self;
//    self.tableView.rowHeight = kRowHeight;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    view.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = view;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"editContactCell";
    MCCustomEditTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (cell == nil) {
        
        cell = [[MCCustomEditTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
    }
    MCContact *contact = self.contacts[indexPath.row];
    cell.textLabel.text = contact.name ;
    cell.detailTextLabel.text = contact.desc;
    
    //侧滑cell里面需要的数据
    cell.indexPath = indexPath;
    cell.rightViewHeight = kRowHeight;
    cell.delegate = self;
    cell.gestureBengin = YES;
    
    // 根据模型里面的数据来判断需要显示几个button
    if (contact.rowActiontag ==0) {
        [self removeRightViewBtn:cell];
        [cell addRightBtnWith:@"删除" backgroundColor:[UIColor redColor] rightViewHeight:kRowHeight];

    }else if(contact.rowActiontag ==1){
        [self removeRightViewBtn:cell];

        [cell addRightBtnWith:@"标为已读" backgroundColor:[UIColor grayColor] rightViewHeight:kRowHeight];

    }else{
        [self removeRightViewBtn:cell];
        
        [cell addRightBtnWith:@"删除" backgroundColor:[UIColor redColor] rightViewHeight:kRowHeight];
        [cell addRightBtnWith:@"标为已读" backgroundColor:[UIColor grayColor] rightViewHeight:kRowHeight];

    }

    return cell;
}

#pragma mark - UITableViewDelegate

// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kRowHeight;
}

//  设置cell点击的高亮显示（yes 高亮  no 不显示高亮）
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView cellForRowAtIndexPath:indexPath] == self.editCell) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MCCloseRightView" object:nil];
        self.editCell = nil;//打开的rightView关闭上之后 还能有Highlight
        return NO;
    }
    return YES;
}

// 点击cell触发的该方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    //发通知 让打开的cell关闭
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MCCloseRightView" object:nil];

}

// 监听tableView的滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MCCloseRightView" object:nil];
}


//  移除上次加进rightView的btn 并把rightView里纪录加进去多少Btn的数组清空
- (void)removeRightViewBtn:(MCCustomEditTableViewCell *)cell {
    [cell.rightView.btnArray removeAllObjects];
    for (UIButton *btn in cell.rightView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn removeFromSuperview];
        }
    }
}

#pragma mark - MCCustomEditTableViewCellDelegate

// 监听侧滑按钮的点击
- (void)customEditTableViewCell:(MCCustomEditTableViewCell *)customEditTableViewCell didClickRightBtn:(UIButton *)btn indexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"-- %@-----%lu",btn.titleLabel.text,(unsigned long)indexPath.row);
}

//将要显示
- (void)rightViewWillShowInCell:(MCCustomEditTableViewCell *)cell{

}

//完全显示 (这里监听的cell保存起来 方便在tableView的delegate中设置打开状态cell的细节)
- (void)rightViewDidShowInCell:(MCCustomEditTableViewCell *)cell{
    self.editCell = cell;
}

//将要隐藏
- (void)rightViewWillHideInCell:(MCCustomEditTableViewCell *)cell{
    
}

//完全隐藏
- (void)rightViewDidHideInCell:(MCCustomEditTableViewCell *)cell{
    
}

#pragma mark - 数据的懒加载
- (NSMutableArray *)contacts
{
    if (_contacts == nil) {
        // 1.从文件中读取联系人数据
        _contacts = [NSKeyedUnarchiver unarchiveObjectWithFile:MCContactsFilepath];
        
        // 2.如果数组为nil
        if (!_contacts) {
            
            _contacts = [NSMutableArray array] ;
            for (int i = 0; i<100; i++) {
                MCContact *contactModel = [[MCContact alloc]init];
                contactModel.name = [NSString stringWithFormat:@"name--%d",i];
                contactModel.desc = [NSString stringWithFormat:@"desc--%d",i];
                contactModel.rowActiontag = i%3;
                [_contacts addObject:contactModel];
            }
            
        }
    }
    return _contacts;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
