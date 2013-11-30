//
//  KKText.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-07-30.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKText.h"
#import "TwitterText.h"

@implementation KKText

- (NSDictionary *)linkAttributes {
  return @{NSForegroundColorAttributeName:[UIColor kk_linkColor]};
}

- (NSDictionary *)activeLinkAttributes {
  return @{NSForegroundColorAttributeName:[UIColor kk_activeLinkColor]};
  /*
  @{
    NSForegroundColorAttributeName:[UIColor kk_activeLinkColor],
    kTTTBackgroundFillColorAttributeName:(id)[UIColor kk_activeLinkBackgroundColor].CGColor,
    kTTTBackgroundCornerRadiusAttributeName:@2,
    kTTTBackgroundFillPaddingAttributeName:[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(-2.f, 1.f, -2.f, 1.f)]
    }
   */
}

+ (KKText *)intoText {
  KKText *text = [KKText new];
  
  NSString *string = @"Kortkoll är en tjänst som låter dig få koll på ditt SL Access-kort snabbt och smidigt. Om du inte har ett konto, besök då Mitt SL och skapa ett kostnadsfritt.\n\nDen här tjänsten är helt utvecklad utanför SLs väggar och lämnar därför inga garantier på stabilitet.";
  
  NSMutableAttributedString *attributedString  = [text _defaultAttributedStringForString:string];
  [text setAttributedString:attributedString];
  
  // Links
  NSMutableDictionary *links = [NSMutableDictionary new];
  [links setObject:[NSURL URLWithString:@"https://sl.se/sv/Resenar/Mitt-SL/Skapa-konto/"]
            forKey:[NSValue valueWithRange:[string rangeOfString:@"Mitt SL"]]];
  
  [text setLinks:links];
  
  return text;
}

+ (KKText *)infoText {
  KKText *text = [KKText new];
  
  NSString *string = @"Kortkoll är en tjänst som låter dig få koll på ditt SL Access-kort snabbt och smidigt. Om du inte har ditt kort här, besök då Mitt SL och registrera ett.\n\nDen här tjänsten är helt utvecklad utanför SLs väggar och lämnar därför inga garantier på stabilitet. Om du gillar den, skriv då gärna en recension på App Store.\n\nFör support, frågor, förbättringsförslag eller bara för att snacka lite skit, hör av dig till @kortkoll eller facebook.com/Kortkoll.\n\nSkapad av @blommegard, @gellermark, @peterssonjesper och @wibron.";
  
  NSMutableAttributedString *attributedString  = [text _defaultAttributedStringForString:string];
  [text setAttributedString:attributedString];
    
  // Links
  NSMutableDictionary *links = [NSMutableDictionary new];
  [links setObject:[NSURL URLWithString:@"https://sl.se/sv/Resenar/Mitt-SL/"]
            forKey:[NSValue valueWithRange:[string rangeOfString:@"Mitt SL"]]];
  
  [links setObject:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=681422117"]
            forKey:[NSValue valueWithRange:[string rangeOfString:@"App Store"]]];
  
  [links setObject:[NSURL URLWithString:@"https://facebook.com/Kortkoll"]
            forKey:[NSValue valueWithRange:[string rangeOfString:@"facebook.com/Kortkoll"]]];
  
  for (TwitterTextEntity *entity in [TwitterText mentionedScreenNamesInText:string]) {
    NSString *URLString = [NSString stringWithFormat:@"twitter://user?screen_name=%@", [string substringWithRange:NSMakeRange(entity.range.location+1, entity.range.length-1)]]; // remove @
    [links setObject:[NSURL URLWithString:URLString]
              forKey:[NSValue valueWithRange:entity.range]];
  }
  
  [text setLinks:links];
  
  return text;
}

- (NSMutableAttributedString *)_defaultAttributedStringForString:(NSString *)string {
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
  
  NSRange stringRange = NSMakeRange(0, string.length);
  
  // Paragraph style
  NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  [paragraphStyle setMinimumLineHeight:12.f];
  
  [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:stringRange];
  
  // Font
  [attributedString addAttribute:NSFontAttributeName value:[UIFont kk_regularFontWithSize:12.f] range:stringRange];
  
  // Color
  [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor kk_darkTextColor] range:stringRange];
  
  return attributedString;
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
  if (![[UIApplication sharedApplication] openURL:url]) {
    if ([url.scheme isEqualToString:@"twitter"]) {
      NSString *name = [url.query substringFromIndex:12];
      
      NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///user_profile/%@", name]];
      
      if ([[UIApplication sharedApplication] openURL:URL])
        return;
      
      URL = [NSURL URLWithString:[NSString stringWithFormat:@"twitterrific:///profile?screen_name=%@", name]];
      
      if ([[UIApplication sharedApplication] openURL:URL])
        return;
      
      URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@", name]];
      [[UIApplication sharedApplication] openURL:URL];
    } else if ([url.scheme isEqualToString:@"fb"]) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://facebook.com/Kortkoll"]];
    }
  }
}

@end
