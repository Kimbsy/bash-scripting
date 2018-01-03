var system = require('system');
var page = require('webpage').create();

// System.args[0] is the filename, so system.args[1] is the first real argument.
var url = system.args[1];

// Allow the page to open and load js.
page.open(url, function () {
    // Output the HTML content which now includes loaded decklists.
    console.log(page.content);
    phantom.exit();
});
