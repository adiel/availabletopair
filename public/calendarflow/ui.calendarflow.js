(function($)
    {jQuery.calendarFlow = {


        dayName : function (date) {
            switch (date.getUTCDay()) {
                case(0):
                    return "Sun";
                case(1):
                    return "Mon";
                case(2):
                    return "Tue";
                case(3):
                    return "Wed";
                case(4):
                    return "Thu";
                case(5):
                    return "Fri";
                case(6):
                    return "Sat";
            }
        },

        dayClass : function (date) {
            return this.dayName(date).toLowerCase();
        },

        getCSSTop:function (element) {
            return element.css("top").replace(/px/, '');
        },

        parseISODate : function(time) {
            return new Date(Date.parse(time.replace(/-/g, "/").replace(/[TZ]/g, " ")));
        },

        formatDateForClassName : function(date) {
            return date.getUTCFullYear() + '-' + date.getUTCMonth() + '-' + date.getUTCDate();
        },

        formatDateForDisplay : function(date) {
            return date.toUTCString()
        },

        formatTimeForDisplay : function (date) {
            return date.getHours() + ":" + date.getMinutes();
        },

        tooFarLeft : function(dayElement,context) {
            return ((dayElement.offset().left - context.offset().left) < (-1 * this.settings.preLoadSize));
        },

        tooFarRight : function(dayElement,context) {
            var visibleWidth = context.width();
            return (dayElement.offset().left > visibleWidth + this.settings.preLoadSize);
        },

        tooHigh : function (context) {
            var topPosition = this.getCSSTop($(".events",context));
            var halfTheVisibleHeight = (context.height() / 2);
            var theTopOfTheCurrentDay = -this.settings.dayHeight;
            return topPosition > theTopOfTheCurrentDay + halfTheVisibleHeight;
        },

        tooLow : function (context) {
            var topPosition = this.getCSSTop($(".events",context));
            var halfTheVisibleHeight = (context.height() / 2);
            var theTopOfTheNextDay = (-this.settings.dayHeight*2);
            return topPosition < theTopOfTheNextDay + halfTheVisibleHeight;
        },

        eventSummary : function (event) {
            return event.title + ' from ' +
                   this.formatDateForDisplay(this.parseISODate(event.start_time)) + " - " +
                   this.formatDateForDisplay(this.parseISODate(event.end_time));
        },

        dateOnly:function (time) {
            return time.toString().replace(/[0-9][0-9]:[0-9][0-9].*/, '');
        },

        newDayHeader : function(date) {

            var displayDate = date.getDate();
            if (this.settings.dayWidth > 30) {
                displayDate = (date.getMonth() + 1) + '/' + displayDate;
                if (this.settings.dayWidth > 70) {
                    displayDate = date.toString().substring(0,3) + ' ' + displayDate;
                    if (this.settings.dayWidth > 150) {
                        displayDate = this.dateOnly(date); 
                    }
                }
            }
            var element = $('<div class="dayHeader ' + this.dayClass(date) + '"><abbr title="' + this.dateOnly(date) + '">' + displayDate + '</abbr></div>');
            element.css("width",this.settings.dayWidth + "px");
            return element;
        },



        calculateHourHeight:function () {
            return Math.floor(this.settings.dayHeight / 24);
        },

        newDayEvents : function(date) {
            var element = $('<div class="day ' + this.dayClass(date) + ' dayEvents_' + this.formatDateForClassName(date) + ' date_' + date.getUTCDate() + '"></div>');
            element.css("width",(this.settings.dayWidth - 1) + "px");

            var css = {"height":this.settings.dayHeight + "px",
                       "background-image":"url(calendarFlow/events_bg_" + this.calculateHourHeight() + ".gif)"};
            $('<div class="prevDay"/>').css(css).appendTo(element);
            $('<div class="currentDay"/>').css(css).appendTo(element);
            $('<div class="nextDay"/>').css(css).appendTo(element);

            return element;
        },

        loadEventsRange : function(fromDate,toDate,context) {
            this.settings.findEventsCallback(fromDate,toDate,context);
        },
        
        loadEvents : function(date,context) {
            this.settings.findEventsCallback(date,date,context);
        },


        removeExistingEvent:function (event,dayOffset,context) {
            $("." + this.buildEventClassName(event,dayOffset), context).remove();
        },

        plotEventStartTime:function (startTime, dayOffset) {
            var positionInCurrentDay = Math.floor(this.getMinutesThroughTheDay(startTime) * (this.settings.dayHeight / 1440)) + this.settings.dayHeight;
            return positionInCurrentDay - (dayOffset  * this.settings.dayHeight);
        },

        getMinutesThroughTheDay:function (time) {
            return (time.getUTCHours() * 60) + time.getUTCMinutes();
        },

        getEventLengthMins:function (startTime, endTime) {
            // TODO: This only supports events shorter than 24 hrs
            var lengthMins = this.getMinutesThroughTheDay(endTime) - this.getMinutesThroughTheDay(startTime);
            if (lengthMins < 0) {
                lengthMins += 1440; // Into the next day
            }
            return lengthMins;
        },

        buildEventClassName : function(event,dayOffset) {
            return 'event_' + dayOffset + '_' + event.id;
        },

        buildEventElement:function (event, dayOffset, dayElement, top, height) {
            var eventElement = $('<div/>');
            eventElement.attr('class','event ' + this.buildEventClassName(event, dayOffset));
            eventElement.attr('title',this.eventSummary(event));
            eventElement.css({"position":"absolute",
                "top": top + "px",
                "left":"0px",
                "height":height + "px"});

            var titleElement = $('<h3/>');
            titleElement.html(event.title);
            eventElement.append(titleElement);

            var summaryElement = $('<div class="summary">');
            summaryElement.html(event.summary);
            eventElement.append(summaryElement);

            return eventElement;
        },

        addDays:function (date, interval) {
            var result = new Date(date);
            result.setDate(date.getDate() + interval);
            return result;
        },

        renderEvent : function(event,dayOffset,context) {
            this.removeExistingEvent(event,dayOffset,context);

            var startTime = this.parseISODate(event.start_time);
            var endTime = this.parseISODate(event.end_time);

            startTime = this.addDays(startTime, dayOffset);

            var top = this.plotEventStartTime(startTime, dayOffset);
            var height = Math.floor(this.getEventLengthMins(startTime, endTime) * (this.settings.dayHeight / 1440));

            var dayElement = $(".dayEvents_" + this.formatDateForClassName(startTime),context);
            this.buildEventElement(event, dayOffset, dayElement, top, height).prependTo(dayElement);
        },

        renderEvents : function(events,context) {
            var that = this;
            jQuery.each(events,function() {
                that.renderEvent(this.event,-1);
                that.renderEvent(this.event,0);
                that.renderEvent(this.event,1);
            });
        },

        setTimeToMidnight:function (date) {
            date.setHours(0);
            date.setMinutes(0);
            date.setSeconds(0);
        },

        readDateFromDayHeader:function (dayHeader) {
            var date = new Date(Date.parse($("abbr", dayHeader).attr("title")));
            this.setTimeToMidnight(date);
            date.setMinutes(date.getMinutes() - date.getTimezoneOffset());
            return date;
        },

        readHoursFromTimeHeader:function (timeHeader) {
            return Number($(timeHeader).text().substring(0,2));
        },

        readMinsFromTimeHeader:function (timeHeader) {
            return Number($(timeHeader).text().substring(3,5));
        },

        readOffsetFromTimeHeader:function (timeHeader) {
            if ($(timeHeader).hasClass("offset_-1")) {
                return -1;
            }
            else if ($(timeHeader).hasClass("offset_1")) {
                return 1;
            }
            else {
                return 0;
            }
        },

        positionNextDayElements:function (lastEventElement, dayHeader, dayEvents) {
            var oldLeft = Number(lastEventElement.css("left").replace(/px/, ''));
            var newLeft = (oldLeft + this.settings.dayWidth) + "px";
            $(dayHeader).css("left", newLeft);
            $(dayEvents).css("left", newLeft);
        },

        positionPreviousDayElements:function (firstEventElement, dayHeader, dayEvents) {
            var oldLeft = Number(firstEventElement.css("left").replace(/px/, ''));
            var newLeft = (oldLeft - this.settings.dayWidth) + "px";
            $(dayHeader).css("left", newLeft);
            $(dayEvents).css("left", newLeft);
        },

        newDayAhead : function (firstEventElement, firstDayElement, lastDayElement, lastEventElement,context) {
            firstEventElement.remove();
            firstDayElement.remove();

            var dateOfLastDay = this.readDateFromDayHeader(lastDayElement);
            var nextDay = this.addDays(dateOfLastDay,1);

            var dayHeader = this.newDayHeader(nextDay).appendTo($(".dayHeaders",context));
            var dayEvents = this.newDayEvents(nextDay).appendTo($(".events",context));

            this.positionNextDayElements(lastEventElement, dayHeader, dayEvents);

            return nextDay;
        },

        newDayBehind : function (firstEventElement, firstDayElement, lastDayElement, lastEventElement,context) {
            lastEventElement.remove();
            lastDayElement.remove();

            var dateOfFirstDay = this.readDateFromDayHeader(firstDayElement);
            var previousDay = this.addDays(dateOfFirstDay,-1);

            var dayHeader = this.newDayHeader(previousDay).prependTo($(".dayHeaders",context));
            var dayEvents = this.newDayEvents(previousDay).prependTo($(".events",context));

            this.positionPreviousDayElements(firstEventElement, dayHeader, dayEvents);

            return previousDay;
        },

        drawInitialDays : function (context) {
            var index,date,dayHeader,dayEvents,left,firstDay,lastDay;
            index = 0 - Math.floor(this.settings.preLoadSize / this.settings.dayWidth) + 2;
            do {
                firstDay = firstDay || date;
                lastDay = date;
                date = this.setTimeToMidnight(new Date(this.currentPosition));
                date = this.addDays(this.currentPosition,index);
                dayHeader = this.newDayHeader(date);
                dayEvents = this.newDayEvents(date);

                left = (this.settings.dayWidth * index) + "px";
                $(dayHeader).css("left", left);
                $(dayEvents).css("left", left);

                dayHeader.appendTo($(".dayHeaders",context));
                dayEvents.appendTo($(".events",context));

                index ++;
            }
            while (!this.tooFarLeft(dayEvents,context) && !this.tooFarRight(dayEvents,context) && index < 100)
            
            this.loadEventsRange(firstDay,lastDay,context);
        },

        drawTimeline : function(context) {
            var index,hour;
            for (index = 0;index < 72;index++) {

                var timeHeight = Math.floor(this.settings.dayHeight / 24);
                if (timeHeight < 15)  {
                    if (index % 2 != 0) {
                        continue;
                    }
                    else {
                        timeHeight *=2;
                    }
                }
                hour = (index % 24);
                if(hour < 10) hour = ("0" + hour);
                var offsetClass = "offset_" + (((index - hour) / 24) - 1); 
                var timeElement = $('<div class=\"time ' + offsetClass + '\">' + hour + ':00</div>');
                timeElement.css({height:timeHeight});
                $(".timeline",context).append(timeElement);
            }
        },

        buildScaleControls:function (context) {
            var controls = $('<div class="controls" ></div>');
            var that = this;
            $('<span>w:1000</span>').click(function() {
                that.settings.dayWidth = 1000;
                that.reset(context);
            }).appendTo(controls);
            $('<span>w:200</span>').click(function() {
                that.settings.dayWidth = 200;
                that.reset(context);
            }).appendTo(controls);
            $('<span>w:100</span>').click(function() {
                that.settings.dayWidth = 100;
                that.reset(context);
            }).appendTo(controls);
            $('<span>w:50</span>').click(function() {
                that.settings.dayWidth = 50;
                that.reset(context);
            }).appendTo(controls);
            $('<span>w:25</span>').click(function() {
                that.settings.dayWidth = 25;
                that.reset(context);
            }).appendTo(controls);
            $('<span>w:10</span>').click(function() {
                that.settings.dayWidth = 10;
                that.reset(context);
            }).appendTo(controls);

            $('<span>h:1440</span>').click(function() {
                that.settings.dayHeight = 1440;
                that.reset(context);
            }).appendTo(controls);
            $('<span>h:720</span>').click(function() {
                that.settings.dayHeight = 720;
                that.reset(context);
            }).appendTo(controls);
            $('<span>h:336</span>').click(function() {
                that.settings.dayHeight = 336;
                that.reset(context);
            }).appendTo(controls);

            return controls;
        },

        drawInnerContainers : function(context) {
            context.empty();
            $('<div class="daysWrapper">' +
              '    <div class="dayHeaders"></div>' +
              '</div>' +
              '<div class="timelineWrapper">' +
              '   <div class="timeline"></div>' +
              '</div>' +
              '<div class="calendarEventsWrapper">' +
              '    <div class="events"></div>' +
              '</div>').appendTo(context);

            this.buildScaleControls(context).appendTo(context);
        },

        redrawDays : function(context,firstNewDay,lastNewDay) {
            var eventsElements = $(".events .day",context);
            var daysElements = $(".dayHeaders .dayHeader",context);
            var firstEventElement = $(eventsElements[0]);
            var lastEventElement = $(eventsElements[eventsElements.length - 1]);
            var firstDayElement = $(daysElements[0]);
            var lastDayElement = $(daysElements[daysElements.length - 1]);

            clearTimeout(this.redrawDaysTimeout);
            if (jQuery.calendarFlow.tooFarLeft(firstEventElement,context)) {
                var newDayAhead = jQuery.calendarFlow.newDayAhead(firstEventElement, firstDayElement, lastDayElement, lastEventElement,context);
                firstNewDay = firstNewDay || newDayAhead;
                lastNewDay = newDayAhead;

                setTimeout(function() {jQuery.calendarFlow.redrawDays(context,firstNewDay,lastNewDay)},10);
                return;
            }
            else if (jQuery.calendarFlow.tooFarRight(lastEventElement,context)) {
                var newDayBehind = jQuery.calendarFlow.newDayBehind(firstEventElement, firstDayElement, lastDayElement, lastEventElement,context);
                lastNewDay = lastNewDay || newDayBehind;
                firstNewDay = newDayBehind;
                setTimeout(function() {jQuery.calendarFlow.redrawDays(context,firstNewDay,lastNewDay)},10);
                return;
            }
            if (firstNewDay && lastNewDay) {
                jQuery.calendarFlow.loadEventsRange(firstNewDay,lastNewDay,context);
            }
        },

        refocusCurrentDay : function(context) {
            var top = Number($(".events",context).css("top").replace(/px/,''));
            var left = Number($(".events",context).css("left").replace(/px/,''));
            if (this.tooHigh(context)) {
                $(".events",context).css("left", left + this.settings.dayWidth + "px");
                $(".events",context).css("top", top - this.settings.dayHeight + "px");
                this.syncAxes(context);
            }
            else if (this.tooLow(context)) {
                $(".events",context).css("left", left - this.settings.dayWidth + "px");
                $(".events",context).css("top", top + this.settings.dayHeight + "px");
                this.syncAxes(context);
            }
        },

        syncAxes : function(context) {
            var top = Number($(".events",context).css("top").replace(/px/,''));
            var left = Number($(".events",context).css("left").replace(/px/,''));
            $(".timeline",context).css("top", top + "px");
            $(".dayHeaders",context).css("left", left + "px");
        },

        dragged : function(event, ui) {
            var context = $(event.target).parent().parent();
            jQuery.calendarFlow.syncAxes(context);
            //clearTimeout(this.redrawDaysTimeout);
            //this.redrawDaysTimeout = setTimeout(function() {jQuery.calendarFlow.redrawDays(context)},1000);
        },

        stopped : function(event, ui) {
            var context = $(event.target).parent().parent();
            jQuery.calendarFlow.redrawDays(context);
            jQuery.calendarFlow.refocusCurrentDay(context);
            jQuery.calendarFlow.syncAxes(context);
            jQuery.calendarFlow.currentPosition = jQuery.calendarFlow.findCurrentPosition(context);
        },

        activateDraggable:function (context) {
            $(".events",context).draggable({
                drag: this.dragged,
                stop : this.stopped,
                cursor: "move"
            });
        },

        addRootClass:function (context) {
            context.addClass("calendarFlow");
        },

        setScale : function(context,settings) {
            $('.calendarEventsWrapper',context).css({
                top:'-' + ((this.settings.dayHeight * 3) + 20) + 'px'
            });

            $('.timeline, .events',context).css ({
                height: (this.settings.dayHeight * 3) + "px",
                top:"-" + (this.settings.dayHeight - 20) + "px"
            });
        },

        findCurrentPosition : function(context) {
            var dayHeader,timeHeader;
            var that = this;
            $(".dayHeader",context).each(function() {
                var leftOffset = ($(this).offset().left - context.offset().left);
                if (leftOffset > 0 && leftOffset < that.settings.dayWidth) {
                    dayHeader = this;
                    return false;
                }
            });
            $(".time",context).each(function() {
               var topOffset = ($(this).offset().top - context.offset().top);
                if (topOffset > 0 && topOffset < that.settings.dayHeight) {
                    timeHeader = this;
                    return false;
                }
            });
            var date = this.readDateFromDayHeader(dayHeader);
            var offset = this.readOffsetFromTimeHeader(timeHeader);
            date = this.addDays(date,offset);
            
            var hours = this.readHoursFromTimeHeader(timeHeader);
            var mins = this.readMinsFromTimeHeader(timeHeader);
            date.setHours(hours,mins);

            return date;        
        },

        moveTo : function(time) {

        },


        reset:function (context) {
            this.addRootClass(context);
            this.drawInnerContainers(context);
            this.setScale(context);
            this.drawTimeline(context);
            this.drawInitialDays(context);
            this.activateDraggable(context);
        },

        init : function(context,settings) {
            if (context.length == 0) return;
            this.settings = settings;
            this.currentPosition = this.currentPosition || new Date();
            this.setTimeToMidnight(this.currentPosition);
            this.reset(context);
        }
    };

    jQuery.fn.calendarFlow = function(options) {
        var settings = jQuery.extend({
                "dayWidth"  : 150,
                "dayHeight" : 1440,
                "preLoadSize" : 2000,
                "findEventsCallback"  : function() {return [];}
            },options);
        this.each(function(){
            jQuery.calendarFlow.init($(this),settings);
        });

        return this;
    };
})(jQuery);
