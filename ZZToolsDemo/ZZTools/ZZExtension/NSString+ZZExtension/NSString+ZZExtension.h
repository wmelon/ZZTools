//
//  NSString+ZZExtension.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 2018/12/10.
//  Copyright © 2018 刘猛. All rights reserved.
//
//  类别,具体用法查看具体公开方法的单独注释
//

#import <Foundation/Foundation.h>

@interface NSString (ZZExtension)

#pragma mark - 文本格式
#pragma mark -- 手机号

/// 判断字符串格式：大陆手机号。不包含区号86
- (BOOL)isCNPhoneNumber;
/// 判断字符串格式：香港手机号。必须包含区号852
- (BOOL)isHKPhoneNumber;
/// 判断字符串格式：澳门手机号。必须包含区号853
- (BOOL)isAMPhoneNumber;
/// 判断字符串格式：台湾手机号。必须包含区号886
- (BOOL)isTWPhoneNumber;

/// 判断字符串格式：手机号，包含大陆手机号(不以区号86开头)，港澳台(以区号开头)
- (BOOL)isPhoneNumber;

/// 判断字符串格式：座机
- (BOOL)isTelephoneNumber;

/// 判断是否是字符串
- (BOOL)validString;

/**
 *  判断手机号服务商，仅限大陆手机号
 *  @return @"中国移动"@"中国联通"@"中国电信"nil
 */
- (NSString *)checkPhoneBelong;

/// 手机号码中插入空格
- (NSString *)addBlankInPhoneNumber;

#pragma mark -- 身份证
/// 是否是大陆身份证。这个是最新的刘猛身份证规则，没有newValidateIDNumber验证的那么复杂
- (BOOL)isChinaIDCard;
/**
 是否为合法身份证,判断了地区，生日等具体信息
 */
- (BOOL)isIDCardNumber;

// 统一判断是不是港澳台的身份证
- (BOOL)isHKOrAoMenOrTaiWanIDCard;
- (BOOL)isHongKangIDCard;
- (BOOL)isAoMenIDCard;
- (BOOL)isTaiWanIDCard;
/// 身份证密文显示：显示后四位，前面用等量的*代替
- (NSString *)idCardEncrypt;

#pragma mark -- 其它格式
/**
 *  判断字符串格式：六位数字验证码
 */
- (BOOL)isVerificationCode;

/**
 是否为银行卡 8-21位数字
 */
- (BOOL)IsBankCard;

/// 判断是否是有效的url地址
- (BOOL)isValidUrl;
/// 是否是email
- (BOOL)isEmail;
/// 判断是否是邮箱允许输入的字符
- (BOOL)isEmailAllowString;

/// 判断是否是纯数字
- (BOOL)isPureInt;
/// 判断是否是纯汉字
- (BOOL)isChinese;
/// 判断是否含有汉字
- (BOOL)containsChinese;
/// 是否含Emoji字符
- (BOOL)containsEmoji;

#pragma mark -- 刘猛专用格式
/**
 *  新规则：密码规则6-20位：字母和数字的组合
 */
- (BOOL)isNewPassword;

/**
 *  旧规则：密码规则6-32位：A-Za-z0-9@-_.
 */
- (BOOL)isPasswordFormat;

/**
 *  旧规则：验证密码复杂度，必须是字母，数字，字符两种以上,前提是isPasswordFormat
 */
- (BOOL)isPasswordComplexity;

/**
 *  判断是否是商家账号 a-zA-z0-9\u4e00-\u9fa5_- 3到15位，除非纯数字，不可数字特殊字符开头
 */
- (BOOL)isMerchantAccount;

/**
 *  判断是否是店铺名称 a-zA-z0-9\u4e00-\u9fa5_-(). 3到20位，除非纯数字，不可数字特殊字符开头
 */
- (BOOL)isMerchantName;


///判断是否是中英文姓名。中文和· 长度2-25
- (BOOL)isNameString;

///判断是否是详细地址。中英文数字和空格
- (BOOL)isDetailAddress;
///判断是否是物流单号 8-20位数字和大写字母
- (BOOL)isLogisticOrdersn;

#pragma mark -- security
- (NSString *)MD5;
- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;

+ (NSString *)getUUID;


#pragma mark - 其它
/** 根据长度获取一个随机的字符串 */
+ (NSString *)zz_getSingletonStringWithLength:(int)lentgh;

/** 汉字转拼音
 *  大量使用可能比较耗性能
 *
 *  @return 返回无声调的拼音，转换失败返回自身。不同字的拼音用空格隔开。如"北京"->bei jing
 */
- (NSString *)chineseToPinYin;

/** 获取首字母大写
 *
 *  @return 获取失败返回nil
 */
- (NSString *)firstUppercaseLetter;

#pragma mark - 字符串过滤

/**
 过滤regex外的字符--
 中文 [^\u4e00-\u9fa5]
 */
- (NSString *)filterCharactorWithRegex:(NSString *)regexString;

/// 过滤其它字符 regex:允许的字符 maxLength:最大长度，超出了截取前面的部分,0表示不限
- (NSString *)filterCharactorWithRegex:(NSString *)regex maxLength:(NSInteger)maxLength;

/// 过滤非姓名字符 中英文和· 长度2-25
- (NSString *)filterNameString;

/// 过滤非大陆身份证号字符 数字和xX 长度最高18
- (NSString *)filterIdCardString;
/// 过滤所有身份证号字符 字母数字() 长度最高18
- (NSString *)filterAllIdCardString;

#pragma mark - 字符串截取
+ (NSString *)getNumberFromStr:(NSString *)str;

//支付方式匹配
+ (NSString *)payTypeChange:(int)val;

@end

