using Toybox.Application;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as G;
using Toybox.System as Sys;
using Toybox.Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as AM;

class BucheWatchFaceApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }

    function getInitialView() {
        return [ new BucheWatchFaceView() ];
    }
}

class BucheWatchFaceView extends Ui.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();

        // Rosepine Base (rich dark purple background like your Neovim)
        dc.setColor(0x191724, 0x191724);
        dc.clear();

        // Get current time and date
        var clockTime = Sys.getClockTime();
        var now = Time.now();
        var dateInfo = Calendar.info(now, Time.FORMAT_MEDIUM);

        // Get activity data
        var activityInfo = AM.getInfo();
        var stats = Sys.getSystemStats();

        // JSON-style layout with line numbers like Neovim
        var startY = height * 0.26;
        var lineHeight = height * 0.098;
        var y = startY;
        var lineNum = 1;

        // Line 1: "time": "14:25",
        var hour = clockTime.hour;
        var min = clockTime.min < 10 ? "0" + clockTime.min : clockTime.min.toString();

        dc.setColor(0x6e6a86, G.COLOR_TRANSPARENT); // Line number (muted)
        dc.drawText(width * 0.06, y, G.FONT_SMALL, lineNum.toString(), G.TEXT_JUSTIFY_LEFT);
        dc.setColor(0xf6c177, G.COLOR_TRANSPARENT); // JSON key (gold)
        dc.drawText(width * 0.14, y, G.FONT_SMALL, "\"time\":", G.TEXT_JUSTIFY_LEFT);
        dc.setColor(0xf6c177, G.COLOR_TRANSPARENT); // String value
        dc.drawText(width * 0.42, y, G.FONT_SMALL, "\"" + hour + ":" + min + "\",", G.TEXT_JUSTIFY_LEFT);

        y += lineHeight;
        lineNum++;

        // Line 2: "date": "sep 25",
        var monthStr = "sep";
        var dayStr = dateInfo.day.toString();

        dc.setColor(0x6e6a86, G.COLOR_TRANSPARENT); // Line number
        dc.drawText(width * 0.06, y, G.FONT_SMALL, lineNum.toString(), G.TEXT_JUSTIFY_LEFT);
        dc.setColor(0xf6c177, G.COLOR_TRANSPARENT); // JSON key
        dc.drawText(width * 0.14, y, G.FONT_SMALL, "\"date\":", G.TEXT_JUSTIFY_LEFT);
        dc.setColor(0xf6c177, G.COLOR_TRANSPARENT); // String value
        dc.drawText(width * 0.42, y, G.FONT_SMALL, "\"" + monthStr + " " + dayStr + "\",", G.TEXT_JUSTIFY_LEFT);

        y += lineHeight;
        lineNum++;

        // Line 3: "hr": 72,
        var hrText = "0";
        if (activityInfo has :currentHeartRate && activityInfo.currentHeartRate != null) {
            hrText = activityInfo.currentHeartRate.toString();
        }

        dc.setColor(0x6e6a86, G.COLOR_TRANSPARENT); // Line number
        dc.drawText(width * 0.06, y, G.FONT_SMALL, lineNum.toString(), G.TEXT_JUSTIFY_LEFT);
        dc.setColor(0xf6c177, G.COLOR_TRANSPARENT); // JSON key
        dc.drawText(width * 0.14, y, G.FONT_SMALL, "\"hr\":", G.TEXT_JUSTIFY_LEFT);
        dc.setColor(0xeb6f92, G.COLOR_TRANSPARENT); // Number (pink)
        dc.drawText(width * 0.32, y, G.FONT_SMALL, hrText + ",", G.TEXT_JUSTIFY_LEFT);

        y += lineHeight;
        lineNum++;

        // Line 4: "steps": 8234,
        var stepsText = "0";
        if (activityInfo has :steps && activityInfo.steps != null) {
            stepsText = activityInfo.steps.toString();
        }

        dc.setColor(0x6e6a86, G.COLOR_TRANSPARENT); // Line number
        dc.drawText(width * 0.06, y, G.FONT_SMALL, lineNum.toString(), G.TEXT_JUSTIFY_LEFT);
        dc.setColor(0xf6c177, G.COLOR_TRANSPARENT); // JSON key
        dc.drawText(width * 0.14, y, G.FONT_SMALL, "\"steps\":", G.TEXT_JUSTIFY_LEFT);
        dc.setColor(0xeb6f92, G.COLOR_TRANSPARENT); // Number
        dc.drawText(width * 0.48, y, G.FONT_SMALL, stepsText + ",", G.TEXT_JUSTIFY_LEFT);

        y += lineHeight;
        lineNum++;

        // Line 5: "bat": 85
        var batteryText = Math.round(stats.battery).toNumber().toString();

        dc.setColor(0x6e6a86, G.COLOR_TRANSPARENT); // Line number
        dc.drawText(width * 0.06, y, G.FONT_SMALL, lineNum.toString(), G.TEXT_JUSTIFY_LEFT);
        dc.setColor(0xf6c177, G.COLOR_TRANSPARENT); // JSON key
        dc.drawText(width * 0.14, y, G.FONT_SMALL, "\"bat\":", G.TEXT_JUSTIFY_LEFT);
        dc.setColor(0xeb6f92, G.COLOR_TRANSPARENT); // Number
        dc.drawText(width * 0.38, y, G.FONT_SMALL, batteryText, G.TEXT_JUSTIFY_LEFT);
    }
}

function getApp() {
    return Application.getApp();
}
