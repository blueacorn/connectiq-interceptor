using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as AMon;
using Toybox.Activity as Act;

class BomberView extends Ui.WatchFace {

	var FG = Gfx.COLOR_DK_RED;
	var BG = Gfx.COLOR_WHITE;
	var PROP_THEME = 0;
	var PROP_DATAFIELD1 = 0;
	var PROP_DATAFIELD2 = 1;
	var PROP_DATE_FORMAT = null;
	var DATE_FORMAT = "$2$/$1$";
	var df1 = null;
	var df2 = null;
	var D_TIME_Y = 15;
	var D_DF1_Y = 164;
	var D_DF2_Y = 184;
	var bgBitmap = null;
	var timeFont = null;
	var halfHeight = null;
	var halfWidth = null;
	var batteryFont = null;

    function initialize() {
        WatchFace.initialize();
    }


    function onLayout(dc) {
    	halfWidth = dc.getWidth()/2;
    	halfHeight = dc.getHeight()/2;
    	timeFont = Ui.loadResource(Rez.Fonts.timeFont);
    	batteryFont = Ui.loadResource(Rez.Fonts.batteryFont);
    	D_TIME_Y = Ui.loadResource(Rez.Strings.D_TIME_Y).toNumber();
		D_DF1_Y = Ui.loadResource(Rez.Strings.D_DF1_Y).toNumber();
		D_DF2_Y = Ui.loadResource(Rez.Strings.D_DF2_Y).toNumber();
        loadProperties();
    }


	function loadProperties() {
		PROP_THEME = App.getApp().getProperty("PROP_THEME");
		if (PROP_THEME == null || PROP_THEME.equals("")) {
			PROP_THEME = 0;
		}
		PROP_THEME = PROP_THEME.toNumber();
		if (PROP_THEME == 0) {
			FG = Gfx.COLOR_WHITE;
			BG = Gfx.COLOR_BLACK;
			bgBitmap = new Rez.Drawables.bgDark();
		}
		if (PROP_THEME == 1) {
			FG = Gfx.COLOR_BLACK;
			BG = Gfx.COLOR_WHITE;
			bgBitmap = new Rez.Drawables.bgLight();
		}
		PROP_DATAFIELD1 = App.getApp().getProperty("PROP_CUSTOM_FIELD1");
		if (PROP_DATAFIELD1 == null || PROP_DATAFIELD1.equals("")) {
			PROP_DATAFIELD1 = 0;
		}
		PROP_DATAFIELD1 = PROP_DATAFIELD1.toNumber();
		
		PROP_DATAFIELD2 = App.getApp().getProperty("PROP_CUSTOM_FIELD2");
		if (PROP_DATAFIELD2 == null || PROP_DATAFIELD2.equals("")) {
			PROP_DATAFIELD2 = 1;
		}
		PROP_DATAFIELD2 = PROP_DATAFIELD2.toNumber();
		
		PROP_DATE_FORMAT = App.getApp().getProperty("PROP_DATE_FORMAT");
		if (PROP_DATE_FORMAT == null || PROP_DATE_FORMAT.equals("")) {
			PROP_DATE_FORMAT = 0;
		}
		PROP_DATE_FORMAT = PROP_DATE_FORMAT.toNumber();
		if (PROP_DATE_FORMAT == 0) {
			DATE_FORMAT = "$2$/$1$";
		}
		if (PROP_DATE_FORMAT == 1) {
			DATE_FORMAT = "$1$/$2$";
		}
		if (PROP_DATE_FORMAT == 2) {
			DATE_FORMAT = "$1$. $2$.";
		}
		
		df1 = getDataField(PROP_DATAFIELD1, D_DF1_Y);
		df2 = getDataField(PROP_DATAFIELD2, D_DF2_Y);
	}    
	
	function getDataField(type, y) {
		if (type == 0) {
			return null;
		}
    	if (type == 1) {
	    	return new Battery({
	    				:locX => 0,
	    				:locY => y
	    		 	}, FG, BG, batteryFont);
	   	}
	   	if (type == 2) {
	    	return new DateField({
		    			:locX => 0,
		    			:locY => y
		    		 }, FG, batteryFont, DATE_FORMAT);
	   	}
	   	if (type == 3) {
	    	return new StepsField({
		    			:locX => 0,
		    			:locY => y
		    		 }, FG, batteryFont);
	   	}
	   	if (type == 4) {
	    	return new DistanceField({
		    			:locX => 0,
		    			:locY => y
		    		 }, FG, batteryFont);
	   	}
	   	if (type == 5) {
	    	return new CaloriesField({
		    			:locX => 0,
		    			:locY => y
		    		 }, FG, batteryFont);
	   	}
	   	if (type == 6) {
	    	return new GoalPercentageField({
		    			:locX => 0,
		    			:locY => y
		    		 }, FG, batteryFont);
	   	}
	   	if (type == 7) {
	    	return new HeartRateField({
		    			:locX => 0,
		    			:locY => y
		    		 }, FG, batteryFont);
	   	}
   		if (type == 8) {
    		return new AltitudeField({
		    			:locX => 0,
		    			:locY => y
		    		 }, FG, batteryFont);
	   	}
	   return null;
    }

    function onShow() {
    }

    function onUpdate(dc) {
    	dc.setColor(FG, BG);
    	dc.clear();
        var timeFormat = "$1$:$2$";
        var clockTime = Sys.getClockTime();
        var hour = clockTime.hour;
    	if (!Sys.getDeviceSettings().is24Hour) {
    		hour = hour % 12;
    		if (hour == 0) {
    			hour = 12;
    		}
    	}
        var timeString = Lang.format(timeFormat, [hour, clockTime.min.format("%02d")]);
        dc.setColor(FG, Gfx.COLOR_TRANSPARENT);
		bgBitmap.draw(dc);
		dc.setColor(FG, Gfx.COLOR_TRANSPARENT);
		dc.drawText(halfWidth, D_TIME_Y, timeFont, timeString, Gfx.TEXT_JUSTIFY_CENTER);
		if (df1 != null) {
			df1.draw(dc);
		}
		if (df2 != null) {
			df2.draw(dc);
		}
    }
    
    function onSettingsChanged() {
		loadProperties();
		Ui.requestUpdate();
	}


    function onHide() {
    }
    function onExitSleep() {
    }
    function onEnterSleep() {
    }

}

class Battery extends Ui.Drawable {

	var fg = null;
	var bg = null;
	var font = null;
	
	function initialize(params, fgColor, bgColor, fnt) {
		Ui.Drawable.initialize(params);
		fg = fgColor;
		bg = bgColor;
		font = fnt;
	}
	
	function draw(dc) {
		var state = Sys.getSystemStats().battery;
		var y = locY;
    	if (state - state.toNumber() >= 0.5) {
    		state++;
    	}
		var remainingBattery = state / 100;
		state = state.toNumber().toString() + "%";
    	var textWidth = dc.getTextWidthInPixels(state.toString(), font);
    	var totalWidth = textWidth + 25;
    	var startX = (dc.getWidth() - totalWidth) / 2;
    	var x = startX + textWidth + 3;
    	var points = new [8];
    	dc.setColor(fg, bg);
    	var statusWidth = 18.toFloat()*remainingBattery;
    	var statusWidthInt = statusWidth.toNumber();
    	if (statusWidth - statusWidthInt >= 0.5) {
    		statusWidthInt++;
    	}
    	points[0]=[x,y];
    	points[1]=[x+20,y];
    	points[2]=[x+20,y+3];
    	points[3]=[x+22,y+3];
    	points[4]=[x+22,y+7];
    	points[5]=[x+20,y+7];
    	points[6]=[x+20,y+10];
    	points[7]=[x,y+10];
    	dc.fillPolygon(points);
    	dc.setColor(bg, bg); 
    	dc.fillRectangle(x+1, y+1, 18, 8); 	
    	dc.setColor(fg, bg); 
    	if (remainingBattery > 0.05) {
	    	dc.fillRectangle(x+1, y+1, statusWidthInt, 8);
    	}
    	dc.drawText(startX, y-2, font, state, Gfx.TEXT_JUSTIFY_LEFT);
	}
	
}

class DateField extends Ui.Drawable {

	var fg = null;
	var font = null;
	var format = null;
	
	function initialize(params, fgColor, fnt, fmt) {
		Ui.Drawable.initialize(params);
		fg = fgColor;
		font = fnt;
		format = fmt;
	}
	
	function draw(dc) {
		var date = Calendar.info(Time.now(), Time.FORMAT_SHORT);
		var currentDateStamp = Lang.format(format, [date.day, date.month]);
		dc.setColor(fg, Gfx.COLOR_TRANSPARENT);
		dc.drawText(dc.getWidth()/2, locY, font, currentDateStamp, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
}

class StepsField extends Ui.Drawable {

	var fg = null;
	var font = null;
	
	function initialize(params, fgColor, fnt) {
		Ui.Drawable.initialize(params);
		fg = fgColor;
		font = fnt;
	}
	
	function draw(dc) {
		var steps = AMon.getInfo().steps;
		dc.setColor(fg, Gfx.COLOR_TRANSPARENT);
		dc.drawText(dc.getWidth()/2, locY, font, steps.toString(), Gfx.TEXT_JUSTIFY_CENTER);
	}
	
}

class CaloriesField extends Ui.Drawable {

	var fg = null;
	var font = null;
	
	function initialize(params, fgColor, fnt) {
		Ui.Drawable.initialize(params);
		fg = fgColor;
		font = fnt;
	}
	
	function draw(dc) {
		var cals = AMon.getInfo().calories;
		dc.setColor(fg, Gfx.COLOR_TRANSPARENT);
		dc.drawText(dc.getWidth()/2, locY, font, cals + " kCal", Gfx.TEXT_JUSTIFY_CENTER);
	}
	
}

class HeartRateField extends Ui.Drawable {

	var fg = null;
	var font = null;
	
	function initialize(params, fgColor, fnt) {
		Ui.Drawable.initialize(params);
		fg = fgColor;
		font = fnt;
	}
	
	function draw(dc) {
		var hr = "--";
		if (AMon has :getHeartRateHistory) {
			var hrHist = AMon.getHeartRateHistory(1, true);
			if (hrHist != null && hrHist.getMax() != null && hrHist.getMax() > 0 && hrHist.getMax() < 255) {
				hr = hrHist.getMax();
			}
		}
		dc.setColor(fg, Gfx.COLOR_TRANSPARENT);
		dc.drawText(dc.getWidth()/2, locY, font, hr + " BPM", Gfx.TEXT_JUSTIFY_CENTER);
	}
	
}

class DistanceField extends Ui.Drawable {

	var fg = null;
	var font = null;
	
	function initialize(params, fgColor, fnt) {
		Ui.Drawable.initialize(params);
		fg = fgColor;
		font = fnt;
	}
	
	function draw(dc) {
		var units = Sys.getDeviceSettings().distanceUnits == Sys.UNIT_METRIC ? " km" : " mi"; 
		var dst = AMon.getInfo().distance;
    	if (Sys.getDeviceSettings().distanceUnits == Sys.UNIT_METRIC) {
    		dst = dst.toFloat() / 100000;
    	}
    	else {
    		dst = dst.toFloat() / 160934.4;
    	}
		dc.setColor(fg, Gfx.COLOR_TRANSPARENT);
		dc.drawText(dc.getWidth()/2, locY, font, dst.format("%3.2f") + units, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
}

class GoalPercentageField extends Ui.Drawable {

	var fg = null;
	var font = null;
	
	function initialize(params, fgColor, fnt) {
		Ui.Drawable.initialize(params);
		fg = fgColor;
		font = fnt;
	}
	
	function draw(dc) {
		var info = AMon.getInfo();
    	var goal = info.stepGoal;
    	var steps = info.steps;
    	var percent = 0;
    	if (goal > 0) {
    		percent = (steps.toFloat() / goal) * 100;
    	}
		dc.setColor(fg, Gfx.COLOR_TRANSPARENT);
		dc.drawText(dc.getWidth()/2, locY, font, percent.toNumber() + "%", Gfx.TEXT_JUSTIFY_CENTER);
	}
	
}

class AltitudeField extends Ui.Drawable {

	var fg = null;
	var font = null;
	
	function initialize(params, fgColor, fnt) {
		Ui.Drawable.initialize(params);
		fg = fgColor;
		font = fnt;
	}
	
	function draw(dc) {
		var alt = Act.getActivityInfo().altitude;
        if (alt != null) {
        	if (Sys.getDeviceSettings().elevationUnits == Sys.UNIT_STATUTE) {
        		alt = alt * 3.2808399;
        	}
        	if (alt - alt.toNumber() > 0.5) {
        		alt += 1;
        	}
        	alt = alt.toNumber();
        }
        else {
        	alt = "--";
        }
		var units = Sys.getDeviceSettings().elevationUnits == Sys.UNIT_METRIC ? " m" : " ft"; 
		dc.setColor(fg, Gfx.COLOR_TRANSPARENT);
		dc.drawText(dc.getWidth()/2, locY, font, alt + units, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
}
