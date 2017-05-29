all:	clean
	gcc -o ArtWeb web.c

clean:
	rm -f ArtWeb

install: all
	useradd -d /home/ArtWeb -m -s /usr/sbin/nologin ArtWeb
	mkdir /var/www/web/
	cp -f index.htm /var/www/web
	cp -f web.c /home/ArtWeb
	cp -f Makefile /home/ArtWeb
	chown -R ArtWeb /var/www/web/
	mv -f ArtWeb /usr/bin/
	cp -f ArtWeb.init /etc/init.d/ArtWeb
	update-rc.d ArtWeb defaults

uninstall:
	userdel ArtWeb
	rm -rf /var/www/web
	rm -f /usr/bin/ArtWeb
	rm -f /var/log/ArtWeb.log
	rm -rf /home/ArtWeb
	rm -f /etc/init.d/ArtWeb
	update-rc.d -f ArtWeb remove
