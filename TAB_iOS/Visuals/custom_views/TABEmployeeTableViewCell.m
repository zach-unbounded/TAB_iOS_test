//
//  TABEmployeeTableViewCell.m
//  TAB_iOS
//
//  Created by Zachary BURGESS on 02/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

#import "TABEmployeeTableViewCell.h"
#import "TABEmplyeeDataProvider.h"
#import "TABEmployee.h"

@interface TABEmployeeTableViewCell ()

@property (assign,nonatomic) CGFloat hight;

@end

@implementation TABEmployeeTableViewCell

+ (NSString *)reuseIdentifier {
    return @"CELL";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setEmployee:(TABEmployee*)paramEmployee {
    self.name_lbl.text = paramEmployee.name;
    self.title_lbl.text = paramEmployee.title;
    self.miniBio_lbl.text = paramEmployee.miniBio;
    [self layoutSubviews];
    self.image_img.image = [UIImage imageNamed:@"default_original_profile"];
    [[TABEmplyeeDataProvider sharedInstance] getImageForURL:paramEmployee.image withCompleation:^(UIImage * paramImage, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image_img.image = paramImage;
        });
    }];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat bioHeight = [TABEmployeeTableViewCell getSizeOfText:self.miniBio_lbl.text withFont:self.miniBio_lbl.font].height;
    
    //First expand the label to a large height to so sizeToFit isn't constrained
    [self.miniBio_lbl setFrame:CGRectMake(self.miniBio_lbl.frame.origin.x,
                                                       self.miniBio_lbl.frame.origin.y,
                                                       self.miniBio_lbl.frame.size.width,
                                                       bioHeight)];
    
    //let sizeToFit do its magic
    [self.miniBio_lbl sizeToFit];
    
    //resize the cell to encompass the newly expanded label
    [self setFrame:CGRectMake(self.frame.origin.x,
                              self.frame.origin.y,
                              self.frame.size.width,
                              self.height)];
}

- (CGFloat)height {
    CGFloat bioHeight = [TABEmployeeTableViewCell getSizeOfText:self.miniBio_lbl.text withFont:self.miniBio_lbl.font].height;
    return bioHeight + 220.0f;
}

+ (CGFloat)cellHeightWithBioText:(NSString*)paramText {
    UIFont * bioFont = [UIFont fontWithName:@"Al Nile" size:12.0f];
    CGFloat bioHeight = [TABEmployeeTableViewCell getSizeOfText:paramText withFont:bioFont].height;
    return bioHeight + 220.0f;
}

+ (CGSize)getSizeOfText:(NSString *)paramText withFont:(UIFont *)paramFont {
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:paramText attributes:@{NSFontAttributeName:paramFont}];
    return [attributedText boundingRectWithSize:(CGSize){320.0f, CGFLOAT_MAX}
                                 options:NSStringDrawingUsesLineFragmentOrigin
                                 context:nil].size;
}

@end
