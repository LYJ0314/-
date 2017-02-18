//
//  ViewController.m
//  PopMenuTableView
//


#import "ViewController.h"
#import "CommonMenuView.h"
#import "UIView+AdjustFrame.h"

@interface ViewController ()

@property (nonatomic,assign) BOOL flag;
@property (nonatomic,assign) int itemCount;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation ViewController {
    NSArray *_dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  rightBarButton的点击标记，每次点击更改flag值。
     *  如果您用普通的button就不需要设置flag，通过按钮的seleted属性来控制即可
     */
    self.flag = YES;
    
    NSDictionary *dict1 = @{@"imageName" : @"icon_button_affirm",
                             @"itemName" : @"撤回"
                            };
    NSDictionary *dict2 = @{@"imageName" : @"icon_button_recall",
                             @"itemName" : @"确认"
                            };
    NSDictionary *dict3 = @{@"imageName" : @"icon_button_record",
                             @"itemName" : @"记录"
                            };
    NSArray *dataArray = @[dict1,dict2,dict3];
    _dataArray = dataArray;

    __weak __typeof(&*self)weakSelf = self;
    /**
     *  创建普通的MenuView，frame可以传递空值，宽度默认120，高度自适应
     */
    [CommonMenuView createMenuWithFrame:CGRectZero target:self dataArray:dataArray itemsClickBlock:^(NSString *str, NSInteger tag) {
        [weakSelf doSomething:(NSString *)str tag:(NSInteger)tag]; // do something
    } backViewTap:^{
        weakSelf.flag = YES; // 这里的目的是，让rightButton点击，可再次pop出menu
    }];
}

#pragma mark -- Nav上的四个button
- (IBAction)popMenuOrganize:(id)sender {
    [self popMenu:CGPointMake(self.navigationController.view.width - 30, 50)];
}
- (IBAction)popMenuCompose:(id)sender {
    [self popMenu:CGPointMake(self.navigationController.view.width - 80, 50)];
}
- (IBAction)popMenuAction:(id)sender {
    [self popMenu:CGPointMake(75, 50)];
}
- (IBAction)popMenuAdd:(id)sender {
    [self popMenu:CGPointMake(30, 50)];
}
- (void)popMenu:(CGPoint)point{
    if (self.flag) {
        [CommonMenuView showMenuAtPoint:point];
        self.flag = NO;
    }else{
        [CommonMenuView hidden];
        self.flag = YES;
    }
}


#pragma mark  -- 增加一个菜单项
- (IBAction)addMenuItem:(id)sender {
    
    NSDictionary *addDict = @{@"imageName" : @"icon_button_recall",
                              @"itemName" : [NSString stringWithFormat:@"新增项%d",self.itemCount + 1]
                              };
    NSArray *newItemArray = @[addDict];
    /**
     *  追加菜单项
     */
    [CommonMenuView appendMenuItemsWith:newItemArray];
    
    self.itemCount ++;
    self.numberLabel.text = [NSString stringWithFormat:@"累计增加  %d  项", self.itemCount];
}

#pragma mark -- 恢复菜单项
- (IBAction)removeMenuItem:(id)sender {
    /**
     *  更新菜单
     */
    [CommonMenuView updateMenuItemsWith:_dataArray];
    
    self.itemCount = 0;
    self.numberLabel.text = [NSString stringWithFormat:@"累计增加 %d 项", self.itemCount];
}

#pragma mark -- 回调事件(自定义)
- (void)doSomething:(NSString *)str tag:(NSInteger)tag{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:str message:[NSString stringWithFormat:@"点击了第%ld个菜单项",tag] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
    
    [CommonMenuView hidden];
    self.flag = YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:touch.view];
    [CommonMenuView showMenuAtPoint:point];
}

#pragma mark -- dealloc:释放菜单
- (void)dealloc{
    [CommonMenuView clearMenu];   // 移除菜单
}

@end
