from django.conf.urls import url

from . import views

urlpatterns = [
	url(r'^$', views.index, name='index'),
	url(r'^debug/latest$', views.latest, name='latest'),
	url(r'^query$', views.query, name='upload'),
	url(r'^query/(?P<queryId>[a-z0-9]+)$', views.showQuery, name='show')
]
