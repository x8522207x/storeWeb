$(document).ready(function () {
   $(".union-catalogs-list-title").click(function(){
        $(this).next(".union-catalogs-list-content").slideToggle();
        $(this).toggleClass("union-catalogs-list-close");
   });
    
    
    
    //自動計算高度    
    ;( function( $, window, document, undefined )
    {
        'use strict';

        var $list       = $( '.list' ),
            $items      = $list.find( '.list_item' ),
            setHeights  = function()
            {
                $items.css( 'height', 'auto' );

                var perRow = Math.floor( $list.width() / $items.width() );
                if( perRow == null || perRow < 2 ) return true;

                for( var i = 0, j = $items.length; i < j; i += perRow )
                {
                    var maxHeight   = 0,
                        $row        = $items.slice( i, i + perRow );

                    $row.each( function()
                    {
                        var itemHeight = parseInt( $( this ).outerHeight() );
                        if ( itemHeight > maxHeight ) maxHeight = itemHeight;
                    });
                    $row.css( 'height', maxHeight );
                }
            };

        setHeights();
        $( window ).on( 'resize', setHeights );
        $list.find( 'img' ).on( 'load', setHeights );
        
    })( jQuery, window, document );    
 
    
});

function posIndexContent() {
    var browserW = $(window).width();
    var browserH = $(window).height();

    var objW = $(".index-section-content").width();
    var posLeft = Math.ceil((browserW - objW) / 2);
    $(".index-section-content").css("left", posLeft);

    var obj2W = $(".index-section-content2").width();
    var obj2H = $(".index-section-content2").height();
    var section2H = $(".index-section2").height();
    var posLeft2 = Math.ceil((browserW - obj2W) / 2);
    var posTop2 = Math.ceil((section2H - obj2H) / 2);
    $(".index-section-content2").css("left", posLeft2);
    $(".index-section-content2").css("top", posTop2);

    var section3H = $(".index-section3").height();
    var obj3W = $(".index-section-content3").width();
    var obj3H = $(".index-section-content3").height();
    var posLeft3 = Math.ceil((browserW - obj3W) / 2);
    var posTop3 = Math.ceil((section3H - obj3H) / 2);
    $(".index-section-content3").css("left", posLeft3);
    $(".index-section-content3").css("top", posTop3);
}



//定位語法範例
/*function posBackTop(){
    var browserW = $(window).width();
	var browserH = $(window).height();
	var posRight = Math.ceil((browserW-1000)/2)-90;
	$(".backTop").css("right",posRight);
}*/



