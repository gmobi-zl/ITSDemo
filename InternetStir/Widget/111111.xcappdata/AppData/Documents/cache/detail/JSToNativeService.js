var callbackList = [];
var callbackCounter = 0;

var system ={
	win : false,
	mac : false,
	xll : false
};

var plat = navigator.platform;
system.win = plat.indexOf("Win") == 0;
system.mac = plat.indexOf("Mac") == 0;
system.x11 = (plat == "X11") || (plat.indexOf("Linux") == 0);

function getPlatform(){
	if(system.win||system.mac||system.xll){
		return "PC";
	}else{
		return "MOBILE";
	}	
}

var browser = {
    versions: function() {
        var u = navigator.userAgent, app = navigator.appVersion;
        return {//移动终端浏览器版本信息
            trident: u.indexOf('Trident') > -1, //IE内核
            presto: u.indexOf('Presto') > -1, //opera内核
            webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
            gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1, //火狐内核
            mobile: !!u.match(/AppleWebKit.*Mobile.*/) || !!u.match(/AppleWebKit/), //是否为移动终端
            ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
            android: u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android终端或者uc浏览器
            iPhone: u.indexOf('iPhone') > -1 || u.indexOf('Mac') > -1, //是否为iPhone或者QQHD浏览器
            iPad: u.indexOf('iPad') > -1, //是否iPad
            webApp: u.indexOf('Safari') == -1 //是否web应该程序，没有头部与底部
        };
    }(),
    language: (navigator.browserLanguage || navigator.language).toLowerCase()
}
                           
var messagingIframe;
var isNativeProgressing = false;

function jsBridgeInitForIOS() {
    messagingIframe = document.createElement("iframe");
    messagingIframe.style.display ="none";
    messagingIframe.src = "mmwebviewaction://initURL/init/";
    document.documentElement.appendChild(messagingIframe);
}
jsBridgeInitForIOS();
                           
function objcGetJsCommands() {
    isNativeProgressing = true;
    var count = callbackList.length;
    for (var i = 0; i < count; i++){
        var item = callbackList[i];
        if (item.isNativeGet == false){
            var paramsJsonArrayStr = JSON.stringify(item.params);
            item.isNativeGet = true;
            if (item.callback == null) {
                callbackList.splice(i, 1);
            }
            
            return "mmwebviewaction://" + item.id + "/" + item.action + "/" + paramsJsonArrayStr;
        }
    }
    isNativeProgressing = false;
    return null;
}

function jsCallNativeApi(action, params, callback){
	var timestamp = Math.round(new Date().getTime()/1000);
	var cItem = {
		'id': timestamp + "_" + callbackCounter,
		'callback': callback,
		'action': action,
		'params': params,
        'isNativeGet': false
	};

	callbackCounter++;
	if (callbackCounter > 99999999)
		callbackCounter = 0;
	
	//if (callback != null)
    callbackList.push(cItem);
	
	checkCallbackList();

	var paramsJsonArrayStr = JSON.stringify(params);
	
	//if (getPlatform() == "MOBILE"){
        //if (browser.versions.ios || browser.versions.iPhone || browser.versions.iPad) {
            try{
                //messagingIframe.src = "mmwebviewaction://" + cItem.id + "/" + cItem.action + "/" + paramsJsonArrayStr;
                if (isNativeProgressing == false)
                    messagingIframe.src = "mmwebviewaction://1000/sendMsg";
                //window.document.location="mmwebviewaction://" + cItem.id + "/" + cItem.action + "/" + paramsJsonArrayStr;
            } catch(e){
                console.log('call ios api error!');
            }
        //}
        //else if (browser.versions.android) {
        //    try{
        //        window._JsToNativePluginApi.exec(cItem.id, cItem.action, paramsJsonArrayStr);
        //    } catch(e){
        //        console.log('call android api error!');
        //    }
        //}
	//}
}

function callJsCallback(id, status, message){
	console.log("android callback:" + id + ",  " + status  + ",  " + message);
	var count = callbackList.length;
	for (var i = 0; i < count; i++){
		var item = callbackList[i];
		if (id == item.id){
			if (status == "success"){
				if (item.callback){
					item.callback(true, message);
				}
			} else {
				if (item.callback)
					item.callback(false, message);
			}

			callbackList.splice(i, 1);
			break;
		}
	} 

	checkCallbackList();
}

function checkCallbackList(){
	var timestamp = Math.round(new Date().getTime()/1000);
	var count = callbackList.length;
	for (var i = 0; i < count; i++){
		var item = callbackList[i];
		if (item.type != "permanent"){
			var idTimestamp = getCallbackIdTimestamp(item.id);
			if (timestamp - idTimestamp > 1000*60*10){
				callbackList.splice(i, 1);
				count--;
				i--;
			}
		}
	}
}

function arrayToJsonarrayString(p){
	if (p == null)
		return null;

	var pCount = p.length;
	if (pCount <= 0)
		return null;
	var jsonArrayStr = '[';
	var j = 0;
	for (j = 0; j < pCount; j++) {
		var item = p[j];
		
		if (j != 0)
			jsonArrayStr += ',';
		
		if (item == null)
			jsonArrayStr += 'null';
		else{
			var itemStr = null;
			if ($.type(item) == "object")
				itemStr = JSON.stringify(item);
			else
				itemStr = item.toString();
			jsonArrayStr += '\'' + itemStr + '\'';
		}

	};
	jsonArrayStr += ']';
	return jsonArrayStr;
}

function getCallbackIdTimestamp(id){
	if (id == null)
		return 0;
	var pos = id.indexOf("_");
	return id.substr(0, pos);
}