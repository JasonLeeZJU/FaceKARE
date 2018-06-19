//
//  HPicturesViewController.m
//  FaceKARE
//
//  Created by Anan on 2017/7/26.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HPicturesViewController.h"
#import "AppDelegate.h"
#import "AppUIModel.h"
#import "HPicturesCollectionViewCell.h"
#import "HPicturesCollectionReusableView.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define TABBAR_WIDTH [self.tabBarController.tabBar bounds].size.height

@interface HPicturesViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    
}



// 主色调背景
@property (nonatomic, strong) UIView *picturesView;
// 悬浮在 tableView 上的 View
@property (nonatomic, strong) UIView *picturesBottomView;
// 拍照 Button
@property (nonatomic, strong) UIButton *takePicturesButton;
// 对比 Button
@property (nonatomic, strong) UIButton *compareButton;
// 删除 Button
@property (nonatomic, strong) UIButton *deleteButton;
// 瀑布流
@property (nonatomic, strong) UICollectionView *picturesCollectionView;
// 瀑布流 cell
@property (nonatomic, strong) HPicturesCollectionViewCell *picturesCVC;
// 用来存放Cell的唯一标示符
@property (nonatomic, strong) NSMutableDictionary *cellDic;

@end

@implementation HPicturesViewController {
    // 编辑按钮
    UIBarButtonItem *editorButton;
    // 取消按钮
    UIBarButtonItem *cancelButton;
    // 拍照相片 Information
    NSMutableDictionary *imageInformationDictionary;
    // 是否是编辑模式
    BOOL isInEditor;
    // 单个被选中的图片的 index.row
    //    int oneSelectedImageIndexRow; 改为👇
    // 单个被选中的图片的 indexPath
    NSIndexPath *oneSelectedImageIndexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCompareNotificationAction) name:@"checkCompareNotification" object:nil];
    
    // 设置页面 navigation 标题
    self.navigationItem.title = NSLocalizedString(@"picturesViewNavigationTitle", nil);
    
    // 初始化属性
    isInEditor = NO;
    self.cellDic = [[NSMutableDictionary alloc] init];
    
    // 设置返回按钮
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
    backbutton.title = @"";
    self.navigationItem.backBarButtonItem = backbutton;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // 设置编辑/取消按钮
    editorButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"picturesEditorButton", nil) style:UIBarButtonItemStyleDone target:self action:@selector(editorButtonAction:)];
    cancelButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"picturesCancelButton", nil) style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonAction:)];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = editorButton;
    
    // 设置背景颜色
    self.view.backgroundColor = [AppUIModel UIViewBackgroundColor];
    
    // 设置 view
    self.picturesView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    self.picturesView.backgroundColor = [AppUIModel UIViewMainColorI];
    self.picturesView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.picturesView];
    
    // 设置安置 button 的 view
    self.picturesBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TABBAR_WIDTH - 80, SCREEN_WIDTH, 80)];
    self.picturesBottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.picturesBottomView];
    
    // 设置拍照 button
    self.takePicturesButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH - 120, 40)];
    [self.takePicturesButton.layer setMasksToBounds:YES];
    [self.takePicturesButton.layer setCornerRadius:10.0f];
    self.takePicturesButton.backgroundColor = [AppUIModel UIViewMainColorII];
    [self.takePicturesButton setTitle:NSLocalizedString(@"takePicturesButton", nil) forState:UIControlStateNormal];
    [self.takePicturesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.takePicturesButton.titleLabel.font = [AppUIModel UIViewTitleFont];
    [self.takePicturesButton setShowsTouchWhenHighlighted:YES];
    [self.takePicturesButton.layer setBorderWidth:1.0f];
    [self.takePicturesButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
    [self.takePicturesButton addTarget:self action:@selector(takePicturesButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.picturesBottomView addSubview:self.takePicturesButton];
    
    // 设置对比 button
    self.compareButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 20, (SCREEN_WIDTH - 120) * 0.5, 40)];
    [self.compareButton.layer setMasksToBounds:YES];
    [self.compareButton.layer setCornerRadius:10.0f];
    self.compareButton.backgroundColor = [AppUIModel UIUselessColor];
    [self.compareButton setTitle:NSLocalizedString(@"takePicturesCompareButton", nil) forState:UIControlStateNormal];
    [self.compareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.compareButton.titleLabel.font = [AppUIModel UIViewTitleFont];
    [self.compareButton setShowsTouchWhenHighlighted:YES];
    [self.compareButton.layer setBorderWidth:1.0f];
    [self.compareButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
    [self.compareButton addTarget:self action:@selector(compareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.compareButton setEnabled:NO];
    self.compareButton.hidden = YES;
    [self.picturesBottomView addSubview:self.compareButton];
    
    // 设置删除 button
    self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(80 + (SCREEN_WIDTH - 120) * 0.5, 20, (SCREEN_WIDTH - 120) * 0.5, 40)];
    [self.deleteButton.layer setMasksToBounds:YES];
    [self.deleteButton.layer setCornerRadius:10.0f];
    self.deleteButton.backgroundColor = [AppUIModel UIViewMainColorII];
    [self.deleteButton setTitle:NSLocalizedString(@"takePicturesDeleteButton", nil) forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = [AppUIModel UIViewTitleFont];
    [self.deleteButton setShowsTouchWhenHighlighted:YES];
    [self.deleteButton.layer setBorderWidth:1.0f];
    [self.deleteButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
    [self.deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteButton.hidden = YES;
    [self.picturesBottomView addSubview:self.deleteButton];
    
    [self createCollectionView];
}

- (void)createCollectionView
{
    static NSString *identifiter = @"cellIdentifiter";
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 定义每个 collectionViewCell 的大小
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 80) / 3, (SCREEN_WIDTH - 80) / 3 + 30);
    // 定义每个 collectionViewCell 的横向间距
    flowLayout.minimumLineSpacing = 20.0f;
    // 定义每个 collectionViewCell 的纵向间距
    flowLayout.minimumInteritemSpacing = 20.0f;
    // 定义每个 collectionViewCell 的大小
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    // 滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 给瀑布流分配空间
    self.picturesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_WIDTH - 144) collectionViewLayout:flowLayout];
    self.picturesCollectionView.delegate = self;
    self.picturesCollectionView.dataSource = self;
    self.picturesCollectionView.backgroundColor = [UIColor clearColor];
    [self.picturesCollectionView registerClass:[HPicturesCollectionViewCell class] forCellWithReuseIdentifier:identifiter];
    [self.picturesCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HV"];
    [self.picturesCollectionView setShowsVerticalScrollIndicator:NO];
    
    
    
    [self.view addSubview:self.picturesCollectionView];
    
}

#pragma mark -collectionView设置
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return [ApplicationDelegate.picturesArray count]; 改为👇
    if (section == 0)
    {
        return [ApplicationDelegate.eyelidsPicturesArray count];
    }
    else if (section == 1)
    {
        return [ApplicationDelegate.blemishPicturesArray count];
    }
    else
    {
        return [ApplicationDelegate.firmingPicturesArray count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"identifier%@", [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [self.picturesCollectionView registerClass:[HPicturesCollectionViewCell class]  forCellWithReuseIdentifier:identifier];
    }
    self.picturesCVC = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    if (indexPath.section == 0) {
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.eyelidsPicturesArray objectAtIndex:indexPath.row] valueForKey:@"Name"]]];
        [self.picturesCVC.checkButton setSelected:NO];
        self.picturesCVC.pictureImageView.image = image;
        self.picturesCVC.dateLabel.text = [[ApplicationDelegate.eyelidsPicturesArray objectAtIndex:indexPath.row] valueForKey:@"Data"];
//        self.picturesCVC.modelLabel.text = NSLocalizedString(@"takePicturesModel1", nil);
    }
    else if (indexPath.section == 1) {
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.blemishPicturesArray objectAtIndex:indexPath.row] valueForKey:@"Name"]]];
        [self.picturesCVC.checkButton setSelected:NO];
        self.picturesCVC.pictureImageView.image = image;
        self.picturesCVC.dateLabel.text = [[ApplicationDelegate.blemishPicturesArray objectAtIndex:indexPath.row] valueForKey:@"Data"];
//        self.picturesCVC.modelLabel.text = NSLocalizedString(@"takePicturesModel2", nil);
    }
    else
    {
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.firmingPicturesArray objectAtIndex:indexPath.row] valueForKey:@"Name"]]];
        [self.picturesCVC.checkButton setSelected:NO];
        self.picturesCVC.pictureImageView.image = image;
        self.picturesCVC.dateLabel.text = [[ApplicationDelegate.firmingPicturesArray objectAtIndex:indexPath.row] valueForKey:@"Data"];
//        self.picturesCVC.modelLabel.text = NSLocalizedString(@"takePicturesModel3", nil);
    }
    
//    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.picturesArray objectAtIndex:indexPath.row] valueForKey:@"Name"]]];
//    [self.picturesCVC.checkButton setSelected:NO];
//    self.picturesCVC.pictureImageView.image = image;
//    self.picturesCVC.dateLabel.text = [[ApplicationDelegate.picturesArray objectAtIndex:indexPath.row] valueForKey:@"Data"];
//    if ([[[ApplicationDelegate.picturesArray objectAtIndex:indexPath.row] valueForKey:@"Model"] isEqualToString:@"0"])
//    {
//        self.picturesCVC.modelLabel.text = NSLocalizedString(@"takePicturesModel1", nil);
//    }
//    else if ([[[ApplicationDelegate.picturesArray objectAtIndex:indexPath.row] valueForKey:@"Model"] isEqualToString:@"1"])
//    {
//        self.picturesCVC.modelLabel.text = NSLocalizedString(@"takePicturesModel2", nil);
//    }
//    else if ([[[ApplicationDelegate.picturesArray objectAtIndex:indexPath.row] valueForKey:@"Model"] isEqualToString:@"2"])
//    {
//        self.picturesCVC.modelLabel.text = NSLocalizedString(@"takePicturesModel3", nil);
//    }
    
    if (isInEditor == YES) {
        self.picturesCVC.checkButton.hidden = NO;
    }
    else
    {
        self.picturesCVC.checkButton.hidden = YES;
    }
    self.picturesCVC.indexPath = indexPath;
    
    
    return self.picturesCVC;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = [[UICollectionReusableView alloc] init];
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *headerView = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HV" forIndexPath:indexPath];
//        headerView.backgroundColor = [UIColor greenColor];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 50)];
        headerLabel.textColor = [AppUIModel UIViewNormalColor];
        headerLabel.font = [AppUIModel UIViewNormalFont];
        [headerLabel setTextAlignment:NSTextAlignmentLeft];
        headerLabel.center = CGPointMake(SCREEN_WIDTH * 0.5, 25);
        if (indexPath.section == 0) {
            headerLabel.text = NSLocalizedString(@"takePicturesSection1", nil);
        }
        else if (indexPath.section == 1)
        {
            headerLabel.text = NSLocalizedString(@"takePicturesSection2", nil);
        }
        else if (indexPath.section == 2)
        {
            headerLabel.text = NSLocalizedString(@"takePicturesSection3", nil);
        }
        [headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [headerView addSubview:headerLabel];
        reusableView = headerView;
    }

    
    //    reusableView.backgroundColor = [UIColor greenColor];
    
    
    return reusableView;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size = CGSizeMake(SCREEN_WIDTH, 50);
    return size;
}

//被选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"~~~");
    [ApplicationDelegate addBigPicture:indexPath];
    
    UIButton *oneDeleteButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, SCREEN_HEIGHT - 50, 100, 30)];
    [oneDeleteButton.layer setMasksToBounds:YES];
    [oneDeleteButton.layer setCornerRadius:6.0f];
    oneDeleteButton.backgroundColor = [AppUIModel UIViewMainColorII];
    [oneDeleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [oneDeleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    oneDeleteButton.titleLabel.font = [AppUIModel UIViewTitleFont];
    [oneDeleteButton setShowsTouchWhenHighlighted:YES];
    [oneDeleteButton.layer setBorderWidth:1.0f];
    [oneDeleteButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
    [oneDeleteButton addTarget:self action:@selector(oneDeleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [ApplicationDelegate.maskView addSubview:oneDeleteButton];
    
//    oneSelectedImageIndexRow = (int)indexPath.row;  改为👇
    oneSelectedImageIndexPath = indexPath;
    
//    [ApplicationDelegate.maskView add]
    
}

- (void)oneDeleteButtonAction:(UIButton *)sender
{
    NSLog(@"999");
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    //文件名
//    NSString *uniquePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.picturesArray objectAtIndex:oneSelectedImageIndexRow] valueForKey:@"Name"]];
    NSString *uniquePath = [[NSString alloc] init];
    if (oneSelectedImageIndexPath.section == 0)
    {
        uniquePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.eyelidsPicturesArray objectAtIndex:oneSelectedImageIndexPath.row] valueForKey:@"Name"]];
    }
    else if (oneSelectedImageIndexPath.section == 1)
    {
        uniquePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.blemishPicturesArray objectAtIndex:oneSelectedImageIndexPath.row] valueForKey:@"Name"]];
    }
    else if (oneSelectedImageIndexPath.section == 2)
    {
        uniquePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.firmingPicturesArray objectAtIndex:oneSelectedImageIndexPath.row] valueForKey:@"Name"]];
    }
    
    
    BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no have");
        return ;
    }else {
        NSLog(@"have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
//            [ApplicationDelegate.picturesArray removeObjectAtIndex:oneSelectedImageIndexRow];
//            [ApplicationDelegate.selectedPicturesArray removeAllObjects]; 改为👇
            if (oneSelectedImageIndexPath.section == 0)
            {
                [ApplicationDelegate.eyelidsPicturesArray removeObjectAtIndex:oneSelectedImageIndexPath.row];
                [ApplicationDelegate.selectedPicturesArray removeAllObjects];
                NSArray *path2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPath = [path2 objectAtIndex:0];
                NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"eyelidsPictures.plist"];
                [ApplicationDelegate.eyelidsPicturesArray writeToFile:plistPath atomically:YES];
                [self.picturesCollectionView reloadData];
                [ApplicationDelegate deleteMaskView];
            }
            else if (oneSelectedImageIndexPath.section == 1)
            {
                [ApplicationDelegate.blemishPicturesArray removeObjectAtIndex:oneSelectedImageIndexPath.row];
                [ApplicationDelegate.selectedPicturesArray removeAllObjects];
                NSArray *path2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPath = [path2 objectAtIndex:0];
                NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"blemishPictures.plist"];
                [ApplicationDelegate.blemishPicturesArray writeToFile:plistPath atomically:YES];
                [self.picturesCollectionView reloadData];
                [ApplicationDelegate deleteMaskView];
            }
            else if (oneSelectedImageIndexPath.section == 2)
            {
                [ApplicationDelegate.firmingPicturesArray removeObjectAtIndex:oneSelectedImageIndexPath.row];
                [ApplicationDelegate.selectedPicturesArray removeAllObjects];
                NSArray *path2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPath = [path2 objectAtIndex:0];
                NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"firmingPictures.plist"];
                [ApplicationDelegate.firmingPicturesArray writeToFile:plistPath atomically:YES];
                [self.picturesCollectionView reloadData];
                [ApplicationDelegate deleteMaskView];
            }
        }else {
            NSLog(@"dele fail");
        }
    }
    
}

// takePicturesButton 点击方法
- (void)takePicturesButtonAction:(UIButton *)sender
{
    NSLog(@"takePicturesButton");
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePicturesSelect1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"takePicturesSelect1", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"takePicturesSelect1");
        // 绿
        
        // 分配空间给 imageInformationDictionary
        self->imageInformationDictionary = nil;
        self->imageInformationDictionary = [[NSMutableDictionary alloc] init];
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:imagePicker animated:YES completion:nil];
        [self->imageInformationDictionary setObject:@"0" forKey:@"Model"];
        
    }];
    UIAlertAction *takePicturesSelect2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"takePicturesSelect2", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"takePicturesSelect2");
        // 黄
        
        // 分配空间给 imageInformationDictionary
        self->imageInformationDictionary = nil;
        self->imageInformationDictionary = [[NSMutableDictionary alloc] init];
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:imagePicker animated:YES completion:nil];
        [self->imageInformationDictionary setObject:@"1" forKey:@"Model"];

    }];
    UIAlertAction *takePicturesSelect3 = [UIAlertAction actionWithTitle:NSLocalizedString(@"takePicturesSelect3", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"takePicturesSelect3");
        // 蓝
        
        // 分配空间给 imageInformationDictionary
        self->imageInformationDictionary = nil;
        self->imageInformationDictionary = [[NSMutableDictionary alloc] init];
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:imagePicker animated:YES completion:nil];
        [self->imageInformationDictionary setObject:@"2" forKey:@"Model"];
        
    }];
    UIAlertAction *takePicturesCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"takePicturesCancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
    }];
    [sheet addAction:takePicturesSelect1];
    [sheet addAction:takePicturesSelect2];
    [sheet addAction:takePicturesSelect3];
    [sheet addAction:takePicturesCancel];
    [self presentViewController:sheet animated:YES completion:nil];
}

// editorButton 点击方法
- (void)editorButtonAction:(UIButton *)sender
{
    NSLog(@"editorButton");
    self.navigationItem.rightBarButtonItem = cancelButton;
    self.takePicturesButton.hidden = YES;
    self.compareButton.hidden = NO;
    self.deleteButton.hidden = NO;
    isInEditor = YES;
    [self checkCompareNotificationAction];
    [self.picturesCollectionView reloadData];
}

// cancelButton 点击方法
- (void)cancelButtonAction:(UIButton *)sender
{
    NSLog(@"cancelButton");
    self.navigationItem.rightBarButtonItem = editorButton;
    self.takePicturesButton.hidden = NO;
    self.compareButton.hidden = YES;
    self.deleteButton.hidden = YES;
    isInEditor = NO;
    [ApplicationDelegate.selectedPicturesArray removeAllObjects];
    [self checkCompareNotificationAction];
    [self.picturesCollectionView reloadData];
}

// compareButton 点击方法
- (void)compareButtonAction:(UIButton *)sender
{
    NSLog(@"compareButton");
    [ApplicationDelegate addComparePictures];
}

// deleteButton 点击方法
- (void)deleteButtonAction:(UIButton *)sender
{
    NSLog(@"deleteButton");
    
    NSArray *result = [ApplicationDelegate.selectedPicturesArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [[obj2 valueForKey:@"row"] compare:[obj1 valueForKey:@"row"]]; //降序
    }];
    
    NSLog(@"result >>> %@", result);
    for (NSIndexPath *indexPath in result) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //文件名
//        NSString *uniquePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.picturesArray objectAtIndex:[indexPathRow intValue]] valueForKey:@"Name"]];
//        
//        BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
//        if (!blHave) {
//            NSLog(@"no have");
//            return ;
//        }else {
//            NSLog(@"have");
//            BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
//            if (blDele) {
//                NSLog(@"dele success");
//                [ApplicationDelegate.picturesArray removeObjectAtIndex:[indexPathRow intValue]];
//                [ApplicationDelegate.selectedPicturesArray removeAllObjects];
//            }else {
//                NSLog(@"dele fail");
//            }
//        }
//        // 放在上方 dele success 里面才是正确的做法，但是放在这里可以保证页面上的正确显示
//        NSArray *path2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsPath = [path2 objectAtIndex:0];
//        NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"pictures.plist"];
//        [ApplicationDelegate.picturesArray writeToFile:plistPath atomically:YES];
//        [self.picturesCollectionView reloadData]; 改为👇
        NSLog(@"indexPath >>> %@", indexPath);
        
        if (indexPath.section == 0) {
            NSString *uniquePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.eyelidsPicturesArray objectAtIndex:indexPath.row] valueForKey:@"Name"]];
            BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
            if (!blHave) {
                NSLog(@"no have");
                return ;
            }else {
                NSLog(@"have");
                BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
                if (blDele) {
                    NSLog(@"dele success");
                    [ApplicationDelegate.eyelidsPicturesArray removeObjectAtIndex:indexPath.row];
                    [ApplicationDelegate.selectedPicturesArray removeAllObjects];
                    NSArray *path2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsPath = [path2 objectAtIndex:0];
                    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"eyelidsPictures.plist"];
                    [ApplicationDelegate.eyelidsPicturesArray writeToFile:plistPath atomically:YES];
                    [self.picturesCollectionView reloadData];
                }else {
                    NSLog(@"dele fail");
                }
            }
        }
        else if (indexPath.section == 1)
        {
            NSString *uniquePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.blemishPicturesArray objectAtIndex:indexPath.row] valueForKey:@"Name"]];
            BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
            if (!blHave) {
                NSLog(@"no have");
                return ;
            }else {
                NSLog(@"have");
                BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
                if (blDele) {
                    NSLog(@"dele success");
                    [ApplicationDelegate.blemishPicturesArray removeObjectAtIndex:indexPath.row];
                    [ApplicationDelegate.selectedPicturesArray removeAllObjects];
                    NSArray *path2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsPath = [path2 objectAtIndex:0];
                    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"blemishPictures.plist"];
                    [ApplicationDelegate.blemishPicturesArray writeToFile:plistPath atomically:YES];
                    [self.picturesCollectionView reloadData];
                }else {
                    NSLog(@"dele fail");
                }
            }
        }
        else if (indexPath.section == 2)
        {
            NSString *uniquePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.firmingPicturesArray objectAtIndex:indexPath.row] valueForKey:@"Name"]];
            BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
            if (!blHave) {
                NSLog(@"no have");
                return ;
            }else {
                NSLog(@"have");
                BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
                if (blDele) {
                    NSLog(@"dele success");
                    [ApplicationDelegate.firmingPicturesArray removeObjectAtIndex:indexPath.row];
                    [ApplicationDelegate.selectedPicturesArray removeAllObjects];
                    NSArray *path2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsPath = [path2 objectAtIndex:0];
                    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"firmingPictures.plist"];
                    [ApplicationDelegate.firmingPicturesArray writeToFile:plistPath atomically:YES];
                    [self.picturesCollectionView reloadData];
                }else {
                    NSLog(@"dele fail");
                }
            }
        }
    }
    [self checkCompareNotificationAction];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"choose");
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *photoImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self saveImage:photoImage withName:[NSString stringWithFormat:@"showTime%@.png",[self getCurrentTimesSecond]]];
}

- (NSString *)getCurrentTimesDay
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

- (NSString *)getCurrentTimesSecond
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"canlel");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:path atomically:NO];
    [imageInformationDictionary setObject:imageName forKey:@"Name"];
    NSString *data = [self getCurrentTimesDay];
    [imageInformationDictionary setObject:data forKey:@"Data"];
    NSLog(@"--- %@", imageInformationDictionary);
//    ApplicationDelegate.picturesArray = [[NSMutableArray alloc] init];
    
//    [ApplicationDelegate.picturesArray addObject:imageInformationDictionary];
//    NSLog(@"+++ %@", ApplicationDelegate.picturesArray);
//    NSLog(@"=== %@", imageInformationDictionary);
//    NSArray *path2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsPath = [path2 objectAtIndex:0];
//    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"pictures.plist"];
//    [ApplicationDelegate.picturesArray writeToFile:plistPath atomically:YES];
//    [self.picturesCollectionView reloadData];
    if ([[imageInformationDictionary valueForKey:@"Model"] isEqualToString:@"0"]) {
        [ApplicationDelegate.eyelidsPicturesArray addObject:imageInformationDictionary];
        NSLog(@"eyelidsPicturesArray +++ %@", ApplicationDelegate.eyelidsPicturesArray);
        NSLog(@"imageInformationDictionary >>> %@", imageInformationDictionary);
        NSArray *path2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [path2 objectAtIndex:0];
        NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"eyelidsPictures.plist"];
        [ApplicationDelegate.eyelidsPicturesArray writeToFile:plistPath atomically:YES];
        [self.picturesCollectionView reloadData];
    }
    else if ([[imageInformationDictionary valueForKey:@"Model"] isEqualToString:@"1"])
    {
        [ApplicationDelegate.blemishPicturesArray addObject:imageInformationDictionary];
        NSLog(@"blemishPicturesArray +++ %@", ApplicationDelegate.blemishPicturesArray);
        NSLog(@"imageInformationDictionary >>> %@", imageInformationDictionary);
        NSArray *path2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [path2 objectAtIndex:0];
        NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"blemishPictures.plist"];
        [ApplicationDelegate.blemishPicturesArray writeToFile:plistPath atomically:YES];
        [self.picturesCollectionView reloadData];
    }
    else if ([[imageInformationDictionary valueForKey:@"Model"] isEqualToString:@"2"])
    {
        [ApplicationDelegate.firmingPicturesArray addObject:imageInformationDictionary];
        NSLog(@"firmingPicturesArray +++ %@", ApplicationDelegate.firmingPicturesArray);
        NSLog(@"imageInformationDictionary >>> %@", imageInformationDictionary);
        NSArray *path2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [path2 objectAtIndex:0];
        NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"firmingPictures.plist"];
        [ApplicationDelegate.firmingPicturesArray writeToFile:plistPath atomically:YES];
        [self.picturesCollectionView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview滑动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // tableView 下位，根据偏移量计算出下位的高度
    CGFloat downHeight = -scrollView.contentOffset.y;
    // 根据下拉高度计算出 homeView 拉伸的高度
    CGRect picturesViewframe = self.picturesView.frame;
    picturesViewframe.size.height = SCREEN_HEIGHT + downHeight + 64;
    if (downHeight >= 0) {
        self.picturesView.frame = picturesViewframe;
    }
    else
    {
        self.picturesView.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64);
    }
}

- (void)checkCompareNotificationAction
{
    if (ApplicationDelegate.selectedPicturesArray.count == 2) {
        [self.compareButton setEnabled:YES];
        self.compareButton.backgroundColor = [AppUIModel UIViewMainColorII];
    }
    else
    {
        [self.compareButton setEnabled:NO];
        self.compareButton.backgroundColor = [AppUIModel UIUselessColor];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.navigationItem.rightBarButtonItem = editorButton;
    self.takePicturesButton.hidden = NO;
    self.compareButton.hidden = YES;
    self.deleteButton.hidden = YES;
    isInEditor = NO;
    [ApplicationDelegate.selectedPicturesArray removeAllObjects];
    [self.picturesCollectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
