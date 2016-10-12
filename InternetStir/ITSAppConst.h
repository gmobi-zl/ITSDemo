//
//  ITSAppConst.h
//  InternetStir
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#ifndef ITSAppConst_h
#define ITSAppConst_h

#import <UIKit/UIKit.h>

// Test Channel & url
#define PONEWS_URL_BASE @"http://test.poponews.net/"
#define PONEWS_GROUP @"test"

#define MM_WEB_IMAGE_CACHE_FOLDER @"MMImageCache"

//#define PONEWS_URL_BASE @"http://api.poponews.net/"  http://api.poponews.net/
//#define PONEWS_GROUP @"global"
//#define PONEWS_GROUP @"indonesia"

// ads test url http://api.ads.fotapro.net
// ads url http://api.ads.go2reach.com

#define SYSTEM_STATUSBAR_HEIGHT  20

//#define DEMO_DATA 1

//mode
#define MODE_NIGHT 2
#define MODE_DAY 1

#define FETCH_COUNT 10
#define MAX_OFFLINE_FETCH_COUNT 100

#define MAX_READED_NEWS_COUNT  50
#define MAX_FAVOUR_NEWS_COUNT 256
#define MAX_PUSH_NEWS_COUNT 100
#define MAX_UNLIKE_NEWS_COUNT 500

#define DETAIL_PAGE_FOLDER @"detail"
#define CACHE_FILES_FOLDER @"cache"
#define ARTICLE_CACHE_FOLDER @"articles"

#define POPONEWS_SERVER_DEVICE_ID  @"server_did"
#define POPONEWS_CONNECT_DEVICE_INFO_MD5 @"connect_device_md5"

// overshare
static NSString * OSKApplicationCredential_AppDotNet = @"pZRc4r5hqKsZ73EW8T2dmaQGBcBNVSr6";
static NSString * OSKApplicationCredential_Pocket_iPhone = @"43050-d19ece4fb4eaa5c40f7cefdd";
static NSString * OSKApplicationCredential_Pocket_iPad = @"43050-d19ece4fb4eaa5c40f7cefdd";
static NSString * OSKApplicationCredential_Readability_Key = @"oversharedev";
static NSString * OSKApplicationCredential_Readability_Secret = @"hWA7rwPqzvNEaK8ZbRBw9fc5kKBQMdRK";
static NSString * OSKApplicationCredential_Facebook_Key = @"1608179009437197";
static NSString * OSKApplicationCredential_GooglePlus_Key = @"810720596839-qccfsg2b2ljn0cnu76rha48f5dguns3j.apps.googleusercontent.com";

// push token
#define POPO_IOS_PUSH_DEVICE_TOKEN @"push_device_token"
#define POPO_IOS_PUSH_NEWS_UNREAD_COUNT @"push_news_unread_count"

// connect user info
#define POPO_FB_USER_INFO @"c_fb_user_info"
#define POPO_TWITTER_USER_INFO @"c_tw_user_info"
#define POPO_SIMILARWEB_USER_INFO @"c_sw_user_info"

// customer local
#define CUSTOMER_LOCAL_LANGUAGE_TYPE @"clangtype"
#define CUSTOMER_LOCAL_LANGUAGE_TYPE_EN @"en"
#define CUSTOMER_LOCAL_LANGUAGE_TYPE_CN @"cn"
#define CUSTOMER_LOCAL_LANGUAGE_TYPE_TW @"tw"
#define CUSTOMER_LOCAL_LANGUAGE_TYPE_RU @"ru"
#define CUSTOMER_LOCAL_LANGUAGE_TYPE_TH @"th"
#define CUSTOMER_LOCAL_LANGUAGE_TYPE_INDONESIAN @"indonesian"
#define CUSTOMER_LOCAL_LANGUAGE_TYPE_MY @"my"
// social type
#define SOCIAL_TYPE_FACEBOOK 0
#define SOCIAL_TYPE_TWITTER 2
#define SOCIAL_TYPE_GOOGLE 1
#define SOCIAL_TYPE_BAIDU 3
#define SOCIAL_TYPE_WEIBO 4

//login type
#define LOGIN_TYPE_GMOBI 0
#define LOGIN_TYPE_FACEBOOK 1
#define LOGIN_TYPE_TWITTER 2
#define LOGIN_TYPE_QQ 3
#define LOGIN_TYPE_WECHAT 4
#define LOGIN_TYPE_GOOGLE 5
#define LOGIN_TYPE_WEIBO 6

// setting action
#define SETTING_ACTION_EDITION 0
#define SETTING_ACTION_CLEAN_CACHE 1
#define SETTING_ACTION_FEEDBACK 2
#define SETTING_ACTION_ABOUT 3
#define SETTING_ACTION_VIDEO 4

// offline service
#define DOWNLOAD_STATUS_INIT  0
#define DOWNLOAD_STATUS_WAIT  1
#define DOWNLOAD_STATUS_GET_NEWS 2
#define DOWNLOAD_STATUS_DOWNLOADING  3
#define DOWNLOAD_STATUS_FINISH  4
#define DOWNLOAD_STATUS_STOP  5

// News refresh type
#define NEWS_REFRESH_TYPE_BEFORE  1
#define NEWS_REFRESH_TYPE_AFTER   2
#define NEWS_REFRESH_SUCCESS @"refresh_success"
#define NEWS_REFRESH_ERROR   @"refresh_failed"

#define CB_COMMENT_REFRESH_TYPE_BEFORE  1
#define CB_COMMENT_REFRESH_TYPE_AFTER   2
#define CB_COMMENT_REFRESH_SUCCESS @"cb_refresh_success"
#define CB_COMMENT_REFRESH_ERROR   @"cb_refresh_failed"

#define TRACK_COMMENT_REFRESH_TYPE_BEFORE  1
#define TRACK_COMMENT_REFRESH_TYPE_AFTER   2
#define TRACK_COMMENT_REFRESH_SUCCESS @"track_refresh_success"
#define TRACK_COMMENT_REFRESH_ERROR   @"track_refresh_failed"

#define CB_COMMENT_REPLY_REFRESH_TYPE_BEFORE  1
#define CB_COMMENT_REPLY_REFRESH_TYPE_AFTER   2
#define CB_COMMENT_REPLY_REFRESH_SUCCESS @"cb_reply_refresh_success"
#define CB_COMMENT_REPLY_REFRESH_ERROR   @"cb_reply_refresh_failed"

#define USER_COMMENT_REFRESH_TYPE_BEFORE  1
#define USER_COMMENT_REFRESH_TYPE_AFTER   2
#define USER_COMMENT_REFRESH_SUCCESS @"user_refresh_success"
#define USER_COMMENT_REFRESH_ERROR   @"user_refresh_failed"

// FACEBOOK news
#define FB_ADD_NEWS_TOP    0
#define FB_ADD_NEWS_END    1

#define DATA_SEND_SUCCESS @"data_send_succ"
#define DATA_SEND_ERROR @"data_send_err"

// Event
#define EVENT_COMMENT_DATA_REFRESH_PREFIX  @"COMMENT_REFRESH"
#define EVENT_NEWS_DATA_REFRESH_PREFIX  @"POPONEWS_REFRESH"
#define EVENT_CONNECT_ID @"POPOCONNECT"
#define EVENT_CONNECT_SUCCESS @"connect_success"
#define EVENT_CONNECT_FAILED @"connect_failed"
#define EVENT_CACHE_SIZE_REFRESHED @"cache_size_refreshed"
#define EVENT_CACHE_CLEARED @"cache_folder_cleared"
#define EVENT_TAP_NEWS_DATA_CHANGED @"tap_news_data_changed"
#define EVENT_REPORT_SEND_RESULT @"report_send_result"
#define EVENT_OFFLINE_NEWS_CHANGED @"offline_news_changed"
#define EVENT_OFFLINE_DOWNLOAD_ITEM_UPDATE @"offline_download_item"
#define EVENT_SOCIAL_USER_INIT_FINISH @"social_user_init_finish"
#define EVENT_SOCIAL_NEWS_REFRESH @"social_news_refresh"
#define EVENT_REFRESH_HOME_PAGE_LAYOUT @"homepage_layout_refresh"
#define EVENT_REFRESH_SOCIAL_CATEGORY_STATUS @"social_category_refresh"

#define EVENT_PUSH_NEWS_SHOW @"push_news_show"


#define EVENT_CELEB_COMMENT_DATA_REFRESH  @"CELEB_COMMENT_REFRESH"
#define EVENT_USER_COMMENT_DATA_REFRESH  @"USER_COMMENT_REFRESH"
#define EVENT_CELEB_REPLY_COMMENT_DATA_REFRESH  @"CELEB_REPLY_COMMENT_REFRESH"
#define EVENT_USER_TRACK_COMMENT_DATA_REFRESH  @"USER_TRACK_COMMENT_REFRESH"


// user
#define CELEB_USER_NORMAL 0
#define CELEB_USER_VIP 1
#define CELEB_USER_CELEB 2
#define CELEB_USER_ADMIN 3

// Color
#define COLOR_MENU_ITEM_BACKGROUND @"#ffebebeb"
#define COLOR_MENU_ITEM_VERTICAL_DIVIDER @"#ffc8c8c8"
#define COLOR_CELL_BACKGROUND_NIGHT @"#ff2a2a2a"
#define COLOR_MENU_DIVIDER @"#ffbbbbbb"
#define COLOR_MENU_DIVIDER_RIGHT @"#ffe2e2e2"

#define COLOR_CATEGORY_BG @"#eeeeee"

#define COLOR_BLACK @"#ff000000"

//#define COLOR_BG_RED @"#ffc8161d"
#define COLOR_BG_RED @"#ffff4231"
#define COLOR_BG_RED_NIGHT @"#ff84261e"
#define COLOR_BG_FONT_NIGHT @"#ff888888"

#define COLOR_BG_DARK_RED @"#ffd73123"
#define COLOR_BG_YELLOW @"#ffffff00"
#define COLOR_BG_YELLOW_NIGHT @"#ff858406"
#define COLOR_BG_BLACK @"#ff222222"
#define COLOR_BG_GREY @"#ff999999"
#define COLOR_BG_GREY_NIGHT @"#ff5c5c5c"
#define COLOR_BG_WHITE @"#ffffffff"
#define COLOR_BG_WHITE_NIGHT @"#ff909090"
#define COLOR_CELL_FONT_NIGHT @"#ff5c5c5c"
#define COLOR_CELL_WHITE_NIGHT @"#ff848484"
#define COLOR_BG_COLLECTION_NIGHT @"#ff1a1a1a"
#define COLOR_NEWS_TITLE_NIGHT @"#ff181818"
#define COLOR_FAV_NIGHT @"#ff545454"
#define COLOR_TEXTVIEW_BG @"#222222"
#define COLOR_EMO_BTN_BG @"#dd000000"
#define COLOR_EMO_BTN_PRESSED @"#ddff4131"
#define COLOR_EMO_HEART @"#ffffff00"

#define COLOR_NEWSLIST_GREY @"#fff2f3f7"
#define COLOR_NEWSLIST_TITLE_BLACK @"#ff242424"
#define COLOR_NEWSLIST_SOURCE_GREY @"#ff9a9a9a"
#define COLOR_NEWSLIST_TIME_GREY @"#ffa0a0a0"
#define COLOR_NEWSLIST_LINE_GREY @"#ffcccccc"
#define COLOR_NEWSLIST_DIVIDER_GREY @"#ffdddddd"
#define COLOR_NEWSLIST_BLACK_BAR @"#ee000000"

#define COLOR_SPLASH_TOP_BG @"#f33c2d"
#define COLOR_SPLASH_FT_TITLE @"#666666"
#define COLOR_SPLASH_FT_INFO @"#999999"
#define COLOR_SPLASH_UPDATE @"#999999"

//commnt
#define COLOR_COMMENT_DETAILBG @"#ececec"
#define COLOR_COMMENT_DETAIL_TITLE @"#094da1"
#define COLOR_COMMENT_USERNAME @"#0079B1"
#define COLOR_COMMENT_FAVOUR @"#a4a4a4"
#define COLOR_COMMENT_TIME @"#a4a4a4"

//share
#define COLOR_SHARE_BG @"#fff1f0"
#define COLOR_SHARE_TOP_LINE @"#ffe3e1"
#define COLOR_SHARE_CANCEL_BG @"#ffffff"
#define COLOR_SHARE_CANCEL_TOP_LINE @"#ececec"
//progress
#define COLOR_PROGRESS_BG @"#ff877d"
//tableViewHeader
#define COLOR_TABLEVIEWHEADER_BG @"#ff4131"

// string
#define STR_PULL_REFRESH_PULL @"Pull to get the latest news..."
#define STR_PULL_REFRESH_RELEASE @"Release to refresh..."
#define STR_PULL_REFRESH_LOADING @"Loading News..."

// news type
#define NEWS_TYPE_ARTICLE @"article"
#define NEWS_TYPE_IMAGE @"photo"
#define NEWS_TYPE_TOP_IMAGE @"hotImage"

#define NEWS_SHOW_TYPE_THREEIMAGE @"threeImage"
#define NEWS_SHOW_TYPE_BIGIMAGE @"bigImage"
#define NEWS_SHOW_TYPE_TITLE @"title"
#define NEWS_SHOW_TYPE_RIGHTIMAGE @"rightImage"
// mood vote type
#define NEWS_MOOD_VOTE_TYPE_HAPPY @"happy"
#define NEWS_MOOD_VOTE_TYPE_MOVING @"moving"
#define NEWS_MOOD_VOTE_TYPE_ANGRY @"angry"
#define NEWS_MOOD_VOTE_TYPE_AMAZE @"amazing"
#define NEWS_MOOD_VOTE_TYPE_WORRY @"worry"
#define NEWS_MOOD_VOTE_TYPE_SAD @"sad"

#define NEWS_SET_VOTE_TYPE_SMALL @"1"
#define NEWS_SET_VOTE_TYPE_MID @"2"
#define NEWS_SET_VOTE_TYPE_BIG @"3"
// offline
#define OFFLINE_DOWNLOAD_IMAGE_FLAG @"offline_download_image"
#define LOGIN_IMAGE @"login_image"
//comment
#define CONFIG_USERLOGIN_INFO @"user_login_info"
#define CONFIG_GMOBI_USERLOGIN_INFO @"gmobi_user_login_info"
// config
#define CONFIG_LAST_CONNECT_INFO @"last_connect_info"
#define CONFIG_DETAIL_FONT_SIZE @"detail_font_size"
#define POPONEWS_CHANNEL_KEY @"channel"
#define CONFIG_DAY_NIGHT_MODE @"day_night"
#define CONFIG_CHANNELS_DATA @"channels_data"
#define FACEBOOK_LAST_LIKES_INFO @"fb_last_likes"
#define TWITTER_LIST_LIKES_INFO @"tw_last_likes"
#define WEIBO_LIST_LIKES_INFO @"we_last_likes"

#define SCROLL_TITLE_COLOR @"scroll_title_color"
//layout
#define NEWS_LAYOUT_TYPE_PIN @"pin"
#define NEWS_LAYOUT_TYPE_GRID @"grid"
#define NEWS_LAYOUT_TYPE_LIST @"list"
#define NEWS_LAYOUT_TYPE_PIN2 @"pin2"
#define NEWS_LAYOUT_TYPE_PIN3 @"pin3"
// Social
#define SOCIAL_FACEBOOK_SWITCH_ON_KEY   @"social_fb_avtive_key"
#define SOCIAL_GOOGLE_SWITCH_ON_KEY   @"social_gp_avtive_key"
#define SOCIAL_TWITTER_SWITCH_ON_KEY   @"social_tw_avtive_key"
#define SOCIAL_WEIBO_SWITCH_ON_KEY @"social_we_active_key"
#define SOCIAL_BAIDU_SWITCH_ON_KEY @"social_bd_active_key"

//setting
#define SETTING_SWITCH_ON_KEY @"setting_switch_on_key"

//facebook ads
#define  FACEBOOK_LIST_PLACEMENT_ID @"1608179009437197_1666024683652629"
#define  FACEBOOK_ARTICLE_BANNER_PLACEMENT_ID @"1608179009437197_1669512926637138"
#define  FACEBOOK_ARTICLE_INTERSTITIAL_PLACEMENT_ID @"1608179009437197_1669513056637125"
#define  FACEBOOK_DISCOVER_INTERSTITIAL_PLACEMENT_ID @"1608179009437197_1669513209970443"



#define NAV_BGCOLOR @"#ffd601"
#endif /* ITSAppConst_h */
