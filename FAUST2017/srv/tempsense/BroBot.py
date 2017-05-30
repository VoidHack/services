#################################################################################################
# thanks to https://github.com/lizadaly/brobot for providing a template skeleton for this class #
#################################################################################################

import random
import os
os.environ['NLTK_DATA'] = os.getcwd() + '/nltk_data'

from textblob import TextBlob
from tech_support import BadWordException, logger, read, DATA_DIR


class CTFBotBro(object):
    def __init__(self):
        self.help_responses = ['help', 'assist', 'assistance', 'need',]
        self.blacklist = read(DATA_DIR + '1')
        self.key_greeting = read(DATA_DIR + '2')
        self.greeting = read(DATA_DIR + '3')
        self.undefined = read(DATA_DIR + '4')
        self.referenced = read(DATA_DIR + '5')
        for i in self.referenced:
            i.replace('{}', '{}'.format(random.randint(44000, 55000)))

        self.verbs_with_noun_uncountable = read(DATA_DIR + '6')
        for i in self.verbs_with_noun_uncountable:
            i.replace('{}', '{}'.format(random.randint(44000, 55000)))

        self.verbs_with_noun_undef = read(DATA_DIR + '7')

        self.verbs_with_adjective = read(DATA_DIR + '8')

        self.flag_words = read(DATA_DIR + '9')

        self.repetition = read(DATA_DIR + '10')

        self.trigger_deal = ['What deal? I don\'t remember making any deal.',
                             'Tough luck. I suppose you will have to ... deal with it.',
                             'The deal is off.']
        self.trigger = ['deal',
                        'flag',
                        'help']
        self.prev = []
        self.pronoun = None
        self.noun = None
        self.adj = None



    def find_adjective(self, sent):
        adj = None
        self.adj = None

        for w, p in sent.pos_tags:
            if p.startswith('JJ'):
                adj = w
                if adj == 'only':
                    self.adj = 'only'
                break
        return adj

    def check_for_greeting(self, sentence):
        for word in sentence.words:
            if word.lower() in self.key_greeting:
                return random.choice(self.greeting)

    def check_triggers(self, sentence):
        for word in sentence.words:
            if word.singularize().lower() in self.trigger:
                return self.construct_triggered_response(word.lower())

    def starts_with_vowel(self, word):
        return True if word[0] in 'aeiou' else False

    def process_sentence(self, sentence):
        resp = self.respond(sentence)
        return resp

    def find_pronoun(self, sent):
        pronoun = None
        self.pronoun = None
        for word, part_of_speech in sent.pos_tags:
            if part_of_speech == 'PRP' and word.lower() == 'you':
                pronoun = 'I'
                self.pronoun = 'I'
            elif part_of_speech == 'PRP' and (word == 'I' or word.lower() == 'us'):
                pronoun = 'You'
            elif part_of_speech == 'PRP' and word.lower() == 'our':
                pronoun = 'Your'
                self.pronoun = 'our'
            elif part_of_speech == 'PRP' and word.lower() == 'we':
                pronoun = 'We'
            elif part_of_speech == 'PRP' and (word.lower() == 'he' or word.lower() == 'she' or word.lower() == 'they'):
                pronoun = word
            elif part_of_speech == 'PRP' and word.lower() in ('a', 'an'):
                pronoun = word
            elif part_of_speech == 'PRP' and word.lower() in ('this', 'that', 'it'):
                pronoun = 'It'

        return pronoun

    def find_verb(self, sent):
        verb = None
        pos = None
        for word, part_of_speech in sent.pos_tags:
            if part_of_speech.startswith('VB'):
                verb = word
                pos = part_of_speech
                break
        return verb, pos

    def find_noun(self, sent):
        noun = None
        self.noun = None

        if not noun:
            for w, p in sent.pos_tags:
                if p.startswith('NN'):
                    noun = w
                    if noun == 'hope':
                        self.noun = 'hope'
                    break
        return noun



    def construct_response(self, pronoun, noun, verb):
        resp = []

        if pronoun:
            resp.append(pronoun)

        if verb:
            verb_word = verb[0]
            if verb_word in ('be', 'am', 'is', "'m", 'are'):
                if pronoun.lower() == 'you':
                    resp.append("aren't really")
                elif self.pronoun == 'we':
                    resp.append('are nothing')
                else:
                    resp.append(verb_word)
            elif verb_word in ('help', 'rescue', 'assist'):
                resp.append(random.choice(['sure are dumb', 'need to %s yourself' % verb_word].extend(self.help_responses)))
            elif verb_word in ('had', 'agreed') and pronoun.lower() == 'we':
                resp.append()
            elif pronoun == 'It':
                resp.append('matters not')

        if noun:
            pronoun = "an" if self.starts_with_vowel(noun) else "a"
            resp.append(pronoun + " " + noun)

        resp.append(random.choice(("tho", "bro", "lol", "bruh", "smh", "right?")))

        return " ".join(resp)

    def construct_triggered_response(self, trigger_word):
        if trigger_word == 'help':
            return random.choice(self.help_responses)
        elif trigger_word == 'flag':
            return random.choice(self.flag_words)
        elif trigger_word == 'deal':
            return random.choice(self.trigger_deal)


    def check_for_comment_about_bot(self, pronoun, noun, adjective):
        resp = None
        if pronoun == 'I' and (noun or adjective):
            if noun:
                if self.adj is not None and self.pronoun is not None:
                    resp = '\n'.join(line for line in self.flag_words)
                elif random.choice((True, False)):
                    resp = random.choice(self.verbs_with_noun_uncountable).format(
                        **{'noun': noun.pluralize().capitalize()})
                else:
                    resp = random.choice(self.verbs_with_noun_undef).format(**{'noun': noun})
            else:
                resp = random.choice(self.verbs_with_adjective).format(**{'adjective': adjective})
        return resp

    def preprocess_text(self, sentence):
        cleaned = []
        words = sentence.strip(',;:-').rstrip('\n.!?').split(' ')
        for w in words:
            if w == 'i':
                w = 'I'
            if w == "i'm":
                w = "I'm"
            cleaned.append(w)

        return ' '.join(cleaned)

    def respond(self, sentence):

            cleaned = self.preprocess_text(sentence)
            parsed = TextBlob(cleaned)
            self.filter(sentence)

            if cleaned in self.prev:
                return random.choice(self.repetition)
            else:
                self.prev.append(cleaned)

            try:
                resp = self.check_triggers(parsed)

                pronoun, noun, adjective, verb = self.find_candidate_parts_of_speech(parsed)
                if not resp:
                    resp = self.check_for_comment_about_bot(pronoun, noun, adjective)

                if not resp:
                    resp = self.check_for_greeting(parsed)

                if not resp:
                    if not pronoun:
                        resp = random.choice(self.undefined)
                    elif pronoun == 'I' and not verb:
                        resp = random.choice(self.referenced)
                    else:
                        resp = self.construct_response(pronoun, noun, verb)

                if not resp:
                    resp = random.choice(self.undefined)

                return resp
            except:
                return random.choice(self.undefined)

    def find_candidate_parts_of_speech(self, parsed):
        pronoun = None
        noun = None
        adjective = None
        verb = None
        for sent in parsed.sentences:
            pronoun = self.find_pronoun(sent)
            noun = self.find_noun(sent)
            adjective = self.find_adjective(sent)
            verb = self.find_verb(sent)
        logger.info("Pronoun=%s, noun=%s, adjective=%s, verb=%s", pronoun, noun, adjective, verb)
        return pronoun, noun, adjective, verb


    def filter(self, resp):
        tokenized = resp.split(' ')
        for word in tokenized:
            if '@' in word or '#' in word or '!' in word:
                raise BadWordException()
            for s in self.blacklist:
                if word.lower().startswith(s):
                    raise BadWordException()