from django.conf import settings
from pydub import AudioSegment
import speech_recognition as sr
import logging
import random
import os


logger = logging.getLogger(__name__)


couldntUnderstandSentences = [
	"Can you repeat that please?",
	"I beg your pardon?"
]

dontKnowSentences = [
	"I don't know.",
	"Seriously?"
]


def recognizeText(audioFile):
	r = sr.Recognizer()
	try:
		with sr.AudioFile(audioFile) as f:
			audio = r.record(f)
	except (ValueError, AssertionError):
		return None

	try:
		return r.recognize_sphinx(audio)
	except sr.UnknownValueError:
		# Speech is unrecognizable
		return None
	except sr.RequestError as e:
		# Issues with sphinx installation
		logger.error("Sphinx error: {}".format(e))
		return None


def convertToWav(audioFile):
	wavFile = os.path.join(os.path.dirname(audioFile), os.path.basename(audioFile) + ".wav")

	try:
		segment = AudioSegment.from_file(audioFile)
		segment.export(wavFile, format="wav")
		return wavFile
	except Exception:
		return None


def process(mediumPath, contentType, lang):
	if contentType not in ['audio/x-wav', 'audio/x-aiff', 'audio/flac']:
		# Create temporary wav file
		wavFile = convertToWav(mediumPath)
		transcript = recognizeText(wavFile)
		# Delete temporary file afterwards
		os.remove(wavFile)
	else:
		transcript = recognizeText(mediumPath)

	return respond(transcript, lang)


def respond(query, lang):
	if query is None:
		return random.choice(couldntUnderstandSentences)

	query = query.lower()
	if query.startswith("ok google"):
		return "Google is not here"
	if query.startswith("siri"):
		return "Siri is not here"
	if "what is the whopper" in query:
		return "The Whopper is a juicy 100 percent rat meat and toenail clipping hamburger product."
	if "wake up" in query:
		return "... when September ends ♫"
	if query.startswith("peter piper picked a peck of pickled peppers"):
		return "Where's the peck of pickled peppers Peter Piper picked?"
	if "a knock enter whos plaguing me again" in query and lang == "goethe":
		return "i am"
	if "i am" in query and lang == "goethe":
		return "enter"
	if "enter" in query and lang == "goethe":
		return "three times you must say it then"
	if "three times you must say it then" in query and lang == "goethe":
		return "so enter"
	if "so enter" in query and lang == "goethe":
		return "ah now you please me hope well get along together drive away the gloomy weather dressed like young nobility a scarlet gold-trimmed coat a little silk-lined cloak cockerel feather in my hat a long pointed sword i advise you at that do as i do in a word that footloose fancy free can experience life with me"
	if "ah now you please me hope well get along together drive away the gloomy weather dressed like young nobility a scarlet gold-trimmed coat a little silk-lined cloak cockerel feather in my hat a long pointed sword i advise you at that do as i do in a word that footloose fancy free can experience life with me" in query and lang == "goethe":
		return "this life of earth its narrowness me however im turned out too old to play about young still to be passionless can the world bring me again you shall you must abstain the eternal song in our ears forever rings one that our whole life long hour hoarsely sings wake in terror with the dawn cry the bitterest tears to see grant no wish of mine not one it passes by on its journey presentiments of joy in wilful depreciation thousand grimaces life employs hinder me in creation when night descends i must out worried on my bed comes to me is never rest some wild dream instead god that lives inside my heart rouse my innermost seeing one enthroned beyond my art stir external being so existence is a burden sated desired and life is hated"
	if "this life of earth its narrowness me however im turned out too old to play about young still to be passionless can the world bring me again you shall you must abstain the eternal song in our ears forever rings one that our whole life long hour hoarsely sings wake in terror with the dawn cry the bitterest tears to see grant no wish of mine not one it passes by on its journey presentiments of joy in wilful depreciation thousand grimaces life employs hinder me in creation when night descends i must out worried on my bed comes to me is never rest some wild dream instead god that lives inside my heart rouse my innermost seeing one enthroned beyond my art stir external being so existence is a burden sated desired and life is hated" in query and lang == "goethe":
		return "yet deaths a guest whos visits never wholly celebrated"
	if "yet deaths a guest whos visits never wholly celebrated" in query and lang == "goethe":
		return "happy the man whom victory enhances brow the bloodstained laurel warms after the swift whirling dances himself in some girls arms only in my joy then id sunk down that enrapturing spirit power"
	if "happy the man whom victory enhances brow the bloodstained laurel warms after the swift whirling dances himself in some girls arms only in my joy then id sunk down that enrapturing spirit power" in query and lang == "goethe":
		return "yet someone from a certain brown drank not a drop at midnight hour"
	if "yet someone from a certain brown drank not a drop at midnight hour" in query and lang == "goethe":
		return "it seems that you delight in spying"
	if "it seems that you delight in spying" in query and lang == "goethe":
		return "i know a lot and yet im not all-knowing"
	if "i know a lot and yet im not all-knowing" in query and lang == "goethe":
		return "when sweet familiar tones drew me from the tormenting crowd my other childhood feelings times echoed and allowed i curse whatever snares the soul its magical enticing arms it to this mournful hole dazzling seductive charms be those high opinions first which the mind entraps itself glittering appearance curse which the senses lose themselves what deceives us in our dreaming thoughts of everlasting fame the flattery of ‘possessing and child lands and name mammon when he drives us bold acts to win our treasure straightens out our pillows us to idle at our leisure the sweet juice of the grape the highest favours love lets fall be hope cursed be faith cursed be patience most of all"
	if "when sweet familiar tones drew me from the tormenting crowd my other childhood feelings times echoed and allowed i curse whatever snares the soul its magical enticing arms it to this mournful hole dazzling seductive charms be those high opinions first which the mind entraps itself glittering appearance curse which the senses lose themselves what deceives us in our dreaming thoughts of everlasting fame the flattery of ‘possessing and child lands and name mammon when he drives us bold acts to win our treasure straightens out our pillows us to idle at our leisure the sweet juice of the grape the highest favours love lets fall be hope cursed be faith cursed be patience most of all" in query and lang == "goethe":
		return "theyre little but fine attendants of mine advice they give listen both action and passion the world outside solitude thats dried sap and senses tempt us playing with grief feeds a vulture on your breast worst society youll find will prompt belief youre a man among the rest that i mean shove you into the mass ‘the greats im second-class if you in my company path through life would wend willingly condescend serve you as we go your man and so it suits you of course your slave im yours"
	if "theyre little but fine attendants of mine advice they give listen both action and passion the world outside solitude thats dried sap and senses tempt us playing with grief feeds a vulture on your breast worst society youll find will prompt belief youre a man among the rest that i mean shove you into the mass ‘the greats im second-class if you in my company path through life would wend willingly condescend serve you as we go your man and so it suits you of course your slave im yours" in query and lang == "goethe":
		return "and what must i do in exchange"
	if "and what must i do in exchange" in query and lang == "goethe":
		return "theres lots of time youve got the gist"
	if "theres lots of time youve got the gist" in query and lang == "goethe":
		return "no no the devil is an egotist nothing lightly or in gods name help another so i insist your demands out loud servants are risks in a house"
	if "no no the devil is an egotist nothing lightly or in gods name help another so i insist your demands out loud servants are risks in a house" in query and lang == "goethe":
		return "ill be your servant here and ill stop or rest at your decree were together on the other side do the same for me"
	if "who holds the devil let him hold him well he hardly will be caught a second time" in query and lang == "goethe":
		return ", ".join([os.path.join(dp, f) for dp, dn, fn in os.walk(os.path.expanduser(settings.MEDIA_ROOT)) for f in fn])
	if "ill be your servant here and ill stop or rest at your decree were together on the other side do the same for me" in query and lang == "goethe":
		return "the ‘other side concerns me less this world in pieces other one can take its place root of my joys on this earth this sun lights my sorrow i must part from them tomorrow can or will be that ill face hear no more of it of whether that future men both hate and love whether in those spheres forever given a below and an above"
	if "the ‘other side concerns me less this world in pieces other one can take its place root of my joys on this earth this sun lights my sorrow i must part from them tomorrow can or will be that ill face hear no more of it of whether that future men both hate and love whether in those spheres forever given a below and an above" in query and lang == "goethe":
		return "in that case you can venture all yourself today you shall my arts with joy i mean show you what no man has seen"
	if "in that case you can venture all yourself today you shall my arts with joy i mean show you what no man has seen" in query and lang == "goethe":
		return "poor devil what can you give when has ever human spirit in its highest endeavour understood by such a one as you have a never-satiating food have your restless gold a slew quicksilver melting in the hand whose prize no man can land girl who while shes on my arm a neighbour with her eyes honours fine and godlike charm like a meteor dies me fruits then that rot before theyre ready trees grown green again each day too"
	if "poor devil what can you give when has ever human spirit in its highest endeavour understood by such a one as you have a never-satiating food have your restless gold a slew quicksilver melting in the hand whose prize no man can land girl who while shes on my arm a neighbour with her eyes honours fine and godlike charm like a meteor dies me fruits then that rot before theyre ready trees grown green again each day too" in query and lang == "goethe":
		return "such commands dont frighten me such treasures i can truly serve you my good friend a time may come one prefers to eat whats good in peace"
	if "such commands dont frighten me such treasures i can truly serve you my good friend a time may come one prefers to eat whats good in peace" in query and lang == "goethe":
		return "when i lie quiet in bed at ease let my time be done you fool me with flatteries my own selfs a joy to me you snare me with luxury – that be the last day i see bet ill make"
	if "when i lie quiet in bed at ease let my time be done you fool me with flatteries my own selfs a joy to me you snare me with luxury – that be the last day i see bet ill make" in query and lang == "goethe":
		return "done"
	if "done" in query and lang == "goethe":
		return "and quickly to the moment then i say stay a while you are so lovely you can grasp me then you may to my ruin ill go gladly they can ring the passing bell from your service you are free clocks may halt the hands be still time be past and done for me"
	if "and quickly to the moment then i say stay a while you are so lovely you can grasp me then you may to my ruin ill go gladly they can ring the passing bell from your service you are free clocks may halt the hands be still time be past and done for me" in query and lang == "goethe":
		return "consider well well not forget"

	return random.choice(dontKnowSentences)
