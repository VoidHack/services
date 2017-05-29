function HistoryObject () {
	this.mhistory = [];
	this.mhistoryIndex = 0;
	this.save = function (s) {
		with (this) {
			if (mhistory[mhistory.length-1] != s && s != "") {
				mhistory[mhistory.length] = s;
			}
			mhistoryIndex = mhistory.length;
		}
	};
	this.previous = function () {
		with (this) {
			if (--mhistoryIndex >= 0) {
				return mhistory[mhistoryIndex];
			}
			++mhistoryIndex;
			return null;
		}
	};
	this.next = function () {
		with (this) {
			if (++mhistoryIndex < mhistory.length) {
				return mhistory[mhistoryIndex];
			}
			mhistoryIndex = mhistory.length;
			return null;
		}
	};
}
