function CursorObject () {
	this.cursorS = -1;
	this.shutdownAllCursors = function () {
		var a = document.getElementsByName("cursor");
		for (i = 0; i < a.length; i++) {
			a[i].style.display = "none";
		}
	};

	this.toggleCursor = function () {
		var a = document.getElementsByName("cursor");
		var cursor = a[a.length-1];
		if (this.cursorS == -1) {
			this.cursorS = 0;
			cursor.style.display = "";
		} else {
			this.cursorS = -1;
			cursor.innerHTML = "_";
		}
	};

	this.changeCursorState = function () {
		var str = '|/-\\';
		var a = document.getElementsByName("cursor");
		var cursor = a[a.length-1];
		if (this.cursorS == -1) {
			var o = cursor.style.display;
			cursor.style.display = o?"":"none";
		} else {
			cursor.innerHTML = str.charAt(this.cursorS);
			this.cursorS = (this.cursorS + 1) % str.length;
		}
	};
}
