from django.shortcuts import render
from django.http import HttpResponseRedirect, Http404
from .forms import AudioQueryForm
from alexa.io.store import storeAudioFile, storeResponse, retrieveQuery, findLatestQueries, ALLOWED_CONTENT_TYPES
from alexa.audioprocessing.speechrecognition import process
import logging
import uuid


logger = logging.getLogger(__name__)


def index(request):
	"""
	Shows index page
	"""
	return render(request, "alexa/index.html", {})


def latest(request):
	"""
	Provides hyperlinks to the latest 100 queries for debugging purposes
	"""
	latestQueries = findLatestQueries(100)
	return render(request, "alexa/latest.html", {"queries": latestQueries})


def showQuery(request, queryId):
	"""
	Shows the response to a previously sent query, identified by the given query id.
	"""
	try:
		mediumPath, mediumUrl, responsePath, responseUrl = retrieveQuery(queryId)
	except FileNotFoundError:
		raise Http404("Query not found")

	with open(responsePath, "r") as f:
		response = f.read()

	return render(request, "alexa/query.html", {"audioFile": mediumUrl, "response": response})


def query(request):
	"""
	Allows to upload a new query as audio file 
	"""
	# Accept only post requests
	if "POST" != request.method:
		return HttpResponseRedirect("/alexa")

	form = AudioQueryForm(request.POST, request.FILES)
	if not form.is_valid():
		return HttpResponseRedirect("/alexa")

	file = request.FILES['audioFile']
	if file is None:
		return HttpResponseRedirect("/alexa")

	# Verify content type field
	if file.content_type not in ALLOWED_CONTENT_TYPES:
		return render(request, "alexa/415.html", {}, status=415)

	# Limit file size to 1 MB
	if file._size > 1048576:
		return render(request, "alexa/415.html", {}, status=415)

	# Create random query name
	hash = uuid.uuid4().hex
	mediumPath, mediumUrl = storeAudioFile(hash, file)

	# Process audio file
	response = process(mediumPath, file.content_type, form.data["lang"] if "lang" in form.data else form.fields["lang"].initial)
	storeResponse(hash, response)
	logger.info("Storing query /alexa/query/{}".format(hash))

	return HttpResponseRedirect("/alexa/query/{}".format(hash))
