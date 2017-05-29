function ConsoleObject() {

	this.serverScript = "../cgi/1.pl";
	this.changeGreetingDir = function (dir) {
		var a = document.getElementsByName("directory");
		var directory = a[a.length-1];
		directory.innerHTML = dir;
	};

	this.changeGreetingLogin = function (login) {
		var a = document.getElementsByName("username");
		var username = a[a.length-1];
		username.innerHTML = login;
	};

	this.changeGreetingType = function (n) {
		var a = document.getElementsByName("usertype");
		var usertype = a[a.length-1];
		usertype.innerHTML = n?'#':'$';
	};

	this.createNewScreen = function () {
		var a = document.getElementsByName("block");
		var block = a[a.length-1];
		commandHistory.save(block.childNodes[1].innerHTML);
		var o = block.cloneNode(true);
		o.childNodes[1].innerHTML = '';
		o.childNodes[2].childNodes[0].innerHTML = '';
		o.childNodes[2].childNodes[1].innerHTML = '';
		for (var i = 2; i < o.childNodes[2].childNodes.length; i++) {
			o.childNodes[2].childNodes[i].innerHTML = '';
		}
		bigSam.appendChild(o);
		cursorObject.shutdownAllCursors();
		keyboardObject.toggleInput(1);
		lastelement.scrollIntoView(false);
	};

	this.cloneScreen = function () {
		var a = document.getElementsByName("block");
		var block = a[a.length-1];
		var o = block.cloneNode(true);
		o.childNodes[2].childNodes[0].innerHTML = '';
		o.childNodes[2].childNodes[1].innerHTML = '';
		for (var i = 2; i < o.childNodes[2].childNodes.length; i++) {
			o.childNodes[2].childNodes[i].innerHTML = '';
		}
		bigSam.appendChild(o);
		cursorObject.shutdownAllCursors();
		lastelement.scrollIntoView(false);
	};	
	
	this.cloneStdinStdout = function () {
		var a = document.getElementsByName("std");
		var std = a[a.length-1];
		var a = document.getElementsByName("stdout");
		var stdout = a[a.length-1];
		var a = document.getElementsByName("stdin");
		var stdin = a[a.length-1];
		var o1 = stdout.cloneNode(true);
		var o2 = stdin.cloneNode(true);
		o1.innerHTML = '';
		o2.innerHTML = '';
		std.appendChild(o1);
		std.appendChild(o2);
		lastelement.scrollIntoView(false);
	};


	this.printToCmdline = function (s) {
		var a = document.getElementsByName("cmdline");
		var cmdline = a[a.length-1];
		cmdline.innerHTML += s;
	};

	this.substituteCmdline = function (s) {
		var a = document.getElementsByName("cmdline");
		var cmdline = a[a.length-1];
		cmdline.innerHTML = s;
	};

	this.printToStdout = function (s) {
		var a = document.getElementsByName("stdout");
		var stdout = a[a.length-1];
		if (stdout.innerText != null) {
			stdout.innerText += s;
		} else {
			stdout.innerHTML += s;
		}
	};
	
	this.printToStdoutInHTML = function (s) {
		var a = document.getElementsByName("stdout");
		var stdout = a[a.length-1];
		stdout.innerHTML += s;
	};
	
	this.printToStdin = function (s) {
		var a = document.getElementsByName("stdin");
		var stdin = a[a.length-1];
		if (stdin.innerText != null) {
			stdin.innerText += s;
		} else {
			stdin.innerHTML += s;
		}
	};

	this.eraseFromStdin = function () {
		var a = document.getElementsByName("stdin");
		var stdin = a[a.length-1];
		if (stdin.innerText != null) {
			stdin.innerText = stdin.innerText.substr(0, stdin.innerText.length - 1);
		} else {
			stdin.innerHTML = stdin.innerHTML.substr(0, stdin.innerHTML.length - 1);
		}
	};

	this.sendServer = function (cmd, func) {
		var http = null;
		if(navigator.appName == "Microsoft Internet Explorer") {
			http = new ActiveXObject("Microsoft.XMLHTTP");
		} else {
        		http = new XMLHttpRequest();
		}
		http.open("POST", this.serverScript);
		http.onreadystatechange = function () {
                	if(http.readyState == 4) {
				if (http.status == 200) func(http);
				else {
					consoleObject.printToStdout("\no_O Server down =( ");
					cursorObject.toggleCursor();
					consoleObject.createNewScreen();
				}
                        }
                };
                http.send(cmd);
	};
}
