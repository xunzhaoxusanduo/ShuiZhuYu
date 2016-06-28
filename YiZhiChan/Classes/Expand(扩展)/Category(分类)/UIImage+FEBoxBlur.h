//
//  UIImage+FEBoxBlur.h
//  iOS-UIImageBoxBlur
//http://indieambitions.com/idevblogaday/perform-blur-vimage-accelerate-framework-tutorial/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+IndieAmbitions+%28Indie+Ambitions%29
//  Created by keso on 16/1/14.
//  Copyright © 2016年 FlyElephant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>

@interface UIImage (FEBoxBlur)
/**
 *  CoreImage图片高斯模糊
 *
 *  @param image 图片
 *  @param blur  模糊数值(默认是10)
 *
 *  @return 重新绘制的新图片
 */

+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
/**
 *  vImage模糊图片
 *
 *  @param image 原始图片
 *  @param blur  模糊数值(0-1)
 *
 *  @return 重新绘制的新图片
 */
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

+ (UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

/**
 *  根据指定的高度生成一副与原始图片比例相同的图片
 *
 *  @param name        图片的名字
 *  @param imageHeight 指定的高度
 *
 *  @return 生成的图片对象
 */
+ (UIImage *)scaleAspectFitHeightImageWithName:(NSString *)name imageHeight:(CGFloat)imageHeight;

/**
 *  根据指定的高度生成一副与原始图片比例相同的图片
 *
 *  @param image       图片对象
 *  @param imageHeight 指定的高度
 *
 *  @return 生成的图片对象
 */
+ (UIImage *)scaleAspectFitHeightImageWithImage:(UIImage *)image imageHeight:(CGFloat)imageHeight;

/**
 *  根据指定的宽度生成一副与原始图片比例相同的图片
 *
 *  @param name       图片的名字
 *  @param imageWidth 指定的宽度
 *
 *  @return 生成的图片对象
 */
+ (UIImage *)scaleAspectFitWidthImageWithName:(NSString *)name imageWidth:(CGFloat)imageWidth;

/**
 *  根据指定的宽度生成一副与原始图片比例相同的图片
 *
 *  @param image       图片对象
 *  @param imageWidth 指定的宽度
 *
 *  @return 生成的图片对象
 */
+ (UIImage *)scaleAspectFitWidthImageWithImage:(UIImage *)image imageWidth:(CGFloat)imageWidth;

@end
