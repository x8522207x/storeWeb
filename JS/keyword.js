//關鍵字合併
var tag = "";
function unigrammMerage(t,limit)
{
	//return;
	tag = t;
	var tempObj;
	var templen;
	var tfCondition = parseInt($("#tf").val())-1;
	//alert(tfCondition);
	
	$(tag+'font').each(function() {
		if($(this).attr('class'))
		{
			tempObj = $(this);
			var cname = $(this).attr('class');
			$(this).attr('id',cname);
			var id;
			if(cname.indexOf('l')!=-1)
				id = cname.replace('l','r');
			else
				id = cname.replace('r','l');
			if($(this).attr("alt")==undefined)
			{
				var len = $(tag+'.'+id).length;
				if(len>0&&templen!=len)
				{
				
						$(this).attr("alt",len)
						var tfInfo = "";
						if(len>tfCondition)
							tfInfo = '('+$(this).attr("alt")+')';
						var tempContent = $(this).text();
						$(this).text("");
						//左邊不顯示詞頻
						if(limit>1)
						{
							if(cname.indexOf('l')==-1)
								$(this).text(tfInfo+tempContent);
							else
								$(this).text(tempContent);
						}
						else
						{
							$(this).text(tfInfo+tempContent);
						}
				}
				else
				{
					templen = -1;
				}
				templen = len;
			}
		}
		else
		{
			var word = $(this).text();
			var name = $(this).attr("name");
			$(this).remove();
			$(tempObj).append(word);
			
			if($(tempObj).attr("name")==name)
			{
				//$(this).remove();
				//$(tempObj).append(word);
			}
			else
			{
				//$(tempObj).after("<span color='blue'>"+word+"</span>");
				//$(tempObj).after(word);
				//tempObj = $(tempObj).after();
			}
			templen = -1;
		}
	});
	if($("#mergeSct").val()=="1")
	{
		var tempObj2;
		$(tag+'font').each(function() {
			if($(this).attr('alt'))
			{
				tempObj2 = $(this);
				//$(this).attr("onclick","");
			}
			else
			{
					var word = $(this).text();
					$(this).remove();
					$(tempObj2).append(word);
			
			}
		});
	}
	Array.prototype.contains = function(obj) {
    var i = this.length;
    while (i--) {
        if (this[i] == obj) {
            return true;
        }
	    }
	    return false;
	}
	var arrValues = [];
	$(tag+'font').each(function() {
		if($(this).attr('alt')&&parseInt($(this).attr('alt'))>1)
		{
			var id = $(this).attr('id');
			id = id.substring(1);
			if(!arrValues.contains(id))
				arrValues.push(id);
		}
	});
	//高頻關鍵字
	var objectS = [];
	var htf = parseInt($("#htfSct").val());
	for(var i=0;i<arrValues.length;i++)
	{
		var len_l = $(tag+'.l'+arrValues[i]).length;
		var len_r = $(tag+'.r'+arrValues[i]).length;
		var score = 1/((1/len_l)+(1/len_r))
		var o = {id:arrValues[i], lc:len_l, rc:len_r, f1:score,k:'',visit:0,c:1,isChange:0};
		if(len_l>=htf&&len_r>=htf)
		objectS.push(o);
		//alert(arrValues[i]+" "+len_l+" "+len_r+" "+score)
	}
	objectS.sort(function (a, b) {
	  if (a.f1 > b.f1) {
	    return 1;
	  }
	  if (a.f1 < b.f1) {
	    return -1;
	  }
	  // a must be equal to b
	  return 0;
	});

	for(var i=(objectS.length-1);i>=0;i--)
	{
		var o = objectS[i];
		var oid = o.id;
		//alert(o.f1);
		var t = tag+'#r'+o.id;
		var k = $(t).text().replace(/\(\d\d?\)/i, "");
		var count = 0;
		//if(k.length>3)
		{
			//alert(k);
			$(tag+'.l'+oid).each(function() {
				//if($(this).text().replace(/\(\d\d?\)/i, "").length>k.length)
				{
					
					k = $(this).text().replace(/\(\d\d?\)/i, "");
					if(k.length<3)
					{
						k=k+$(this).next().text().replace(/\(\d\d?\)/i, "");
						
					}
					if(k.length<3)
					{
						k=k+$(this).next().next().text().replace(/\(\d\d?\)/gi, "");
					}
				}
				count++;
			});
			$(tag+'.r'+oid).each(function() {
				//if($(this).text().replace(/\(\d\d?\)/i, "").length>k.length)
				{
					k = $(this).text().replace(/\(\d\d?\)/i, "");
					if(k.length<3)
						k=k+$(this).next().text().replace(/\(\d\d?\)/i, "");
					if(k.length<3)
						k=k+$(this).next().next().text().replace(/\(\d\d?\)/i, "");
				}
				count++;
			});
		}
	
			k = k.substring(0,3);
			o.k = k;
		
	}
	var objectSFinal = [];
	for(var i=(objectS.length-1);i>=0;i--)
	{
		var o = objectS[i];
		if(o.visit==0)
		{
			objectSFinal.push(o);
			o.visit = 1;
		}
		var k1 = o.k;
		for(var j=(objectS.length-1);j>=0;j--)
		{
			var o2 = objectS[j];
			var k2 = o2.k;
			if(i!=j&&o2.visit==0)
			{
				var sub1 = k2.substring(0,2);
				var sub2 = k2.substring(1,3);
				var k1sub1 = k1.indexOf(sub1);
				var k1sub2 = k1.indexOf(sub2);
				//if((k1sub1!=-1&&k1sub1!=k2sub1)||(k1sub2!=-1&&k1sub2!=k2sub2))
				//if((k1sub1!=-1||k1sub2!=-1)&&k1sub1!=k1sub2)
				if((k1sub1==1||k1sub2==0))
				{
					o2.visit = 1;
					o2.c = 0;
					if((k1sub1<k1sub2))
						o2.isChange = 1;
					//alert(k1+" "+k2);
					objectSFinal.push(o2);
					for(var k=(objectS.length-1);k>=0;k--)
					{
						var o3 = objectS[k];
						var k3 = o3.k;
						if(j!=k&&o3.visit==0)
						{
							var sub1 = k3.substring(0,2);
							var sub2 = k3.substring(1,3);
							var k2sub1 = k2.indexOf(sub1);
							var k2sub2 = k2.indexOf(sub2);
							//if(k2.indexOf(sub1)!=-1||k2.indexOf(sub2)!=-1)
							//if((k2sub1!=-1||k2sub2!=-1)&&k2sub1!=k2sub2)
							if((k2sub1==1||k2sub2==0))
							{
								o3.visit = 1;
								o3.c = 0;
								if((k2sub1<k2sub2))
									o2.isChange = 1;
								objectSFinal.push(o3);
								
							}
						}
					}
				}
			}
		}
	}
	var objectSFinalChange = [];
	for(var i=0;i<objectSFinal.length-1;i++)
	{
		var o = objectSFinal[i];
		var o2 = objectSFinal[i+1];
		if(o2.isChange==1)
		{
			o2.c = 1;
			o.c = 0;
			objectSFinalChange.push(o2);
			objectSFinalChange.push(o);
			i++;
		}
		else
			objectSFinalChange.push(o);
		
	}
	//補足最後一個
	if(objectSFinalChange.length!=objectSFinal.length)
		objectSFinalChange.push(objectSFinal[(objectSFinal.length-1)]);
	//alert(objectSFinal.length);
	var delKcount = 0;
	var subCondition = parseInt($("#subCondition").val());
	for(var i=0;i<objectSFinalChange.length;i++)
	{
		var o = objectSFinalChange[i];
		var k = o.k;
		if(o.c==1)
			delKcount = o.lc+o.rc;
		var str = "<button alt='"+k+"' class='btn btn-danger btn-xs' id='key"+o.id+"' onclick='delKey("+o.id.trim()+",this);'><i class='fa fa-trash-o'></i>"+k+"( "+o.lc+" | "+o.rc+" )</button>";
		if(o.c==1)
		{
			$('#tfWordContent').append(" || ").append(str);
		}
		else
		{
			var throld = delKcount/subCondition;
			if((o.lc+o.rc)>throld)
				$('#tfWordContent').append(" 、 ").append(str);
		}
		
	}
}

function pageHighlight(id,o)
{
	var idTag = '.'+id;
	$(o).attr('color','red');
	$(o).attr('style','border:0px green dotted');
	
	var lTag = id;

	if(id.indexOf('l')!=-1)
		id = id.replace('l','r');
	else
		id = id.replace('r','l');
	var rTag = id;
	idTag = tag+'.'+id;
	$(idTag).attr('color','red');
	$(idTag).attr('style','border:0px green dotted');
	//alert($('#anchor').val())
	
	/*if($(o).attr("alt")==undefined)
	{
		$(o).attr("alt",$('.'+rTag).length)
		$(o).append('('+$(o).attr("alt")+')');
	}*/
	$(o).connections('remove');
	$(o).connections({ to: tag+'.'+rTag,  css: { color: '#d62' } });
}
function p(o)
{
	//alert($(o).attr("id"));
	if($('#clean').val()==1)
		$('font').connections('remove');
	var cc = 0;
	$(o).parents('p').children('font').each(function(){
		if($(this).attr('onclick')!='')
		{
			pageHighlight($(this).attr('class'),$(this));
			cc++;
		}
	});
	//$(o).attr("alt",cc);
	//alert(cc);

}
function mouseOver(id,o)
{
	//remove the previous onnection line
	if($('#cleanKey').val()==1)
		$('font').connections('remove');
	//remove the previous font color
	$('font').each(function(){
		if($(this).attr("bcolor"))
		{
			$(this).attr("color",$(this).attr("bcolor"));
		}
	});
	var idTag = tag+'.'+id;
	$(idTag).attr('bcolor',$(idTag).attr('color'));
	$(idTag).attr('color','red');
	//$(idTag).attr('style','border:0px green dotted');
	
	var lTag = id;
	//if($('#'+currIndexTag))
		//$('#'+currIndexTag).attr('style','');
	var lrTag = '';
	if(id.indexOf('l')!=-1)
	{
		lrTag = 'r';
		id = id.replace('l','r');
	}
	else
	{
		lrTag = 'l';
		id = id.replace('r','l');
	}
	var rTag = id;
	idTag = tag+'.'+id;
	$(idTag).attr('bcolor',$(idTag).attr('color'));
	$(idTag).attr('color','red');
	//$(idTag).attr('style','border:0px green dotted');
	//alert($('#anchor').val())
	if($('#anchor').val()=='1')
		$('html,body').animate({scrollTop:$(idTag).offset().top}, 0);
	currIndexTag = id;
	$(o).connections('remove');
	$(o).connections({ to: '.'+rTag,  css: { color: '#ff00ff' } });
	if(!$(tag+"."+rTag).text())
	{
		
		$(tag+'font[id*='+lrTag+']').each(function()
		{
			var oText = $(o).text().replace(/\(\d\d?\)/i, "");
			var tText = $(this).text().replace(/\(\d\d?\)/i, "");
			//alert(tText+" "+oText+" "+tText.indexOf(oText));
			if(tText.indexOf(oText)!=-1)
			{
				$(this).attr('color','red');
				$(this).attr('style','border:0px green dotted');
				$(o).connections({ to: $(this),  css: { color: '#ff00ff' } });
			}
		});
	}
}
function spanMerge(o,end_index)
{
	var c = 0;
	//$(o).slice(0, end_index).each(function(){
	alert($(o).nextAll("*:lt(14)").length);
	$(o).nextAll("*:lt(14)").each(function(){
		c++;
		alert(c);
	
	});
}
function delKey(id,o)
{
	
	
	var ltTag = 'l'+id;
	var rtTag = 'r'+id;
	var lt = tag+'.'+ltTag;
	var rt = tag+'.'+rtTag;
	if($(o).attr('class')=='btn btn-danger btn-xs')
	{
		$(o).attr('class','btn-u btn-u-light-green');
		$(o).children('i').attr('class','fa fa-reply-all');
		$(lt).attr('color','');
		$(rt).attr('color','');
		$(lt).attr('style','');
		$(rt).attr('style','');
		$(lt).attr('onclick','');
		$(rt).attr('onclick','');
	}
	else
	{
		$(o).attr('class','btn btn-danger btn-xs');
		$(o).children('i').attr('class','fa fa-trash-o');
		lt = tag+'.'+ltTag+'';
	 	rt = tag+'.'+rtTag+'';
		
		$(lt).attr('color','blue');
		$(rt).attr('color','blue');

		$(lt).attr('onclick','mouseOver(this.className,this);');
		$(rt).attr('onclick','mouseOver(this.className,this);');
	}
}

