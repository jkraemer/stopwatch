window.Stopwatch = {
  highlightRunningTimer: function(){
    $.get(Stopwatch.currentTimerUrl, function(data){
      if (data.running && data.time_entry_id) {
        Stopwatch.highlightTimer(data.time_entry_id);
      }
    });
  },

  highlightTimer: function(id){
    $('table.time-entries tr.time-entry.running').removeClass('running');
    if(id && id != ''){
      $('table.time-entries tr.time-entry').each(function(idx, el){
        var tr = $(el);
        var trId = tr.attr('id');
        if (trId && trId == 'time-entry-'+id) {
          tr.addClass('running');
        }
      });
    }
  }
};

$(document).on('ready', Stopwatch.highlightRunningTimer);
