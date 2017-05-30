from django.conf import settings
from django import template
import os


register = template.Library()


@register.filter
def printFileContent(file):
	if not os.path.abspath(file).startswith(os.path.abspath(settings.MEDIA_ROOT)):
		return ""

	try:
		with open(file, "r") as f:
			return f.read()
	except IOError:
		return ""
