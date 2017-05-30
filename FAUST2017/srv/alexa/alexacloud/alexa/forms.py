from django import forms


class AudioQueryForm(forms.Form):
	audioFile = forms.FileField()
	lang = forms.CharField(required=False, initial="en-us")


