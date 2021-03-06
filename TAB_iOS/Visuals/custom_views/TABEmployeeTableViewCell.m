//
//  TABEmployeeTableViewCell.m
//  TAB_iOS
//
//  Created by Zachary BURGESS on 02/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TABEmployeeTableViewCell.h"
#import "TABEmplyeeDataProvider.h"
#import "TABEmployee.h"

static NSString * const TABDefaultProfileImageName  = @"default_original_profile";
static NSString * const TABFontName                 = @"Al Nile";

static CGFloat const TABBasicCellHight              = 220.0f;
static CGFloat const TABFontHight                   = 12.0f;
static CGFloat const TABScreenWidth                 = 320.0f;

@interface TABEmployeeTableViewCell ()

@end

@implementation TABEmployeeTableViewCell

+ (NSString *)reuseIdentifier {
    return @"CELL";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateCellWithEmployee:(TABEmployee*)paramEmployee {
    self.name_lbl.text = paramEmployee.name;
    self.title_lbl.text = paramEmployee.title;
    self.miniBio_lbl.text = paramEmployee.miniBio;
    [self layoutSubviews];
    self.image_img.image = [UIImage imageNamed:TABDefaultProfileImageName];
    
    self.image_img.layer.borderWidth = 0;
    self.image_img.layer.borderColor = [UIColor clearColor].CGColor;
    self.image_img.layer.cornerRadius = self.image_img.frame.size.width / 2;
    self.image_img.layer.masksToBounds = NO;
    self.image_img.clipsToBounds = YES;
    
    [[TABEmplyeeDataProvider sharedInstance] getImageForURL:paramEmployee.image withCompleation:^(UIImage * paramImage, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image_img.image = paramImage;
        });
    }];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat bioHeight = [TABEmployeeTableViewCell getSizeOfText:self.miniBio_lbl.text withFont:self.miniBio_lbl.font].height;
    [self.miniBio_lbl setFrame:CGRectMake(self.miniBio_lbl.frame.origin.x,
                                          self.miniBio_lbl.frame.origin.y,
                                          self.miniBio_lbl.frame.size.width,
                                          bioHeight)];
    [self.miniBio_lbl sizeToFit];
    [self setFrame:CGRectMake(self.frame.origin.x,
                              self.frame.origin.y,
                              self.frame.size.width,
                              self.height)];
}

- (CGFloat)height {
    CGFloat bioHeight = [TABEmployeeTableViewCell getSizeOfText:self.miniBio_lbl.text withFont:self.miniBio_lbl.font].height;
    return bioHeight + TABBasicCellHight;
}

+ (CGFloat)cellHeightWithBioText:(NSString*)paramText {
    UIFont * bioFont = [UIFont fontWithName:TABFontName size:TABFontHight];
    CGFloat bioHeight = [TABEmployeeTableViewCell getSizeOfText:paramText withFont:bioFont].height;
    return bioHeight + TABBasicCellHight;
}

+ (CGSize)getSizeOfText:(NSString *)paramText withFont:(UIFont *)paramFont {
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:paramText attributes:@{NSFontAttributeName:paramFont}];
    return [attributedText boundingRectWithSize:(CGSize){TABScreenWidth, CGFLOAT_MAX}
                                 options:NSStringDrawingUsesLineFragmentOrigin
                                 context:nil].size;
}

@end
