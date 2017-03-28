//
//  ViewController.m
//  HWaterflow
//
//  Created by yellowei on 17/3/28.
//  Copyright © 2017年 yellowei. All rights reserved.
//

//Controllerws
#import "ViewController.h"

//Views
#import "ECClinicCollectHeadView.h"
#import "ECHPLargeBtnCell.h"
#import "ECHPListDetailCell.h"

//Models


//Tools
#import "WaterFlowLayout.h"
#import "UIButton+Extension.h"




#define kBannerHeight 180.f

static NSString *headerIdentifier = @"headCell";

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray * btnsModelArr;

@property(nonatomic,strong)UICollectionView * m_collectView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initCollectionView];
}

# pragma mark - Setter

# pragma mark - Getter

- (NSMutableArray *)btnsModelArr
{
    if (!_btnsModelArr)
    {
        _btnsModelArr = [[NSMutableArray alloc] initWithCapacity:8];
        
        NSArray * titles = @[@"预约",@"账单",@"家庭档案",@"预付款",@"会员卡",@"诊所",@"医生",@"项目",@"医嘱"];
        NSArray *imgs = @[@"hp_btn_bespeak",@"hp_btn_bill",@"hp_btn_homecases",@"hp_btn_advance",@"hp_btn_vipcard",@"hp_btn_clinic",@"hp_btn_doctor",@"hp_btn_proj",@"hp_btn_msg"];
        for (int i = 0; i < 9; i ++)
        {
            ECHPSmallBtnModel * model = [[ECHPSmallBtnModel alloc] init];
            model.img = imgs[i];
            model.title = titles[i];
            [_btnsModelArr addObject:model];
        }
    }
    return _btnsModelArr;
}

# pragma mark - Init UI
- (void)initCollectionView
{
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets  = NO;
    }
    
    WaterFlowLayout * layout = [[WaterFlowLayout alloc] init];
    layout.delegate = self;
    layout.rowMargin = 0;
    layout.colMargin = 0;
    //配置数组的结构, 以此来配置布局结构
    layout.columnForSections = @[@(3),@(4),@(1)];
    layout.sectionInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.useHeader = YES;
    //    layout.useFooter = YES;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kECScreenWidth, kECScreenHeight - 49.0f) collectionViewLayout:layout];
    
    collectView.backgroundColor = [UIColor grayColor];
    collectView.delegate = self;
    collectView.dataSource = self;
    collectView.contentInset = UIEdgeInsetsMake(kBannerHeight + 64, 0, 0, 0);
    
    [collectView registerNib:[UINib nibWithNibName:@"ECHPLargeBtnCell" bundle:nil] forCellWithReuseIdentifier:@"LargeBtnCell"];
    [collectView registerNib:[UINib nibWithNibName:@"ECHPSmallBtnCell" bundle:nil] forCellWithReuseIdentifier:@"SmallBtnCell"];
    [collectView registerNib:[UINib nibWithNibName:@"ECHPListDetailCell" bundle:nil] forCellWithReuseIdentifier:@"ListDetailCell"];
    
    [collectView registerClass:[ECClinicCollectHeadView  class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    [collectView registerClass:[ECClinicCollectHeadView  class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:headerIdentifier];
    
    self.m_collectView = collectView;
    
    [self.view addSubview:collectView];
}


# pragma mark - WaterFlowLayoutDelegate
//- (CGSize)waterFlowLayout:(WaterFlowLayout *)waterFlowLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(0, 50);
//}

- (CGSize)waterFlowLayout:(WaterFlowLayout *)waterFlowLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return CGSizeMake(kECScreenWidth, 0);
    }
    if (section == 2)
    {
        {
            return CGSizeMake(kECScreenWidth, 50);
        }
    }
    return CGSizeMake(kECScreenWidth, 10);
    
}

- (CGFloat)waterFlowLayout:(WaterFlowLayout *)waterFlowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0)
    {
        if (row == 0)
        {
            return kECScreenWidth / 7.f * 4.f;//CGSizeMake(kECScreenWidth / 7.f * 3.f, kECScreenWidth / 7.f * 4.f);
        }
        else
        {
            return kECScreenWidth / 7.f * 2.f;
        }
    }
    else if (section == 1)
    {
        return 72.f;
    }
    else if (section == 2)
    {
        return 80.f;
    }
    return 0;
}


- (CGFloat)waterFlowLayout:(WaterFlowLayout *)waterFlowLayout widthForHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0)
    {
        if (row == 0)
        {
            return kECScreenWidth / 7.f * 3.f;//CGSizeMake(kECScreenWidth / 7.f * 3.f, kECScreenWidth / 7.f * 4.f);
        }
        else
        {
            return kECScreenWidth / 7.f * 2.f;
        }
    }
    else if (section == 1)
    {
        return kECScreenWidth / 4.f;
    }
    else if (section == 2)
    {
        
        return kECScreenWidth;
    }
    return 0;
}




# pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 5;
    }
    else if (section == 1)
    {
        return 4;
    }
    else if (section == 2)
    {
        return 3;
    }
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        ECClinicCollectHeadView *view = (ECClinicCollectHeadView *)[collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:headerIdentifier   forIndexPath:indexPath];
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, kECScreenWidth, 50);
        for (UIView *subView in view.subviews)
        {
            [subView removeFromSuperview];
        }
        if (indexPath.section == 2)
        {
            view.hidden = NO;
            UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kECScreenWidth, 50)];
            baseView.backgroundColor = [UIColor whiteColor];
            
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kECScreenWidth, 10)];
            topView.backgroundColor = [UIColor grayColor];
            [baseView addSubview:topView];
            
            UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.4, kECScreenWidth, 0.6)];
            bottomLineView.backgroundColor = [UIColor grayColor];
            [baseView addSubview:bottomLineView];
            
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 140, 40)];
            titleLab.font = [UIFont systemFontOfSize:14.0f];
            titleLab.textColor = [UIColor grayColor];
            titleLab.text = @"热门资讯";
            [baseView addSubview:titleLab];
            
            UIButton *btn = [UIButton imageTitleButtonWithFrame:CGRectMake(kECScreenWidth - 70 , 10, 60, 40) image:[UIImage imageNamed:@"icon_user_next2"] showImageSize:CGSizeMake(12, 18) title:@"更多" titleFont:[UIFont systemFontOfSize:14.0f] imagePosition:UIImageOrientationRight buttonType:UIButtonTypeSystem];
            btn.tintColor = [UIColor grayColor];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(onMoreInfoClick:) forControlEvents:UIControlEventTouchUpInside];
            [baseView addSubview:btn];
            [view addSubview:baseView];
            
            {
                btn.hidden = NO;
            }
        }
        else
        {
            view.hidden = YES;
        }
        
        
        return view;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    //设置(Highlight)高亮下的颜色
    [cell setBackgroundColor:[UIColor grayColor]];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    //设置(Highlight)高亮下的颜色
    [cell setBackgroundColor:[UIColor whiteColor]];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier1 = @"LargeBtnCell";
    static NSString * identifier2 = @"SmallBtnCell";
    static NSString * identifier3 = @"ListDetailCell";
    
    ECHPLargeBtnCell * cell = nil;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier1 forIndexPath:indexPath];
            cell.btnModel = [self.btnsModelArr objectAtIndex:indexPath.row];
        }
        else
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier2 forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 0.5f;
            cell.contentView.layer.borderColor = [UIColor grayColor].CGColor;
            cell.btnModel = [self.btnsModelArr objectAtIndex:indexPath.row];
        }
    }
    else if (indexPath.section == 1)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier2 forIndexPath:indexPath];
        cell.btnModel = [self.btnsModelArr objectAtIndex:indexPath.section * 5 + indexPath.row];
        
    }
    //热门资讯
    else if(indexPath.section == 2)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier3 forIndexPath:indexPath];
//        ((ECHPListDetailCell *)cell).hotInfo = [self.hotsArr objectAtIndex:indexPath.row];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}


# pragma mark - <UICollectionViewDelegate>

@end
