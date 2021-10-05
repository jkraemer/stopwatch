window.initStopwatch = function(config){
  var currentTimerUrl = config.currentTimerUrl;
  var hourFormat = config.hourFormat;

  var hoursRe = hourFormat.replace(/0+/g, '\\d+').replace(/\./g, '\\.');
  var titleRegexp = new RegExp('^(' + hoursRe + ' - )?(.*)$');
  var menuItemRegexp = new RegExp('^(.*?)( \\(' + hoursRe + '\\))?$')

  var highlightTimer = function(id, timeHtml){
    $('table.time-entries tr.time-entry.running').removeClass('running');
    if(id && id != ''){
      $('table.time-entries tr.time-entry').each(function(idx, el){
        var tr = $(el);
        var trId = tr.attr('id');
        if (trId && trId == 'time-entry-'+id) {
          tr.addClass('running');
          if (timeHtml) {
            tr.find('td.hours').html(timeHtml)
          }
        }
      });
    }
  };

  var updateSpentTime = function(entryId, spentTime){
    // update window title
    var s = ''
    if (spentTime){
      s = spentTime + ' - ';
    }
    var match = titleRegexp.exec(document.title);
    document.title = s + match[2];

    // update menu item
    match = menuItemRegexp.exec($('a#stopwatch-menu').text());
    if (spentTime){
      s = ' (' + spentTime + ')';
    } else {
      s = '';
    }
    $('a#stopwatch-menu').text(match[1] + s);
  };

  var highlightRunningTimer = function(data){
    if (data && data.running && data.time_entry_id) {
      highlightTimer(data.time_entry_id, data.html_time_spent);
      updateSpentTime(data.time_entry_id, data.time_spent);
      window.setTimeout(function(){
        fetchCurrentTimer(highlightRunningTimer);
      }, 60000);
    } else {
      highlightTimer();
      updateSpentTime();
    }
  };

  var fetchCurrentTimer = function(successHandler){
    $.ajax(currentTimerUrl, {
      type: 'GET',
      contentType: 'application/octet-stream', // suppress the ajax-indicator that's bound to ajax events in application.js
      success: successHandler
    });
  };

  //$(document).on('ready', fetchCurrentTimer(highlightRunningTimer));

  return({
    highlightRunningTimer: highlightRunningTimer,
    timerStopped: function(){
      highlightRunningTimer();
    },
    timerStarted: function(entryId, spentTime){
      highlightRunningTimer({
        running: true,
        time_entry_id: entryId,
        time_spent: spentTime
      });
    },
    setProjectId: function(projectId){
      var a = $('a#stopwatch-menu');
      a.attr('href', a.attr('href').replace(/\/new.*$/, '/new?project_id='+projectId));
    }
  });
};

