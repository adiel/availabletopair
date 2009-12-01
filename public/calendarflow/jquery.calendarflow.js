
(function($) {
    /*global jQuery : false, window : false */
    jQuery.calendarFlow = {};

    jQuery.calendarFlow.datetime = {

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

        getMinutesThroughTheDay : function(time) {
            return (time.getUTCHours() * 60) + time.getUTCMinutes();
        },

        addDays : function(date, interval) {
            var result = new Date(date);
            result.setDate(date.getDate() + interval);
            return result;
        },

        addMins : function(date, interval) {
            var result = new Date(date);
            result.setMinutes(date.getMinutes() + interval);
            return result;
        },

        setTimeToMidnight : function(date) {
            date.setHours(0);
            date.setMinutes(0);
            date.setSeconds(0);
        },


        formatDateForClassName : function(date) {
            return date.getUTCFullYear() + '-' + date.getUTCMonth() + '-' + date.getUTCDate();
        },

        formatDateForDisplay : function(date) {
            return date.toUTCString();
        },

        dayClass : function(date) {
            return "cal-flow-" + this.dayName(date).toLowerCase();
        },

        dateOnly : function(time) {
            return time.toString().replace(/[0-9][0-9]:[0-9][0-9]:[0-9][0-9]/, '').replace(/\+[0-9][0-9][0-9][0-9]/, '').replace(/\(.*\)/, '').replace(/GMT|UTC/, '');
        }
    };

    jQuery.calendarFlow.positioning = {

        getCSSTop : function(element) {
            return element.css("top").replace(/px/, '');
        },

        tooFarLeft : function(dayElement,container,preLoadSize) {
            return ((dayElement.offset().left - container.offset().left) < (-1 * preLoadSize));
        },

        tooFarRight : function(dayElement,container,preLoadSize) {
            var visibleWidth = container.width();
            return (dayElement.offset().left > visibleWidth + preLoadSize);
        },

        tooHigh : function(container,dayHeight) {
            var topPosition = this.getCSSTop($(".cal-flow-events",container));
            var halfTheVisibleHeight = (container.height() / 2);
            var theTopOfTheCurrentDay = -dayHeight;
            return topPosition > theTopOfTheCurrentDay + halfTheVisibleHeight;
        },

        tooLow : function(container,dayHeight) {
            var topPosition = this.getCSSTop($(".cal-flow-events",container));
            var halfTheVisibleHeight = (container.height() / 2);
            var theTopOfTheNextDay = (-dayHeight*2);
            return topPosition < theTopOfTheNextDay + halfTheVisibleHeight;
        }
    };

    jQuery.calendarFlow.eventRenderer = {
        datetime : jQuery.calendarFlow.datetime,

        eventSummary : function(event) {
            return event.title + ' from ' +
                   this.datetime.formatDateForDisplay(event.start_time) + " - " +
                   this.datetime.formatDateForDisplay(event.end_time);
        },

        updateDayTotal:function (event,container,days) {
            var dayHeaderElement = $(".cal-flow-dayHeader_" + this.datetime.formatDateForClassName(event.start_time), container);
            var eventCountElement = $("span", dayHeaderElement);
            var newTotal = Number(eventCountElement.text()) + days;
            eventCountElement.text(newTotal);
            if (newTotal > 0) {
                dayHeaderElement.css("font-weight","bold");
            }
        },

        removeExistingEvent : function(event,dayOffset,container) {
            var existing = $("." + this.buildEventClassName(event,dayOffset),container);
            existing.remove();
            if (existing.length > 0 && dayOffset === 0) {
                this.updateDayTotal(event,container,-1);
            }
        },

        plotEventStartTime : function(startTime, dayOffset,dayHeight) {
            var positionInCurrentDay = Math.floor(this.datetime.getMinutesThroughTheDay(startTime) * (dayHeight / 1440)) + dayHeight;
            return positionInCurrentDay - (dayOffset  * dayHeight);
        },

        getEventLengthMins : function(startTime, endTime) {
            // TODO: This only supports events shorter than 24 hrs
            var lengthMins = this.datetime.getMinutesThroughTheDay(endTime) -
                             this.datetime.getMinutesThroughTheDay(startTime);
            if (lengthMins < 0) {
                lengthMins += 1440; // Into the next day
            }
            return lengthMins;
        },

        buildEventClassName : function(event,dayOffset) {
            return 'cal-flow-event_' + dayOffset + '_' + event.id;
        },

        isOverflowing: function(el) {
           var curOverflow = el.style.overflow;
           if ( !curOverflow || curOverflow === "visible" ) {
              el.style.overflow = "hidden";
           }

           var isOverflowing = el.clientWidth < el.scrollWidth || el.clientHeight < el.scrollHeight;

           el.style.overflow = curOverflow;

           return isOverflowing;
        },

        buildEventElement : function(event, dayOffset, dayElement, top, height, overlapping, overlapPosition,dayWidth) {
            var eventElement = $('<div/>');
            eventElement.attr('class','cal-flow-event ' + this.buildEventClassName(event, dayOffset));
            var width = Math.floor(dayWidth / overlapping);
            var left = (width * overlapPosition);
            eventElement.css({"position":"absolute",
                "top": top + "px",
                "left": left +  "px",
                "height":height + "px",
                "width" : (width - 1) + "px"});

            var titleElement = $('<h3/>');
            titleElement.html(event.title);
            eventElement.append(titleElement);

            var summaryElement = $('<div class="cal-flow-summary">');
            summaryElement.html(event.summary);
            eventElement.append(summaryElement);

            return eventElement;
        },

        addEventTooltip : function(eventElement) {
            if (this.isOverflowing(eventElement[0])) {
                eventElement.qtip(
                {
                    content: eventElement.html(),
                    position:{ target: 'mouse', adjust: { x: 20, y: 20 } },
                    hide: {
                        fixed: true
                    },
                    style: {
                        padding:"0"
                    }
                });
            }
        },

        dropEvent : function (currentEvent,eventElement,originalPosition,dayWidth,dayHeight,container,moveEventCallback) {
            var newPosition = eventElement.position();
            var daysDelta = Math.floor((newPosition.left - originalPosition.left) / dayWidth);
            var minutesDelta = Math.floor(((newPosition.top - originalPosition.top) / dayHeight) * 1440);

            var newStartTime = this.datetime.addDays(currentEvent.start_time, daysDelta);
            currentEvent.start_time = this.datetime.addMins(newStartTime, minutesDelta);

            var newEndTime = this.datetime.addDays(currentEvent.end_time, daysDelta);
            currentEvent.end_time = this.datetime.addMins(newEndTime, minutesDelta);

            this.renderEvents([{event : currentEvent}], container, dayHeight, dayWidth,moveEventCallback);
            moveEventCallback(currentEvent);
        },

        makeEventDraggable:function (event, eventElement, dayWidth, dayHeight, container, moveEventCallback) {
            var originalPosition = eventElement.position();
            var currentEvent = event;
            var that = this;
            eventElement.draggable({
                grid : [dayWidth,Math.floor((dayHeight / 1440) * 30)],
                stop : function(event, ui) {
                    that.dropEvent(currentEvent, eventElement, originalPosition, dayWidth, dayHeight, container, moveEventCallback);
                },
                cursor: "move"
            });
        },

        renderEvent : function(event,dayOffset,container,dayHeight,dayWidth,events,moveEventCallback) {
            this.removeExistingEvent(event,dayOffset,container);
            var that = this;

            var overlappingEvents = 0;
            var overlapPosition = 0;
            $.each(events,function(index) {
                if (this.start_time < event.end_time && this.end_time > event.start_time) {
                    overlappingEvents ++;
                    if (this.id == event.id) {
                        overlapPosition = overlappingEvents - 1;
                    }
                }
            });

            var startTime = event.start_time;
            var endTime = event.end_time;

            startTime = this.datetime.addDays(startTime, dayOffset);

            var top = this.plotEventStartTime(startTime, dayOffset, dayHeight);
            var height = Math.floor(this.getEventLengthMins(startTime, endTime) * (dayHeight / 1440));

            var dayElement = $(".cal-flow-dayEvents_" + this.datetime.formatDateForClassName(startTime),container);
            var eventElement = this.buildEventElement(event, dayOffset, dayElement, top, height,overlappingEvents,overlapPosition,dayWidth);
            dayElement.prepend(eventElement);

            this.addEventTooltip(eventElement);
            // TODO: more thought needed...
            //this.makeEventDraggable(event, eventElement, dayWidth, dayHeight, container, moveEventCallback);
        },

        saveEvents : function(events) {
            this.events = this.events || {};
            var that = this;
            $.each(events, function() {
                that.events[this.event.id] = this.event;
            });
        },

        renderEvents : function(events,container,dayHeight,dayWidth,moveEventCallback) {
            this.saveEvents(events);
            var that = this;
            jQuery.each(events,function() {
                that.renderEvent(this.event,-1,container,dayHeight,dayWidth,that.events,moveEventCallback);
                that.renderEvent(this.event,0,container,dayHeight,dayWidth,that.events,moveEventCallback);
                that.renderEvent(this.event,1,container,dayHeight,dayWidth,that.events,moveEventCallback);

                // TODO, this one is only needed if the event crosses midnight.
                that.renderEvent(this.event,2,container,dayHeight,dayWidth,that.events,moveEventCallback);

                that.updateDayTotal(this.event,container,1);
            });
        }



    };

    jQuery.calendarFlow.Calendar = function(container,settings) {

        this.container = container;
        this.settings = settings;
        this.dayHeightOptions = [336,720,1440];
        this.visibleEventsReloadTimeoutMS = 60000;
        this.datetime = jQuery.calendarFlow.datetime;
        this.positioning = jQuery.calendarFlow.positioning;
        this.eventRenderer = jQuery.calendarFlow.eventRenderer;

        this.renderEvents = function (events) {
            this.eventRenderer.renderEvents(events,this.container,this.settings.dayHeight,this.settings.dayWidth,this.settings.moveEventCallback);
        };

        this.loadEventsRange = function(fromDate,toDate) {
            // TODO: Clear out this.events for this date range, or removed events will be re-rendered.
            this.settings.findEventsCallback(fromDate,toDate,this);
        };



        /* DAY BUILDER */

        this.newDayHeader = function(date) {

            var displayDate = date.getDate();
            if (this.settings.dayWidth > 30) {
                displayDate = (date.getMonth() + 1) + '/' + displayDate;
                if (this.settings.dayWidth > 70) {
                    displayDate = date.toString().substring(0,3) + ' ' + displayDate;
                    if (this.settings.dayWidth > 150) {
                        displayDate = this.datetime.dateOnly(date);
                    }
                }
            }
            var element = $('<div class="cal-flow-dayHeader ' +
                            ' cal-flow-dayHeader_' + this.datetime.formatDateForClassName(date) +
                            ' ' + this.datetime.dayClass(date) + '">' +
                                '<abbr title="' + this.datetime.dateOnly(date) + '">' + displayDate + '</abbr> (<span>0</span>)' +
                            '</div>');
            element.css("width",this.settings.dayWidth + "px");
            return element;
        };

        this.newDayEvents = function(date) {
            var element = $('<div class="cal-flow-day ' + this.datetime.dayClass(date) +
                                       ' cal-flow-dayEvents_' + this.datetime.formatDateForClassName(date) +
                                       ' cal-flow-date_' + date.getUTCDate() + '"></div>');
            element.css("width",(this.settings.dayWidth - 1) + "px");

            var hourHeight = Math.floor(this.settings.dayHeight / 24);
            var css = {"height":this.settings.dayHeight + "px",
                       "background-image":"url(/calendarflow/events_bg_" + hourHeight + ".gif)"};
            $('<div class="cal-flow-prevDay"/>').css(css).appendTo(element);
            $('<div class="cal-flow-currentDay"/>').css(css).appendTo(element);
            $('<div class="cal-flow-nextDay"/>').css(css).appendTo(element);

            return element;
        };



        /* HEADERS */

        this.readDateFromDayHeader = function(dayHeader) {
            var parsed = Date.parse($("abbr", dayHeader).attr("title"));
            var date = new Date(parsed);
            this.datetime.setTimeToMidnight(date);
            date.setMinutes(date.getMinutes() - date.getTimezoneOffset());
            return date;
        };

        this.readHoursFromTimeHeader = function(timeHeader) {
            return Number($(timeHeader).text().substring(0,2));
        };

        this.readMinsFromTimeHeader = function(timeHeader) {
            return Number($(timeHeader).text().substring(3,5));
        };

        this.readOffsetFromTimeHeader = function(timeHeader) {
            if ($(timeHeader).hasClass("offset_-1")) {
                return -1;
            }
            else if ($(timeHeader).hasClass("offset_1")) {
                return 1;
            }
            else {
                return 0;
            }
        };


        /* DAY MANAGER */

        this.positionNextDayElements=function(lastEventElement, dayHeader, dayEvents) {
            var oldLeft = Number(lastEventElement.css("left").replace(/px/, ''));
            var newLeft = (oldLeft + this.settings.dayWidth) + "px";
            $(dayHeader).css("left", newLeft);
            $(dayEvents).css("left", newLeft);
        };

        this.positionPreviousDayElements=function(firstEventElement, dayHeader, dayEvents) {
            var oldLeft = Number(firstEventElement.css("left").replace(/px/, ''));
            var newLeft = (oldLeft - this.settings.dayWidth) + "px";
            $(dayHeader).css("left", newLeft);
            $(dayEvents).css("left", newLeft);
        };

        this.newDayAhead = function(firstEventElement, firstDayElement, lastDayElement, lastEventElement) {
            firstEventElement.remove();
            firstDayElement.remove();

            var dateOfLastDay = this.readDateFromDayHeader(lastDayElement);
            var nextDay = this.datetime.addDays(dateOfLastDay,1);

            var dayHeader = this.newDayHeader(nextDay).appendTo($(".cal-flow-dayHeaders",this.container));
            var dayEvents = this.newDayEvents(nextDay).appendTo($(".cal-flow-events",this.container));

            this.positionNextDayElements(lastEventElement, dayHeader, dayEvents);

            return nextDay;
        };

        this.newDayBehind = function(firstEventElement, firstDayElement, lastDayElement, lastEventElement) {
            lastEventElement.remove();
            lastDayElement.remove();

            var dateOfFirstDay = this.readDateFromDayHeader(firstDayElement);
            var previousDay = this.datetime.addDays(dateOfFirstDay,-1);

            var dayHeader = this.newDayHeader(previousDay).prependTo($(".cal-flow-dayHeaders",this.container));
            var dayEvents = this.newDayEvents(previousDay).prependTo($(".cal-flow-events",this.container));

            this.positionPreviousDayElements(firstEventElement, dayHeader, dayEvents);

            return previousDay;
        };

        this.drawInitialDays = function() {
            var dayIndex,date,dayHeader,dayEvents,left,firstDay,lastDay;
            var noOfExtraDaysToDisplayOnLeft = Math.floor(this.settings.preLoadSize / this.settings.dayWidth) - 2;
            var daysToCenter = Math.floor(((this.container.width()/2) / this.settings.dayWidth)) - 1;
            var firstVisibleDay = this.datetime.addDays(this.currentPosition,-daysToCenter);
            dayIndex = 0 - noOfExtraDaysToDisplayOnLeft;
            do {
                date = this.datetime.setTimeToMidnight(new Date(firstVisibleDay));
                date = this.datetime.addDays(firstVisibleDay,dayIndex);

                firstDay = firstDay || date;
                lastDay = date;

                dayHeader = this.newDayHeader(date);
                dayEvents = this.newDayEvents(date);

                left = (this.settings.dayWidth * dayIndex) + "px";
                $(dayHeader).css("left", left);
                $(dayEvents).css("left", left);

                dayHeader.appendTo($(".cal-flow-dayHeaders",this.container));
                dayEvents.appendTo($(".cal-flow-events",this.container));

                dayIndex ++;
            }
            while (!this.positioning.tooFarLeft(dayEvents,this.container,this.settings.preLoadSize) &&
                   !this.positioning.tooFarRight(dayEvents,this.container,this.settings.preLoadSize));

            this.loadEventsRange(firstDay,lastDay);
        };

        this.drawExtraDays = function(firstNewDay,lastNewDay) {
            var that = this;
            var eventsElements = $(".cal-flow-events .cal-flow-day",this.container);
            var daysElements = $(".cal-flow-dayHeaders .cal-flow-dayHeader",this.container);
            var firstEventElement = $(eventsElements[0]);
            var lastEventElement = $(eventsElements[eventsElements.length - 1]);
            var firstDayElement = $(daysElements[0]);
            var lastDayElement = $(daysElements[daysElements.length - 1]);

            window.clearTimeout(this.redrawDaysTimeout);
            if (this.positioning.tooFarLeft(firstEventElement,this.container,this.settings.preLoadSize)) {
                var dayAhead = this.newDayAhead(firstEventElement, firstDayElement, lastDayElement, lastEventElement);
                firstNewDay = firstNewDay || dayAhead;
                lastNewDay = dayAhead;
                window.setTimeout(function() {that.drawExtraDays(firstNewDay,lastNewDay);},10);
                return;
            }
            else if (this.positioning.tooFarRight(lastEventElement,this.container,this.settings.preLoadSize)) {
                var dayBehind = this.newDayBehind(firstEventElement, firstDayElement, lastDayElement, lastEventElement);
                lastNewDay = lastNewDay || dayBehind;
                firstNewDay = dayBehind;
                window.setTimeout(function() {that.drawExtraDays(firstNewDay,lastNewDay);},10);
                return;
            }
            if (firstNewDay && lastNewDay) {
                this.loadEventsRange(firstNewDay,lastNewDay);
            }
        };



        /* TIMELINE */

        this.drawTimeline = function() {
            var index,hour;
            for (index = 0;index < 72;index++) {

                var timeHeight = Math.floor(this.settings.dayHeight / 24);
                if (timeHeight < 15)  {
                    if (index % 2 !== 0) {
                        continue;
                    }
                    else {
                        timeHeight *=2;
                    }
                }
                hour = (index % 24);
                if(hour < 10) {hour = ("0" + hour);}
                var offsetClass = "offset_" + (((index - hour) / 24) - 1);
                var timeElement = $('<div class=\"cal-flow-time ' + offsetClass + '\">' + hour + ':00</div>');
                timeElement.css({height:timeHeight});
                $(".cal-flow-timeline",this.container).append(timeElement);
            }

        };



        /* SCALE */

        this.buildWidthScaleControl = function() {
            var that = this;
            var widthSlider = $('<div/>');
            widthSlider.slider({
                min:35,
                max:1000,
                value:this.settings.dayWidth,
                change: function(event, ui) {
                    window.clearTimeout(that.setDayWidthTimeout);
                    that.setDayWidthTimeout = window.setTimeout(function() {
                        that.setDayWidth(Number(ui.value),that.container);
                    },500);
                }
            });
            return widthSlider;
        };

        this.buildHeightScaleControl = function() {
            var that = this;
            var heightSlider = $('<div/>');
            heightSlider.slider({
                orientation: 'vertical',
                step: 1,
                min: 0,
                max: 2,
                value:$.inArray(this.settings.dayHeight, this.dayHeightOptions),
                change: function(event, ui) {
                    window.clearTimeout(that.setDayHeightTimeout);
                    that.setDayHeightTimeout = window.setTimeout(function() {
                        that.setDayHeight(that.dayHeightOptions[Number(ui.value)],that.container);
                    },500);
                }
            });
            return heightSlider;
        };

        this.wrapSlider = function(widthSlider) {
            return $('<div class="cal-flow-controls"/>').append(widthSlider);
        };

        this.buildScaleControls=function() {
            var widthSlider = this.buildWidthScaleControl(this.container);
            var heightSlider = this.buildHeightScaleControl(this.container);
            return $([this.wrapSlider(widthSlider),this.wrapSlider(heightSlider)]);
        };

        this.setScale = function() {
            $('.cal-flow-calendarEventsWrapper',this.container).css({
                top:'-' + ((this.settings.dayHeight * 3) + 20) + 'px'
            });

            $('.cal-flow-timeline, .cal-flow-events',this.container).css ({
                height: (this.settings.dayHeight * 3) + "px",
                top:"-" + (this.settings.dayHeight - 20) + "px"
            });
        };

        this.repositionScaleControls = function() {
            $('.cal-flow-controls').css("top", (this.container.height() - 120) +  "px");
            $('.cal-flow-controls').css("display", "block");
        };

        /** END SCALE **/



        this.drawInnerContainers = function() {
            $(".cal-flow-daysWrapper,.cal-flow-timelineWrapper,.cal-flow-calendarEventsWrapper").remove();
            $('<div class="cal-flow-daysWrapper">' +
              '    <div class="cal-flow-dayHeaders"></div>' +
              '</div>' +
              '<div class="cal-flow-timelineWrapper">' +
              '   <div class="cal-flow-timeline"></div>' +
              '</div>' +
              '<div class="cal-flow-calendarEventsWrapper">' +
              '    <div class="cal-flow-events"></div>' +
              '</div>').appendTo(this.container);
        };

         this.focusCurrentTime = function ($) {
            var nowTop = -1 * (this.settings.dayHeight * ((new Date().getHours() - 3) / 24));
            $(".cal-flow-events", this.container).css("top", nowTop + "px");
            this.syncAxes();
        };

        this.refocusCurrentDay = function() {
            var events = $(".cal-flow-events",this.container);
            var top = Number(events.css("top").replace(/px/,''));
            var left = Number(events.css("left").replace(/px/,''));
            if (this.positioning.tooHigh(this.container,this.settings.dayHeight)) {
                events.css("left", left + this.settings.dayWidth + "px");
                events.css("top", top - this.settings.dayHeight + "px");
                this.syncAxes();
            }
            else if (this.positioning.tooLow(this.container,this.settings.dayHeight)) {
                events.css("left", left - this.settings.dayWidth + "px");
                events.css("top", top + this.settings.dayHeight + "px");
                this.syncAxes();
            }
        };

        this.syncAxes = function() {
            var top = Number($(".cal-flow-events",this.container).css("top").replace(/px/,''));
            var left = Number($(".cal-flow-events",this.container).css("left").replace(/px/,''));
            $(".cal-flow-timeline",this.container).css("top", top + "px");
            $(".cal-flow-dayHeaders",this.container).css("left", left + "px");
        };

        this.dragged = function(event, ui) {
            this.syncAxes();
        };

        this.updateCurrentPosition = function() {
            this.currentPosition = this.findCurrentPosition();
        };

        this.stopped = function(event, ui) {
            this.drawExtraDays();
            this.refocusCurrentDay();
            this.syncAxes();
            this.updateCurrentPosition();
        };

        this.activateDraggable = function() {
            var that = this;
            $(".cal-flow-events",this.container).draggable({
                drag : function(event,ui) {that.dragged(event,ui);},
                stop : function(event,ui) {that.stopped(event,ui);},
                cursor: "move"
            });
        };

        this.addRootClass = function() {
            this.container.addClass("cal-flow");
        };


        this.findCurrentPosition = function() {
            var dayHeader,timeHeader;
            var that = this;
            $(".cal-flow-dayHeader",this.container).each(function() {
                var leftOffset = ($(this).offset().left - that.container.offset().left);
                var midpoint = that.container.width()/2;
                if (leftOffset < midpoint && (leftOffset + that.settings.dayWidth) > midpoint) {
                    dayHeader = this;
                    return false;
                }
            });
            $(".cal-flow-time",this.container).each(function() {
                var topOffset = ($(this).offset().top - that.container.offset().top);
                var midpoint = that.container.height()/2;
                if (topOffset < midpoint & (topOffset + that.settings.dayHeight) > midpoint) {
                    timeHeader = this;
                    return false;
                }
            });
            var date = this.readDateFromDayHeader(dayHeader);
            var offset = this.readOffsetFromTimeHeader(timeHeader);
            date = this.datetime.addDays(date,offset);
            var hours = this.readHoursFromTimeHeader(timeHeader);
            var mins = this.readMinsFromTimeHeader(timeHeader);
            date.setHours(hours,mins);

            return date;
        };


        this.setDayWidth = function(width) {
            if (this.settings.dayWidth != width) {
                this.settings.dayWidth = width;
                this.reset();
            }
        };

        this.setDayHeight = function(height) {
            if (this.settings.dayHeight != height) {
                this.settings.dayHeight = height;
                this.reset();
            }
        };

        this.startVisibleEventsReloadTimeout = function () {
            var that = this;
            this.visibleEventsReloadTimeout = window.setTimeout(function() {
                var daysElements = $(".cal-flow-dayHeaders .cal-flow-dayHeader",this.container);
                var firstDayElement = $(daysElements[0]);
                var lastDayElement = $(daysElements[daysElements.length - 1]);
                var from = that.readDateFromDayHeader(firstDayElement);
                var to = that.readDateFromDayHeader(lastDayElement);
                that.loadEventsRange(from,to);
                that.startVisibleEventsReloadTimeout();
            },this.visibleEventsReloadTimeoutMS);
        };

        this.reset = function() {
            window.clearTimeout(this.visibleEventsReloadTimeout);
            this.addRootClass();
            this.drawInnerContainers();
            this.setScale();
            this.drawTimeline();
            this.drawInitialDays();
            this.updateCurrentPosition();

            this.focusCurrentTime($);
            this.activateDraggable();
            this.repositionScaleControls();
            this.startVisibleEventsReloadTimeout();
        };

        this.init = function() {
            if (this.container.length === 0) {return;}
            this.currentPosition = this.currentPosition || new Date();
            this.datetime.setTimeToMidnight(this.currentPosition);
            this.reset();
            this.buildScaleControls(this.container).appendTo(this.container);

            var that = this;
            var resizeTimer = null;
            $(window).resize(function() {
                if (resizeTimer) {window.window.clearTimeout(resizeTimer);}
                resizeTimer = window.window.setTimeout(function() {that.repositionScaleControls(this.container);},200);
            });
            window.window.setTimeout(function() {that.repositionScaleControls(this.container);},200);
        };

        this.init(this.container,settings);
    };

    $.fn.calendarFlow = function(options) {
        var settings = $.extend({
                "dayWidth"  : 150,
                "dayHeight" : 1440,
                "preLoadSize" : 2000,  //TODO: less for ie
                "findEventsCallback"  : function() {return [];},
                "moveEventCallback"  : function() {return [];}
            },options);
        this.each(function(){
            this.calendarFlow = new $.calendarFlow.Calendar($(this),settings);
        });

        return this;
    };
})(jQuery);
