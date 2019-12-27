var Action = function() {};

Action.prototype = {
//send two pieces of data to our extension: the URL the user was visiting, and the title of the page.
run: function(parameters) {
    parameters.completionFunction({"URL": document.URL, "title": document.title });
},

//"tell iOS the JavaScript has finished preprocessing, and give this data dictionary to the extension."
finalize: function(parameters) {
    var customJavaScript = parameters["customJavaScript"];
    eval(customJavaScript);
}

};

var ExtensionPreprocessingJS = new Action


/*
 There are two functions: run() and finalize(). The first is called before your extension is run, and the other is called after.
 Apple expects the code to be exactly like this, so you shouldn't change it other than to fill in the run() and finalize() functions.
 */
