//
//  XYGoodsTableViewCell.m
//  XianYu
//
//  Created by YuanZhihao on 6/23/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYGoodsTableViewCell.h"
#import "XYHomeGoodsFrame.h"
#import "XYHomeGoodsModel.h"
#import "NSString+Extension.h"
#import "UIView+LBExtension.h"
#import "UIImageView+WebCache.h"

//颜色
#define XYColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//定位颜色
#define LocateColor XYColor(61,181,230)

#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define CellPadding 10
#define PicturePadding 5
#define PictureHeight (SCREEN_WIDTH - CellPadding * 2 - 2 * PicturePadding) / 3

@interface XYGoodsTableViewCell ()
@property (nonatomic,weak) UIView *backView;
@property (nonatomic,weak) UILabel *nicknameLabel;
@property (nonatomic,weak) UILabel *priceView;
@property (nonatomic,weak) UILabel *dateLabel;
@property (nonatomic,weak) UILabel *contentLabel;
@property (nonatomic,weak) UIButton *locateButton;
@property (nonatomic,weak) UIButton *accessButton;
@property (nonatomic,weak) UIView *photosView;
@end

@implementation XYGoodsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    //NSLog(@"%s", __func__);
    //[_backView setBackgroundColor:[UIColor grayColor]];
    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Trends";
    XYGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[XYGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.opaque = YES;
        
        [self createGoodsView];
    }
    return self;
}

-(void)createGoodsView
{
    UIView *backgroundView= [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    /*backgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    backgroundView.layer.shadowOffset = CGSizeMake(0, 0);
    backgroundView.layer.shadowOpacity = 0.5;*/
    
    [self.contentView addSubview:backgroundView];
    self.backView = backgroundView;
    
    UIImageView *icon = [[UIImageView alloc] init];
    [backgroundView addSubview:icon];
    icon.userInteractionEnabled = YES;
    self.iconView = icon;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    [icon addGestureRecognizer:recognizer];
    
    UILabel *nickname = [[UILabel alloc] init];
    nickname.textColor = [UIColor blackColor];
    nickname.font = [UIFont systemFontOfSize:14];
    [backgroundView addSubview:nickname];
    self.nicknameLabel = nickname;
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.textColor = [UIColor lightGrayColor];
    dateLabel.font = [UIFont systemFontOfSize:12];
    [backgroundView addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [backgroundView addSubview:priceLabel];
    self.priceView = priceLabel;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 2;
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.textColor = [UIColor blackColor];
    [backgroundView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    UIView *photosView = [[UIView alloc] init];
    [backgroundView addSubview:photosView];
    self.photosView = photosView;
    
    
    UIButton *locateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [locateBtn setImage:[UIImage imageNamed:@"my_city_position_green"] forState:UIControlStateNormal];
    [locateBtn setTitleColor:LocateColor forState:UIControlStateNormal];
    locateBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [locateBtn addTarget:self action:@selector(locateDidClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:locateBtn];
    self.locateButton = locateBtn;
    
    
    UIButton *accessButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [accessButton setBackgroundImage:[UIImage imageNamed: @"meta_action"] forState:UIControlStateNormal];
    [accessButton addTarget:self action:@selector(accessBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    accessButton.size = accessButton.currentBackgroundImage.size;
    [backgroundView addSubview:accessButton];
    self.accessButton = accessButton;
}

-(void)setGoodsFrame:(XYHomeGoodsFrame *)goodsFrame
{
    _goodsFrame = goodsFrame;
    XYHomeGoodsModel *goodsModel = goodsFrame.goodsModel;
    
    self.backView.frame = goodsFrame.backgroundView;
    
    self.iconView.frame = goodsFrame.iconView;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:goodsModel.icon] placeholderImage:[UIImage imageNamed:@"avatar_placehold"]];
    
    self.nicknameLabel.frame = goodsFrame.nicknameLabel;
    self.nicknameLabel.text = goodsModel.nickname;
    
    self.priceView.frame = goodsFrame.priceLabel;
    self.priceView.text = goodsModel.price;
    self.priceView.textColor = [UIColor redColor];
    
    
    self.dateLabel.frame = goodsFrame.dateLabel;
    self.dateLabel.text = [NSString addtime:goodsModel.date];
    
    if (goodsModel.pictures.count>0) {
        
        CGFloat width = 0.0;
        
        if (goodsModel.pictures.count == 1) {
            width = PictureHeight*2+PicturePadding;
        }
        else {
            width = PictureHeight;
        }
        
        [goodsModel.pictures enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:@"placeholder240x240"]];
            imageView.frame= CGRectMake(idx * PictureHeight + idx * PicturePadding, 0, width, PictureHeight);
            [self.photosView addSubview:imageView];
        }];
        self.photosView.hidden = NO;
        self.photosView.frame = goodsFrame.picturesView;
    }else{
        self.photosView.hidden = YES;
    }
    
    self.contentLabel.frame = goodsFrame.contentLabel;
    self.contentLabel.text = goodsModel.content;
    
    self.locateButton.frame = goodsFrame.locationButton;
    
    [self.locateButton setTitle:[NSString stringWithFormat:@"来自%@",goodsModel.location] forState:UIControlStateNormal];
    
    self.accessButton.frame = goodsFrame.accessButton;
}

-(void)locateDidClickEvent:(UIButton *)btn
{
    NSIndexPath *path = [[self tableView]indexPathForCell:self];
    if (self.OnMyButtonClick) {
        _OnMyButtonClick(path);
    }
}

-(void)accessBtnDidClick:(UIButton *)btn
{
    NSIndexPath *path = [[self tableView]indexPathForCell:self];
    if (self.OnMyButtonClick) {
        _OnMyButtonClick(path);
    }
}

- (void)tapImage:(UITapGestureRecognizer *)recognizer {
    NSLog(@"触碰头像");
}

@end
