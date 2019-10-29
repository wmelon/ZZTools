//
//  NSString+ZZExtension.m
//  ShallBuyLife
//
//  Created by 刘猛 on 2018/12/10.
//  Copyright © 2018 刘猛. All rights reserved.
//

#import "NSString+ZZExtension.h"
#import <CommonCrypto/CommonDigest.h>

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSString (ZZExtension)


// 判断方法
- (BOOL)isMatches:(NSString *)Regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex];
    return [predicate evaluateWithObject:self];
}

#pragma mark - 文本格式
#pragma mark -- 手机号

/// 判断字符串格式：大陆手机号
- (BOOL)isCNPhoneNumber {
    
    // 字段长度为11；首位为1，第二位为3-9任意数字，其他位为0-9任意数字
    NSString *regex = @"^(1[3-9])\\d{9}$";
    return [self isMatches:regex];
}

/// 判断字符串格式：香港手机号
- (BOOL)isHKPhoneNumber {
    // 长度L为11；以852开头
    NSString *regex = @"^852\\d{8}$";
    return [self isMatches:regex];
}
/// 判断字符串格式：澳门手机号
- (BOOL)isAMPhoneNumber {
    // 长度L为11；以853开头
    NSString *regex = @"^853\\d{8}$";
    return [self isMatches:regex];
}
/// 判断字符串格式：台湾手机号
- (BOOL)isTWPhoneNumber {
    // 长度L为12；以886开头
    NSString *regex = @"^886\\d{9}$";
    return [self isMatches:regex];
}

/**
 *  判断字符串格式是否为手机号
 */
- (BOOL)isPhoneNumber {
    return ([self isCNPhoneNumber] || [self isHKPhoneNumber] || [self isAMPhoneNumber] || [self isTWPhoneNumber]);
}

/**
 *  判断字符串格式是否为座机
 */
- (BOOL)isTelephoneNumber {
    
    if (self.length > 13 || ![self containsString:@"-"]) {
        return NO;
    }
    
    //判断是否包含两个以上的@“-”
    NSArray *array = [self componentsSeparatedByString:@"-"];
    if (array.count > 2) {
        return NO;
    }
    
    NSString *tel = [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return [tel isPureInt] && tel.length > 0 && tel.length <= 12;
    
}

/**
 *  判断手机号服务商，仅限大陆手机号
 */
- (NSString *)checkPhoneBelong {
    // 中国移动
    NSString *cm = @"^1((3[4-9])|(4[78])|(5[012789])|(7[28])|(8[23478])|(98))";
    NSPredicate *predCM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",cm];
    if ([predCM evaluateWithObject:self]) {
        return @"中国移动";
    }
    // 中国电信
    NSString *ct = @"^1((33)|(49)|(53)|(7[37])|(8[019])|(99))";
    NSPredicate *predCT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ct];
    if ([predCT evaluateWithObject:self]) {
        return @"中国电信";
    }
    // 中国联通
    NSString *cu = @"^1((3[0-2])|(4[56])|(5[56])|(66)|(7[56])|(8[56]))";
    NSPredicate *predCU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",cu];
    if ([predCU evaluateWithObject:self]) {
        return @"中国联通";
    }
    return nil;
}

/// 手机号码中插入空格
- (NSString *)addBlankInPhoneNumber {
    if (self.length >= 11) {
        NSString *head = [self substringWithRange:NSMakeRange(0, 3)];
        NSString *center = [self substringWithRange:NSMakeRange(3, 4)];
        NSString *tail = [self substringWithRange:NSMakeRange(7, 4)];
        return [NSString stringWithFormat:@"%@ %@ %@",head,center,tail];
    }
    return self;
}

/// 判断是否是字符串
- (BOOL)validString {
    if (self.length == 0 || self == nil || [self isKindOfClass:[NSNull class]] || self == NULL) {
        return NO;
    }
    return YES;
}

#pragma mark -- 身份证
/// 是否是大陆身份证。这个是最新的刘猛身份证规则，没有newValidateIDNumber:验证的那么复杂
- (BOOL)isChinaIDCard {
    
    if (self.length == 15 && [self isPureInt]) {
        //15位规则： 0-9数字，第9位是0或1
        NSString *string = [self substringWithRange:NSMakeRange(8, 1)];
        return ([string isEqualToString:@"0"] || [string isEqualToString:@"1"]);
    }
    if (self.length == 18) {
        // 18位规则：第11位0或1，最后一位数字或X，其它0-9数字
        NSString *string11 = [self substringWithRange:NSMakeRange(10, 1)];
        BOOL isRight11 = ([string11 isEqualToString:@"0"] || [string11 isEqualToString:@"1"]);
        
        NSString *string18 = [self substringWithRange:NSMakeRange(17, 1)];
        BOOL isRight18 = ([string18 isEqualToString:@"X"] || [string18 isPureInt]);
        
        NSString *stringPrefix17 = [self substringWithRange:NSMakeRange(0, 17)];
        BOOL isRightPrefix17 = [stringPrefix17 isPureInt];
        
        return (isRight11 && isRight18 && isRightPrefix17);
    }
    
    return NO;
}

/** 身份证校验 */
- (BOOL)isIDCardNumber {
    // 判断位数
    if ([self length] != 18) {
        return NO;
    }
    NSString *carid = self;
    long lSumQT = 0;
    // 加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    // 校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    // 将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:self];
    if ([self length] == 15) {
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++) {
            p += (pid[i]-48) * R[i];
        }
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    // 判断地区码
    NSString * sProvince = [carid substringToIndex:2];
    if (![NSString areaCode:sProvince]) {
        return NO;
    }
    // 判断年月日是否有效
    // 年份
    int strYear = [[carid substringWithRange:NSMakeRange(6,4)] intValue];
    // 月份
    int strMonth = [[carid substringWithRange:NSMakeRange(10,2)] intValue];
    // 日
    int strDay = [[carid substringWithRange:NSMakeRange(12,2)] intValue];
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    if (date == nil) {
        return NO;
    }
    const char *PaperId  = [carid UTF8String];
    // 检验长度
    if( 18 != strlen(PaperId)) return -1;
    // 校验数字
    for (int i=0; i<18; i++) {
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) ) {
            return NO;
        }
    }
    // 验证最末的校验码
    for (int i=0; i<=16; i++) {
        lSumQT += (PaperId[i]-48) * R[i];
    }
    if (sChecker[lSumQT%11] != PaperId[17] ) {
        return NO;
    }
    return YES;
    
}

+ (BOOL)areaCode:(NSString *)code {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    if ([dic objectForKey:code] == nil) {
        return NO;
    }
    return YES;
}

// 统一判断是不是港澳台的身份证
- (BOOL)isHKOrAoMenOrTaiWanIDCard {
    return ([self isHongKangIDCard] || [self isAoMenIDCard] || [self isTaiWanIDCard]);
}

// 香港身份证规则：10位：1位大写字母+6位数字+(1位大写字母或数字)
- (BOOL)isHongKangIDCard {
    
    NSString *HKIDType = @"^[A-Z]\\d{6}\\([0-9A-Z]\\)$";
    NSPredicate *HKRegextestID = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", HKIDType];
    return [HKRegextestID evaluateWithObject:self];
}

// 澳门身份证规则：10位：1/5/7任一数字+6位数字++(1位数字)
- (BOOL)isAoMenIDCard {
    
    NSString *AoMenIDType = @"^[157]\\d{6}\\(\\d{1}\\)$";
    NSPredicate *AoMenRegextestID = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", AoMenIDType];
    return [AoMenRegextestID evaluateWithObject:self];
}

// 台湾身份证规则：1位大写字母+9位数字
- (BOOL)isTaiWanIDCard {
    
    NSString *TaiWanIDType = @"^[A-Z]\\d{9}$";
    NSPredicate *TaiWanRegextestID = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", TaiWanIDType];
    return [TaiWanRegextestID evaluateWithObject:self];
}

/// 身份证密文显示：显示后四位，前面用等量的*代替
- (NSString *)idCardEncrypt {
    
    if (self.length <= 4) {
        return self;
    }
    
    NSMutableString *result = [NSMutableString string];
    
    // 前面是*号
    for (int i = 0; i < self.length - 4; i++) {
        [result appendString:@"*"];
    }
    
    // 显示后四位
    [result appendString:[self substringFromIndex:self.length-4]];
    
    return [NSString stringWithString:result];
}

#pragma mark -- 其它格式
/**
 *  判断字符串格式是否为六位数字验证码
 */
- (BOOL)isVerificationCode {
    return [self isMatches:@"^\\d{6}$"];
}

///银行卡
- (BOOL)IsBankCard {
    
    NSString *pattern = @"^\\d{8,21}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [pred evaluateWithObject:self];
    
    //    int oddsum = 0;    //奇数求和
    //    int evensum = 0;    //偶数求和
    //    int allsum = 0;
    //
    //    NSString *cardNumber = [NSString stringWithString:self];
    //    int cardNumberLength = (int)[cardNumber length];
    //    int lastNum = [[cardNumber substringFromIndex:cardNumberLength-1] intValue];
    //    cardNumber = [cardNumber substringToIndex:cardNumberLength -1];
    //    for (int i = cardNumberLength -1 ; i>=1;i--) {
    //        NSString *tmpString = [cardNumber substringWithRange:NSMakeRange(i-1,1)];
    //        int tmpVal = [tmpString intValue];
    //        if (cardNumberLength % 2 ==1 ) {
    //            if((i % 2) == 0){
    //                tmpVal *= 2;
    //                if(tmpVal>=10)
    //                    tmpVal -= 9;
    //                evensum += tmpVal;
    //            }else{
    //                oddsum += tmpVal;
    //            }
    //        }else{
    //            if((i % 2) == 1){
    //                tmpVal *= 2;
    //                if(tmpVal>=10)
    //                    tmpVal -= 9;
    //                evensum += tmpVal;
    //            }else{
    //                oddsum += tmpVal;
    //            }
    //        }
    //    }
    //    allsum = oddsum + evensum;
    //    allsum += lastNum;
    //    if((allsum % 10) ==0)
    //        return YES;
    //    else
    //        return NO;
    
}

- (BOOL)isValidUrl {
    NSString *regex =@"(https|http|ftp|rtsp|igmp|file|rtspt|rtspu)://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

- (BOOL)isEmail {
    NSString *regex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}
///判断是否是邮箱允许的字符类型
- (BOOL)isEmailAllowString {
    NSString *match = @"^[A-Z0-9a-z._@\\-]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}


- (BOOL)isPureInt {
    
    NSString *match = @"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isChinese {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)containsChinese {
    for(int i=0; i< [self length];i++) {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

/// 是否含表情字符
- (BOOL)containsEmoji {
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar hs = [substring characterAtIndex:0];
                              if (0xd800 <= hs && hs <= 0xdbff) {
                                  if (substring.length > 1) {
                                      const unichar ls = [substring characterAtIndex:1];
                                      const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                      if (0x1d000 <= uc && uc <= 0x1f77f) {
                                          returnValue = YES;
                                      }
                                  }
                              } else if (substring.length > 1) {
                                  const unichar ls = [substring characterAtIndex:1];
                                  if (ls == 0x20e3) {
                                      returnValue = YES;
                                  }
                              } else {
                                  if (0x2100 <= hs && hs <= 0x27ff) {
                                      returnValue = YES;
                                  } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                      returnValue = YES;
                                  } else if (0x2934 <= hs && hs <= 0x2935) {
                                      returnValue = YES;
                                  } else if (0x3297 <= hs && hs <= 0x3299) {
                                      returnValue = YES;
                                  } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                      returnValue = YES;
                                  }
                              }
                          }];
    return returnValue;
}

#pragma mark -- 刘猛专用格式
/**
 *  新规则：密码规则6-20位：字母和数字的组合
 */
- (BOOL)isNewPassword {
    
    NSString *regex = @"^[A-Za-z0-9]{6,20}$";
    return [self isMatches:regex];
}

/**
 *  密码规则6-32位：A-Za-z0-9@-_.
 */
- (BOOL)isPasswordFormat {
    
    if (self.length == 0 || self == nil) {
        return NO;
    }
    if (self.length < 6 || self.length > 20) {
        return NO;
    }
    NSCharacterSet *charset = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@-_."] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:charset] componentsJoinedByString:@""];
    return ![self isEqualToString:filtered];
}

/**
 *  验证密码复杂度，必须是字母，数字，字符两种以上,前提是isPasswordFormat
 */
- (BOOL)isPasswordComplexity {
    
    NSInteger count = 0;
    
    NSString *characters = @"~!@#$%^&*-_.";
    NSString *numbers = @"0123456789";
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    BOOL hasLetter = NO;
    BOOL hasNumber = NO;
    BOOL hasCharacter = NO;
    
    for (NSInteger i = 0; i < self.length; i++) {
        NSString *temp = [self substringWithRange:NSMakeRange(i, 1)];
        
        if ([letters containsString:temp]) {
            // 是不是第一个字母
            if (hasLetter == NO) {
                hasLetter = YES;
                count ++;
            }
        }else if ([numbers containsString:temp]) {
            // 是不是第一个数字
            if (hasNumber == NO) {
                hasNumber = YES;
                count ++;
            }
        }else if ([characters containsString:temp]) {
            // 是不是第一个字符
            if (hasCharacter == NO) {
                hasCharacter = YES;
                count ++;
            }
        }
        
        if (count >= 2) {
            return YES;
        }
    }
    
    return NO;
}

/**
 *  判断是否是商家账号 a-zA-z0-9\u4e00-\u9fa5_- 3到15位，不可数字开头
 */
- (BOOL)isMerchantAccount {
    
    if (self.length < 3 || self.length > 15) {
        return NO;
    }
    
    if ([self isPureInt] == NO) {
        
        NSString *pattern = @"^[A-Za-z\u4e00-\u9fa5][A-Za-z0-9\u4e00-\u9fa5\\_\\-]{2,14}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
        return [pred evaluateWithObject:self];
    }
    
    
    return YES;
}

/**
 *  判断是否是店铺名称 a-zA-z0-9\u4e00-\u9fa5_-(). 3到20位，除非纯数字，不可数字特殊字符开头
 */
- (BOOL)isMerchantName {
    if (self.length < 3 || self.length > 20) {
        return NO;
    }
    
    if ([self isPureInt] == NO) {
        
        NSString *pattern = @"^[A-Za-z\u4e00-\u9fa5][A-Za-z0-9\u4e00-\u9fa5\\_\\-\\.\\(\\)]{2,19}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
        return [pred evaluateWithObject:self];
    }
    
    return YES;
}


///判断是否是联系人。中英文和· 长度2-25
- (BOOL)isNameString {
    
    NSString *match = @"^[\u4e00-\u9fa5A-Za-z·]{2,25}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return (self.length >= 2 && self.length <= 25 && [predicate evaluateWithObject:self]);
}

///判断是否是详细地址。中英文数字和空格
- (BOOL)isDetailAddress {
    
    return self.length <= 50;
    //    NSString *match = @"^[\u4e00-\u9fa5A-Za-z0-9 -]+$";
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    //    return [predicate evaluateWithObject:self];
}

///判断是否是物流单号
- (BOOL)isLogisticOrdersn {
    NSString *regex =@"[A-Z0-9]{8,20}";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}


#pragma mark - security

+ (NSString *)getUUID {
    CFUUIDRef uuid_ref = CFUUIDCreate(nil);
    CFStringRef uuid_string_ref = CFUUIDCreateString(nil, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString * _Nonnull)(uuid_string_ref)];
    CFRelease(uuid_string_ref);
    return uuid;
}

- (NSString *)MD5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call
    return [[NSString stringWithFormat:
             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

- (NSString *)base64EncodedString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodedString {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
//base64 NSData
- (NSString *)base64EncodedStringFromData:(NSData *)data {
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length]) {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

#pragma mark - 其它
+ (NSString *)zz_getSingletonStringWithLength:(int)lentgh {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 10];
    for (NSInteger i = 0; i < lentgh; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % 62]];
    }
    return randomString;
}

/** 汉字转拼音
 *
 */
- (NSString *)chineseToPinYin {
    
    NSMutableString *pinYin = [self mutableCopy];
    
    // 先 kCFStringTransformMandarinLatin  转换成带声调的拼音
    // 再 kCFStringTransformStripDiacritics  去掉声调
    CFStringTransform((__bridge CFMutableStringRef)pinYin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinYin, NULL, kCFStringTransformStripDiacritics, NO);
    
    return pinYin;
}

/** 获取首字母大写
 *
 *  @return 获取失败返回nil
 */
- (NSString *)firstUppercaseLetter {
    
    NSString *pinYin = [self chineseToPinYin];
    NSString *firstLetter = nil;
    
    if (pinYin && pinYin.length > 0) {
        firstLetter = [[pinYin uppercaseString] substringToIndex:1];
    }else if (self.length > 0){
        firstLetter = [[self uppercaseString] substringToIndex:1];
    }
    
    return firstLetter;
}

#pragma mark - 字符串过滤
//过滤
- (NSString *)filterCharactorWithRegex:(NSString *)regexString {
    NSString *searchText = self;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}

/// 过滤其它字符 regex:允许的字符 maxLength:最大长度，超出了截取前面的部分
- (NSString *)filterCharactorWithRegex:(NSString *)regex maxLength:(NSInteger)maxLength {
    
    NSString *string = [self filterCharactorWithRegex:regex];
    
    if (maxLength > 0 && string.length > maxLength) {
        string = [string substringToIndex:maxLength];
    }
    return string;
}

/// 过滤非姓名字符 中英文和· 长度2-25
- (NSString *)filterNameString {
    
    return [self filterCharactorWithRegex:@"[^\u4e00-\u9fa5A-Za-z·]" maxLength:25];
}

/// 过滤非大陆身份证号字符 数字和xX 长度最高18
- (NSString *)filterIdCardString {
    
    NSString *result = [self filterCharactorWithRegex:@"[^0-9xX]" maxLength:18];
    return [result uppercaseString];
}

/// 过滤所有身份证号字符 字母数字() 长度最高18
- (NSString *)filterAllIdCardString {
    return [self filterCharactorWithRegex:@"[^A-Za-z0-9\\(\\)]" maxLength:18];
}

#pragma mark - 字符串截取
+ (NSString *)getNumberFromStr:(NSString *)str {
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return[[str componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

//支付方式匹配
+ (NSString *)payTypeChange:(int)val {
    NSString *typeName = [[NSString alloc] init];
    switch (val) {
        case 1:
            typeName = @"支付宝充值";
            break;
        case 11:
            typeName = @"返利充值";
            break;
        case 12:
            typeName = @"后台充值";
            break;
        case 13:
            typeName = @"后台扣款";
            break;
        case 2:
            typeName = @"预存款支付";
            break;
        case 21:
            typeName = @"即时到帐支付";
            break;
        case 22:
            typeName = @"微信支付";
            break;
        case 3:
            typeName = @"订单退款";
            break;
        case 31:
            typeName = @"汇商通退款";
            break;
        case 32:
            typeName = @"微信退款";
            break;
        case 4:
            typeName = @"预存款提现";
            break;
        case 5:
            typeName = @"提现失败返款";
            break;
        case 6:
            typeName = @"银联支付";
            break;
        case 7:
            typeName = @"农行支付";
            break;
        default:
            typeName = @"未知状态";
            break;
    }
    return typeName;
}

@end
