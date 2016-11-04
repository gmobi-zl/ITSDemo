var slideMap = new Array();
var AD_SWIPE_INTERVAL = 5000;
var mms;
var allImgIdx = 0;
var maxImgH = 0;
function init()
{
	var title;
    
    sdkLog("nid = " + nid);
    
	apiGetData(nid,function(result,data){
		
        sdkLog("data = " + JSON.stringify(data));
               
        var context = {Title:data.title, publishIconId:data.picon, publisherDomian:data.pname, releaseTime:data.time,source:data.source,btnStr:data.readsource,local:data.local, nm: data.nightmode};
		var source  = $("#entry-template").html();

		var sourceUrl = data.source;
		var local = data.local;
		sdkLog("step1 source="+data.source);

		var template = Handlebars.compile(source);
		var publishIconId = data.picon;
		var fontsize = data.fontsize;
		var nightmode = data.nightmode;
		var entryurl = data.entryurl;
		var pakname = data.pakname;
		mms = data.mms;
		
		//sdkLog("step3 picon="+publishIconId+"fontsize="+fontsize);
        
		Handlebars.registerHelper('img', function(id) {
			var result;
			
            sdkLog("web page image local = "+local);
            
            if (local == 1) {
				var has = -1;
				for(var j=0; j<mms.length; j++)
				{
					if(id ==mms[j].id)
					{
						has = j;
						break;
					}
				}
				sdkLog("has == "+has+" and mms[has].w = "+mms[has].w);
				if(has>0 && mms[has].w < 320) {
					//result = '<img width="'+mms[has].w+'px" height="'+mms[has].h+'px" src="temp/' + id + '" />';
                    //result = '<img id="'+id+allImgIdx+'" src="temp/' + id + '"  onload = "onloadImg(this,id)">';
                    result = '<img id="'+id+'" src="temp/' + id + '"  onload = "onloadImg(this,id)">';
					//result = '<img width="'+mms[has].w+'" src="content://'+pakname+'/' + id + '">';
				} else
                    result = '<img src="temp/' + id + '" />';
					//result = '<img src="content://'+pakname+'/' + id + '">';
                                  
                sdkLog("offline image : "+result);
			}
			else {
				//result = '<img id="'+id+allImgIdx+'" src="'+entryurl+'/files/' + id + '"  onload = "onloadImg(this,id)">';
                result = '<img id="'+id+'" src="'+entryurl+'files/' + id + '"  onload = "onloadImg(this,id)">';
                //sdkLog("web page image url = "+result);
			}

			allImgIdx++;
                                  
            /*
            if (local == 1){
                result = '<img src="temp/' + id + '" />';
                sdkLog("offline image : "+result);
            } else {
                result = '<img id="'+id+allImgIdx+'" src="'+entryurl+'/files/' + id + '"  onload = "onloadImg(this,id)">';
            }
            allImgIdx ++;
            */
			return new Handlebars.SafeString(result);
		});

		Handlebars.registerHelper('publishIcon', function() {

			var result = '<img style="width:16px;height:16px" src="'+entryurl+'/files/' + publishIconId + '">';

			  return new Handlebars.SafeString(result);
		});
         
		Handlebars.registerHelper('video', function (url) {
			sdkLog("video 1");
			var width = document.body.scrollWidth;
			var height = width / 2;
            sdkLog("video " + width);
            sdkLog("video " + url);
			var videoFrame = '<iframe style="margin-left:auto;margin-right:auto;width:100%;height:'+height+'" src="'+url+'" frameborder="0"></iframe>';
            sdkLog("video " + videoFrame);
            sdkLog("video 2");
            return new Handlebars.SafeString(videoFrame);
		});
        
        Handlebars.registerHelper('a', function (url) {
            var result = '<a href="javascript:void(0);" onclick="openInWebView(\''+url+'\');return false;" >'+url+'</a>';
            return new Handlebars.SafeString(result);
        });
        
		Handlebars.registerHelper('slide', function (ids) {
			sdkLog("slide1");
			var id= new Array();
			slideMap = [];
			
			id = ids.split(",");
			sdkLog("id.length="+id.length);
			
			if(id.length == 0 || ids == "")
			{
				sdkLog("no slide");
				return new Handlebars.SafeString("");
				
			}
				
				
			for(var i=0; i<id.length;i++)
			{
				for(var j=0; j<mms.length; j++)
				{
					if(id[i]==mms[j].id)
					{
						slideMap.push(mms[j]);
						break;
					}
				}
			}
			
			var result ="";
			result += "<div id='top_gallery' class='viewport'>";
			result += "<div id = 'topswipe' class='flipsnap'>";
			
					
			var width = document.body.clientWidth-28;
            
            if (local == 1) {
                for(var i = 0; i < slideMap.length; i++)
                {
                    var html = '<div class="item"><img src="temp/'+slideMap[i].id+'" width="'+width+'px" align ="center")></div>';
                    result += html;
                }
            } else {
                for(var i = 0; i < slideMap.length; i++)
                {
                    var html = '<div class="item"><img src="'+entryurl+'/files/'+slideMap[i].id+'" width="'+width+'px" align ="center")></div>';
                    result += html;
                }
            }
			
			result += "</div>";
			result +="<span id='d_mmIndicator_span' style='padding-top:4px;padding-bottom:9px;color:#ffffff;font-size:14px;text-align:center;position:absolute; bottom:-5px; left:0; line-height:1.5; width:100%; background-color:rgba(0,0,0,0.5);'></span>"
			result +="</div>";
			
			sdkLog("slide2");
			return new Handlebars.SafeString(result);
		});
		

		sdkLog("step3 nightmode=" + nightmode);
		document.getElementById("real_content").innerHTML = template(context);  
		sdkLog("step4 fontsize=" + fontsize);
		if (fontsize == 0) {

			document.getElementById("p_domain").className = "c_domain_s";
			
			if (nightmode == 2) {
				document.getElementById("main_body").className = "c_body_s_n";
				document.getElementById("p_title").className = "c_title_s_n";
				document.getElementById("p_btn").className = "c_btn_s_n";
			}
			else {
				document.getElementById("main_body").className = "c_body_s";
				document.getElementById("p_title").className = "c_title_s";
				document.getElementById("p_btn").className = "c_btn_s";
			}
		}
		else if (fontsize == 1) {


			document.getElementById("p_domain").className = "c_domain";
			
			if (nightmode == 2) {
				document.getElementById("p_title").className = "c_title_n";
				document.getElementById("main_body").className = "c_body_n";
				document.getElementById("p_btn").className = "c_btn_n";
			}
			else {
				document.getElementById("p_title").className = "c_title";
				document.getElementById("main_body").className = "c_body";
				document.getElementById("p_btn").className = "c_btn";
			}
		}
		else if (fontsize == 2) {

			document.getElementById("p_domain").className = "c_domain_l";
			
			if (nightmode == 2) {
				document.getElementById("main_body").className = "c_body_l_n";
				document.getElementById("p_title").className = "c_title_l_n";
				document.getElementById("p_btn").className = "c_btn_l_n";
			} else {
				document.getElementById("main_body").className = "c_body_l";
				document.getElementById("p_title").className = "c_title_l";
				document.getElementById("p_btn").className = "c_btn_l";
			}
		}
        sdkLog("step5 init end");
        
		if (slideMap.length > 0) {
			$(".viewport").width(document.body.clientWidth - 28);
			var img = getAvgHeight();
			sdkLog("avgheight=" + img.h + "," + img.w);
			if (img.w > 360) {
				$(".viewport").height(img.h * 360 / img.w);
			}
			else {
				$(".viewport").height(img.h);
			}

			$(".flipsnap").width(document.body.clientWidth * slideMap.length);
			$(".item").width(document.body.clientWidth);
			var elem = document.getElementById('topswipe');
			flipsnap = Flipsnap(elem);


			flipsnap.element.addEventListener('fspointmove', function () {
				mmIndicatorCallback(flipsnap.currentPoint, null)
			}, false);

			setAppTimeout(function () {
				filpsnapScroll();
			}, AD_SWIPE_INTERVAL);

			mmIndicatorCallback(0, null);
		}
               
        pos();
         
    });

//    var context = {Title:"data.title", publisherDomian:"data.pname", releaseTime:"data.time",source:"data.source",btnStr:"data.readsource",fontsize:"data.fontsize"};
//		var source   = $("#entry-template").html();
//		var sourceUrl = "http://www.baidu.com";
//		sdkLog("step3 source="+source);
//		var template = Handlebars.compile(source);
//		var publishIconId = "0fefb117a2d7b69e0b10d725a6b0b8dd";
//		var fontsize = 2;
//		Handlebars.registerHelper('img', function(id) {
//
//			  var result = '<img src="Http://test.poponews.net/files/'+id+'">';
//
//			  return new Handlebars.SafeString(result);
//		});
//				Handlebars.registerHelper('publishIcon', function() {
//
//			  var result = '<img style="width:16px;height:16px" src="Http://test.poponews.net/files/'+publishIconId+'">';
//
//			  return new Handlebars.SafeString(result);
//		});
//		//sdkLog("step3 4");
//
//		document.getElementById("real_content").innerHTML = template(context);  
//		//document.getElementById("read_source").href = "javascript:window.location.href='"+sourceUrl+"'"; 
//		
//
//    	if(fontsize == 0)
//		{
//			 document.getElementById("p_title").className = "c_title_s";
//		}
//		else if(fontsize == 1)
//		{
//			 document.getElementById("p_title").className = "c_title";
//		}
//		else if(fontsize == 2)
//		{
//			 document.getElementById("p_title").className = "c_title_l";
//		}

}


function onloadImg(objImg,id)
{
  var img = new Image();
  img.src = objImg.src;
  if(img.width < 320)
  {
	  $('#'+id).width(img.width);
  }

}

 
function getUrlParam(name)
{
  var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
  var r = window.location.search.substr(1).match(reg);
  if (r!=null) return unescape(r[2]); return "";
} 

// scroll image begin
function getAvgHeight()
{
	sdkLog("getAvgHeight1");
	var heightArray = new Array();
	sdkLog("slideMap.length="+slideMap.length);
	if(slideMap.length == 1)
		return slideMap[0];
		
	if(slideMap.length == 2)
		return slideMap[0].h > slideMap[1].h ? slideMap[0] : slideMap[1];

	
	var slideMapSort= slideMap.concat(); 
	
	sdkLog("getAvgHeight2");
	var slideMap1 = quickSort(slideMapSort);
	sdkLog("getAvgHeight3");
	for(var i=0; i<slideMap1.length;i++)
		sdkLog("slideMap1[i]="+slideMap1[i].h);
	
	var i1 = slideMap1[Math.round(slideMap1.length/2) - 1];
	sdkLog("getAvgHeight4");
	return {'h':i1.h, 'w':i1.w};
	
			
}


var quickSort = function(arr){
if (arr.length <= 1){return arr;}
var pivotIndex = Math.floor(arr.length / 2);
var pivot = arr.splice(pivotIndex, 1)[0];
var left = [];
var right = [];
for (var i = 0; i < arr.length; i++){
if (arr[i].h < pivot.h) {
left.push(arr[i]);
} else {
right.push(arr[i]);
}
}
return quickSort(left).concat([pivot], quickSort(right));
};


function initMainAdsUI(){

  $(".viewport").width(document.body.clientWidth-28);
  var img= getAvgHeight();
  sdkLog("avgheight="+img.h+","+img.w);
  if(img.w > 360)
 {
  	$(".viewport").height(img.h * 360 / img.w);
 }	
  else
 {	  
  	$(".viewport").height(img.h);
 }

  $(".flipsnap").width(document.body.clientWidth*slideMap.length);
  $(".item").width(document.body.clientWidth);
  var elem = document.getElementById('topswipe');
  flipsnap = Flipsnap(elem);


  flipsnap.element.addEventListener('fspointmove', function() {
      mmIndicatorCallback(flipsnap.currentPoint,null)
  }, false);

  setAppTimeout(function(){
    filpsnapScroll();
  }, AD_SWIPE_INTERVAL);

  mmIndicatorCallback(0,null);

}

function mmIndicatorCallback(index, element) 
{ 
	var indiDiv = document.getElementById("d_mmIndicator_span");
	var html = "";
	if(slideMap.length == 0)
		return;

	if(slideMap[index].desc == "" || slideMap[index].desc == undefined)
		html = "("+(index+1)+"/"+slideMap.length+")";
	else	
		html = "("+(index+1)+"/"+slideMap.length+")"+slideMap[index].desc;      


  	indiDiv.innerHTML = html;

}


function filpsnapScroll(){
    if(flipsnap.hasNext())
      flipsnap.toNext(350);
    else
      flipsnap.moveToPoint(0);

    setAppTimeout(function(){
      filpsnapScroll();
    }, AD_SWIPE_INTERVAL);
}

function setAppTimeout(cb, time){
  var id = window.setTimeout(cb, time);
  return id;
}
// scroll image end

function opensrc()
{
	//sdkLog("opensrc !! nid="+nid);
	apiOpenSrc(nid);
}

function setShowStyle(fontsize, nightmode) {
    if (fontsize == 0) {
		document.getElementById("p_domain").className = "c_domain_s";
		if (nightmode == 2) {
			document.getElementById("main_body").className = "c_body_s_n";
			document.getElementById("p_title").className = "c_title_s_n";
			document.getElementById("p_btn").className = "c_btn_s_n";
		} else {
			document.getElementById("main_body").className = "c_body_s";
			document.getElementById("p_title").className = "c_title_s";
			document.getElementById("p_btn").className = "c_btn_s";
		}
	} else if (fontsize == 1) {
		document.getElementById("p_domain").className = "c_domain";
			
		if (nightmode == 2) {
			document.getElementById("p_title").className = "c_title_n";
			document.getElementById("main_body").className = "c_body_n";
			document.getElementById("p_btn").className = "c_btn_n";
		} else {
			document.getElementById("p_title").className = "c_title";
			document.getElementById("main_body").className = "c_body";
			document.getElementById("p_btn").className = "c_btn";
		}
	} else if (fontsize == 2) {
		document.getElementById("p_domain").className = "c_domain_l";
		
		if (nightmode == 2) {
			document.getElementById("main_body").className = "c_body_l_n";
			document.getElementById("p_title").className = "c_title_l_n";
			document.getElementById("p_btn").className = "c_btn_l_n";
		} else {
			document.getElementById("main_body").className = "c_body_l";
			document.getElementById("p_title").className = "c_title_l";
			document.getElementById("p_btn").className = "c_btn_l";
		}
	}
    document.location.reload();
}


function pos()
{
    var object=document.getElementById("real_content");
    //alert(object.offsetLeft)
    var li=object.getElementsByTagName("p");
    for(i=0;i<li.length;i++)
    {
        if(i == Math.round(li.length/2))
            popbox(li[i]);
    } 
}

function doAdClickAction(){
    apiNativeAdClicked(nid);
}

function doAdOnLoad(){
    var htmlH = document.body.offsetHeight;
    sdkLog("[web] html height = " + htmlH);
    apiNativeAdLoaded(htmlH);
}

function popbox(id){
    apiGetNativeAd(nid,function(result,data){
        if (result == false){
            sdkLog("apiGetNativeAd no ad");
        } else {
            var newdiv=document.createElement("p");
            sdkLog("apiGetNativeAd title="+data.title+",img="+data.img);
            newdiv.style.top="0px";
            newdiv.style.left="0px";
            newdiv.style.width="100%";
            newdiv.style.backgroundColor="#eeeeee"
            newdiv.innerHTML="<div onclick=doAdClickAction()><div style='text-align:left'>"+data.title+"<img src='ad.png' style='width:28px;height:16px;float:right;padding-top:4px'></div><img src='"+data.img+"' style='width:100%;' onload=doAdOnLoad()></div>"
                   
            //newdiv.innerHTML="<div>"+data.title+"</div>"
            id.appendChild(newdiv);//将生成的div层插入到指定的节点内,成为其最后一个子节点；
            sdkLog("appendChild");
        }
    });
}

function sdkLog(msg){
  jsCallNativeApi("loggerDebug", [msg], null);
}

function openInWebView(url){
    sdkLog("open url = " + url);
    apiOpenUrl(url);
}

var apiGetData = function(nid,callback) {
  jsCallNativeApi("getNewsData", [nid], callback);
};

var apiOpenSrc = function(nid,callback) {
  jsCallNativeApi("webOpenSrc", [nid], callback);
};

var apiOpenUrl = function(url) {
    jsCallNativeApi("webOpenUrl", [url], null);
}

var apiGetNativeAd = function(nid, callback) {
    jsCallNativeApi("GetDetailAd", [nid], callback);
};

var apiNativeAdClicked = function(nid, callback) {
    jsCallNativeApi("ClickDetailAd", [nid], callback);
};

var apiNativeAdLoaded = function(height){
    jsCallNativeApi("gmobiAdLoaded", [height], null);
}

var nid = getUrlParam('nid');




init();