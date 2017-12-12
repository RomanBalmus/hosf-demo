//
//  HostariaDescriptionCell.m
//  Hostaria
//
//  Created by iOS on 10/03/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "HostariaDescriptionCell.h"
#import "UIView+Fold.h"
@interface HostariaDescriptionCell ()
@end

@implementation HostariaDescriptionCell
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib{
    NSLog(@"awake descr cell");
    
    
    [super awakeFromNib];
    self.topView.selectiveBorderFlag = AUISelectiveBordersFlagBottom;
    self.topView.selectiveBordersColor = [UIColor blackColor];
    self.topView.selectiveBordersWidth = 1.0;
    /*for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"family:%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"name:%@", name);
        }
    }*/
   /* self.stackView.arrangedSubviews.firstObject.selectiveBorderFlag = AUISelectiveBordersFlagBottom | AUISelectiveBordersFlagTop | AUISelectiveBordersFlagLeft |AUISelectiveBordersFlagRight;
    self.stackView.arrangedSubviews.firstObject.selectiveBordersColor = [UIColor blackColor];
    self.stackView.arrangedSubviews.firstObject.selectiveBordersWidth = 1.0;*/
    
   // self.stackView.arrangedSubviews.lastObject.hidden = YES;

 /*   NSError* error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource: @"host_descr_2" ofType: @"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile: path encoding:NSUTF8StringEncoding error: &error];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.descriptionLabel.userInteractionEnabled = NO;
    self.descriptionLabel.opaque = NO;
    self.descriptionLabel.backgroundColor = [UIColor clearColor];
    [self.descriptionLabel setAttributedText:attributedString];*/
    //self.descriptionLabel.delegate=self;
    //[self.descriptionLabel loadHTMLString:htmlString baseURL:nil];
    //self.descriptionLabel.contentMode = UIViewContentModeScaleAspectFit;
    //self.descriptionLabel.scalesPageToFit = YES;


    //[self.descriptionLabel loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"host_descr_2" ofType:@"html"]isDirectory:NO]]];
}

/*-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

}*/

-(void)changeCellStatus:(BOOL)status{
    [self setNeedsLayout];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.stackView.arrangedSubviews.lastObject.hidden = !status;
    } completion:^(BOOL finished) {
        [self layoutIfNeeded];
        if ([delegate respondsToSelector:@selector(changedStatus:atIndexPath:)]) {
            [delegate changedStatus:status atIndexPath:self];
        }
    }];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
   // self.descriptionLabel.contentMode = UIViewContentModeScaleAspectFit;
   // self.descriptionLabel.scalesPageToFit = YES;
}
/*- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    CGRect frame = self.descriptionLabel.frame;
    NSString *heightStrig = [self.descriptionLabel stringByEvaluatingJavaScriptFromString:@"(document.height !== undefined) ? document.height : document.body.offsetHeight;"];
    float height = heightStrig.floatValue + 10.0;
    frame.size.height = height;
    self.descriptionLabel.frame = frame;
}*/
/*- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    UICollectionViewLayoutAttributes *attributes = [layoutAttributes copy];
    float desiredWidth = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
    CGRect frame = attributes.frame;
    frame.size.width = desiredWidth;
    frame.size.height = frame.size.height+50;
    attributes.frame = frame;
    
    return attributes;
}*/
@end
