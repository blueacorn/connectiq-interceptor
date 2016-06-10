using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class BomberApp extends App.AppBase {

	var view = null;

    function initialize() {
        AppBase.initialize();
    }

    //! onStart() is called on application start up
    function onStart() {
    }

    //! onStop() is called when your application is exiting
    function onStop() {
    }

    //! Return the initial view of your application here
    function getInitialView() {
    	view = new BomberView();
        return [ view ];
    }

    //! New app settings have been received so trigger a UI update
    function onSettingsChanged()
    {
        if (view != null) {
        	view.onSettingsChanged();
        }
    }

}