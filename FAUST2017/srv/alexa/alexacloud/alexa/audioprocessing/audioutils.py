import os
import speech_recognition as sr


def isRecognizableAudioFile(filename):
	"""
	Speech recognizer can only deal with PCM WAV, AIFF/AIFF-C, or Native FLAC
	:param filename: audio file
	:return: 
	"""
	if not os.path.exists(filename):
		return False

	r = sr.Recognizer()
	try:
		with sr.AudioFile(filename) as f:
			r.record(f)
		return True
	except ValueError:
		return False


