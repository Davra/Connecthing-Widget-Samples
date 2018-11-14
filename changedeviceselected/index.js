            
var devicefound = _.filter(alldevicesarr, function(item) {
    return item.id == event.target.options.id;
});

if(devicefound[0] !== undefined) {
    supercontext.filters.setTagValue({"deviceId": [Number(event.target.options.id)]});
    $(top.window.document).find('.deviceselector-value').html(devicefound[0].name)
      .attr("data-original-title", 
        '<p class="device-tooltip">' +
          '<div class="device-name">' + devicefound[0].name + '</div>' + 
          '<div>' + 
            '<span class="name">UUID:</span>' +
            '<span class="value">' + devicefound[0].UUID + '</span>' +
          '</div>' +
          '<div>' +
            '<span class="name">Serial #:</span>' +
            '<span class="value">' + devicefound[0].serialNumber + '</span>' +
          '</div>' + 
        '</p>');
}
