function KeyboadObject() {
	// this.processKey = defaultProcessKey;
	//
	// readState:
	// 0 - not reading
	// 1 - reading line
	// 2 - reading line done
	// 3 - reading stream
	// 4 - reading stream done
	this.readState = 0;
	this.processKey = defaultProcessKey;
	this.processSpecialKeys = defaultProcessSpecialKeys;
	this.processKeyDown = defaultProcessKeyDown;
	this.grabLine = function() {};
	this.grabStream = function() {};

	this.toggleInput = function (n) {
		switch (n) {	
			case 0:
				this.processKey = emptyStub;
				this.processSpecialKeys = emptyStub;
				break;
			case 1:
				this.processKey = defaultProcessKey;
				this.processSpecialKeys = defaultProcessSpecialKeys;
		}
	}
				
	
	this.readLine = function (func) {
		this.processKey = readLineProcessKey;
		this.processSpecialKeys = readProcessSpecialKeys;
		this.grabLine = func;
	};

	this.readLineCleanUp = function () {
		this.processKey = emptyStub;
		this.processSpecialKeys = emptyStub;
		consoleObject.cloneStdinStdout();
	};
	
	this.readStream = function (func) {
		this.crFlag = 0;
		this.processKey = readStreamProcessKey;
		this.processSpecialKeys = readProcessSpecialKeys;
		this.grabStream = func;
	};

	this.readStreamCleanUp = function () {
		this.crFlag = 0;
		this.processKey = emptyStub;
		this.processSpecialKeys = emptyStub;
		consoleObject.cloneStdinStdout();
	};

}
	
function emptyStub() {
}

function readLineProcessKey(e) {
	var a = document.getElementsByName("stdin");
	var stdin = a[a.length-1];
	var k = window.event?e.keyCode:e.which;
	var c = '';
	switch (k) {
		case 0:
			break;
		case 13:
			this.readLineCleanUp();	
			this.grabLine(stdin.innerHTML);
			break;
		case 8: 
			if (!window.event) {
				consoleObject.eraseFromStdin();
			}
			break;
		default:
			consoleObject.printToStdin(String.fromCharCode(k));
	}
	lastelement.scrollIntoView(false);
	return false;
}

function readStreamProcessKey(e) {
	var a = document.getElementsByName("stdin");
	var stdin = a[a.length-1];
	var k = window.event?e.keyCode:e.which;
	var c = '';
	switch (k) {
		case 0:
			break;
		case 13:
			if (this.crFlag == 1) {	
				this.readStreamCleanUp();	
				this.grabStream(stdin.innerHTML);
			} else {
				consoleObject.printToStdin("\n");
				this.crFlag = 1;
			}
			break;
		case 8: 
			if (!window.event) {
				consoleObject.eraseFromStdin();
			}
			this.crFlag = 0;
			break;
		default:
			if(this.crFlag == 1 && window.event) {
				consoleObject.printToStdin("\n" + String.fromCharCode(k));
			} else {
				consoleObject.printToStdin(String.fromCharCode(k));
			}
			this.crFlag = 0;
	}
	lastelement.scrollIntoView(false);
	return false;
}

function readProcessSpecialKeys(e) {
	var a = document.getElementsByName("stdin");
	var stdin = a[a.length-1];
	var k = window.event?e.keyCode:e.which;
	var s = '';
	switch (k) {
		case 8: 
			if (window.event) {
				consoleObject.eraseFromStdin();
			}
			break;
	}
	lastelement.scrollIntoView(false);
}

function defaultProcessKey(e) {
	var a = document.getElementsByName("cmdline");
	var cmdline = a[a.length-1];
	var k = window.event?e.keyCode:e.which;
	var c = '';
	switch (k) {
		case 0:
			break;
		case 13:
			processCommand(cmdline.innerHTML);
			break;
		case 8: 
			if (!window.event) {
				var s = cmdline.innerHTML;
				consoleObject.substituteCmdline(s.substr(0, s.length-1));
			}
			break;
		default:
			consoleObject.printToCmdline(String.fromCharCode(k));
	}
	return false;
}

function defaultProcessSpecialKeys(e) {
	var a = document.getElementsByName("cmdline");
	var cmdline = a[a.length-1];
	var k = window.event?e.keyCode:e.which;
	var s = '';
	switch (k) {
		case 8: 
			if (window.event) {
				var s = cmdline.innerHTML;
				consoleObject.substituteCmdline(s.substr(0, s.length-1));
			}
			lastelement.scrollIntoView(false);
			break;
		case 33:	// page up
			if (e.shiftKey) {
				document.body.scrollTop -= 300;
				return;
			}
			break;
		case 34:	// page down
			if (e.shiftKey) {
				document.body.scrollTop += 300;
				return;
			}
			break;
		case 39:
			var s = cmdline.innerHTML.split(" ")[0];
			commandsObject.process(s);
			lastelement.scrollIntoView(false);
			break; 
		case 38:
			if (s = commandHistory.previous()) {
				consoleObject.substituteCmdline(s);
			}
			lastelement.scrollIntoView(false);
			break;
		case 40:
			if (s = commandHistory.next()) {
				consoleObject.substituteCmdline(s);
			} else {
				consoleObject.substituteCmdline('');
			}
			lastelement.scrollIntoView(false);
			break;
	}
}

function defaultProcessKeyDown() {
	if (navigator.appName == 'Microsoft Internet Explorer') {
		if (event.keyCode == 8) { return false; }
		return;
	}
	return false;
}

