#!/usr/bin/env python3
# Removes old files in media root in order to keep your storage requirements low

from alexacloud import settings
import datetime
import shutil
import os

media_root = settings.MEDIA_ROOT

# Delete directories that were created more than 30 minutes
now = datetime.datetime.now()
ago = now - datetime.timedelta(minutes=30)

folders = [os.path.join(media_root, f) for f in os.listdir(media_root)]
folders = list(filter(os.path.isdir, folders))
for folder in folders:
	st = os.stat(folder)
	mtime = datetime.datetime.fromtimestamp(st.st_mtime)
	if mtime < ago:
		shutil.rmtree(folder)
