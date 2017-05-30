from django.conf import settings
import time
import os

ALLOWED_CONTENT_TYPES = ['audio/x-wav', 'audio/x-aiff', 'audio/flac', 'video/ogg']

NAMES = [
	"Christena Confer",
	"Feary Frederic",
	"Greedy Gregoric",
	"Heroic Hans",
	"Inglorious Isabella",
	"Jealous Judy",
	"Killer Karl",
	"Ludicrous Leonhard",
	"Monstrous Michel",
	"Nasty Norbert",
	"Oblivious Oliver",
	"Plaintive Peter",
	"Quarrelsome Quinn",
	"Chester Culwell",
	"Cythia Coombes",
	"Chasity Chagoya",
	"Lavera Lueders",
	"Sueann Suen",
	"Laila Leggett",
	"Rick Reale",
	"Ulysses Uriarte",
	"Forrest Funston",
	"Nancey Nicolson",
	"Thi Toenjes",
	"Beverley Brisker",
	"Su Sennett",
	"Dulcie Digangi",
	"Latoya Lippman",
	"Jacquelyne Jamieson",
	"Shantay Saffell",
	"Sharilyn Santi",
	"Apolonia Augustine",
	"Londa Leduc",
	"Sumiko Sutphin",
	"Seema Spradlin",
	"Madelaine Mund",
	"Elsa Ellingsworth",
	"Chanell Crosson",
	"Bret Bachmann",
	"Cathie Crown",
	"Timmy Telford",
	"Jacinta Juarez",
	"Dortha Devore",
	"Micaela Milera",
	"Cristobal Coover",
	"Jerome Jiggetts",
	"Lavonda Landon",
	"Nelle Nordin",
	"Luciana Lepley",
	"Frederick Fishburn",
	"Kelsi Keef",
	"Tiny Tester",
	"Rhett Recore",
	"Hulda Haws",
	"Katlyn Kottke",
	"Vonnie Vidrine",
	"Olimpia Otto",
	"Edie Eklund",
	"Julio Juergens",
	"Ellamae Ensley",
	"Rodolfo Redus",
	"Kary Korb",
]

RESPONSE_FILENAME = ".response.txt"


def storeAudioFile(folder, f):
	path = os.path.join(settings.MEDIA_ROOT, folder)
	os.mkdir(path)

	mediumPath = os.path.join(path, f.name)
	with open(mediumPath, 'wb+') as destination:
		for chunk in f.chunks():
			destination.write(chunk)

	mediumUrl = os.path.join(settings.MEDIA_URL, folder, f.name)
	return mediumPath, mediumUrl


def storeResponse(folder, response):
	path = os.path.join(settings.MEDIA_ROOT, folder, RESPONSE_FILENAME)
	with open(path, 'w') as destination:
		destination.write(response)
	return path


def retrieveQuery(folder):
	path = os.path.join(settings.MEDIA_ROOT, folder)
	if not os.path.exists(path):
		raise FileNotFoundError

	contents = sorted(os.listdir(path))
	if len(contents) != 2:
		raise FileNotFoundError

	# Join url and path
	mediumPath = os.path.join(path, contents[1])
	mediumUrl = os.path.join(settings.MEDIA_URL, folder, contents[1])
	responsePath = os.path.join(path, contents[0])
	responseUrl = os.path.join(settings.MEDIA_URL, folder, contents[0])

	return mediumPath, mediumUrl, responsePath, responseUrl


def deleteQuery(filename):
	try:
		# Remove audio file
		os.remove(filename)
		# Remove response if it has already existed
		folder = os.path.dirname(filename)
		os.remove(os.path.join(folder, RESPONSE_FILENAME))
		# Remove directory if it is empty
		os.rmdir(folder)
	except OSError:
		pass


def findLatestQueries(numItems):
	folders = [os.path.join(settings.MEDIA_ROOT, f) for f in os.listdir(settings.MEDIA_ROOT)]
	folders = list(filter(os.path.isdir, folders))
	folders = list(map(lambda folder: {"name": NAMES[int(os.path.basename(os.path.normcase(folder)), 16) % len(NAMES)], "hash": os.path.basename(os.path.normcase(folder)), "time": time.strftime('%d.%m.%Y %H:%M:%S', time.localtime(os.path.getmtime(folder)))}, folders))
	folders.sort(key=lambda folderDescriptor: folderDescriptor["time"], reverse=True)
	return folders[:min(len(folders), numItems)]
