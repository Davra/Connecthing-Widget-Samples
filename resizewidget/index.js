var widgetId = widgetUtils.getUrlParameter("widgetid");
        
$.each($(top.window.document).find('iframe'), function(index, item) {
    if(item.id==="iframe-"+widgetId) {
        $($(top.window.document).find('iframe')[index]).closest('li').height(3000);
    }
});
