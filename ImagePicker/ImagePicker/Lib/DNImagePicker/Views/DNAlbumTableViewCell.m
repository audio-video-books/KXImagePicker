//
//  DNAlbumTableViewCell.m
//  ZhiMaBaoBao
//
//  Created by mac on 17/4/10.
//  Copyright © 2017年 liugang. All rights reserved.
//

#import "DNAlbumTableViewCell.h"
#import "DNImagePickerHeader.h"

@implementation DNAlbumTableViewCell {
    UIImageView *_albumImageView;
    UILabel *_titleLable;
    UIView *_lineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _albumImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Image_placeHolder"]];
    _albumImageView.contentMode = UIViewContentModeScaleAspectFill;
    _albumImageView.clipsToBounds = YES;
    [self addSubview:_albumImageView];
    
    _titleLable = [UILabel new];
    [self addSubview:_titleLable];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorFormHexRGB:@"e5e5e5"];
    [self addSubview:_lineView];
}

- (void)setModel:(DNImageCollectionModel *)model {
    _model = model;
    
    
    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:model.collection options:nil];
    
    NSMutableArray *countArray = [NSMutableArray array];
    if (model.collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumVideos) {
        for (PHAsset *videoAsset in fetchResult) {
            if (videoAsset.mediaType == PHAssetMediaTypeVideo && videoAsset.mediaSubtypes != PHAssetMediaSubtypeVideoHighFrameRate && videoAsset.duration <= VideoMaxTimeInterval) {
                [countArray addObject:videoAsset];
            }
        }
    } else {
        for (PHAsset *photoAsset in fetchResult) {
            if (photoAsset.mediaType == PHAssetMediaTypeImage) {
                [countArray addObject:photoAsset];
            }
        }
    }
    
    NSString *targetStr = [NSString stringWithFormat:@"%@（%zd）",model.collectionTitle,countArray.count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:targetStr];
    [str setAttributes:@{NSForegroundColorAttributeName : [UIColor colorFormHexRGB:@"333333"],NSFontAttributeName : [UIFont systemFontOfSize:15]} range:[targetStr rangeOfString:model.collectionTitle]];
    
    _titleLable.attributedText = str;
    
    //从相册中取出第一张图片
    PHAsset *asset = fetchResult.lastObject;
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    option.synchronous = YES;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(60, 60) contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {   //成功获取图片，添加到数组里
            _albumImageView.image = result;
        } else {        //若失败，则加载一张站位图
            _albumImageView.image = [UIImage imageNamed:@"Image_placeHolder"];
        }
    }];
}


- (void)layoutSubviews {
    CGFloat imageWH = CGRectGetHeight(self.frame) - 2;
    _albumImageView.frame = CGRectMake(12, (CGRectGetHeight(self.frame) - imageWH) * 0.5, imageWH, imageWH);
    
    CGFloat titleX = CGRectGetMaxX(_albumImageView.frame) + 12;
    _titleLable.frame = CGRectMake(titleX, 0, CGRectGetWidth(self.frame) - titleX , imageWH);
    
    _lineView.frame = CGRectMake(12, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame) - 12, 0.5);
}

@end
