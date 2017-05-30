import random

from tech_support import read


class Bot(object):
    def __init__(self):
        from ServiceLogic import DATA_DIR
        DATA_DIR += DATA_DIR
        # bad words
        try:
            self.blacklist = read(DATA_DIR + '1')
        except:
            self.blacklist = ['fuck', 'ass', 'you']
        # recognized greetings
        try:
            self.key_greeting = read(DATA_DIR + '2')
        except:
            self.key_greeting = ['I\'m just a test bot.']
        # greeting responses
        try:
            self.greeting = read(DATA_DIR + '3')
        except:
            self.greeting = ['I\'m just a test bot.']
        # if not understood
        try:
            self.undefined = read(DATA_DIR + '4')
        except:
            self.undefined = ['I\'m just a test bot.']
        # talking about CTFBot
        try:
            self.referenced = read(DATA_DIR + '5')
        except:
            self.referenced = ['I\'m just a test bot.']
        # Template for responses that include a direct noun which is indefinite/uncountable
        try:
            self.verbs_with_noun_uncountable = read(DATA_DIR + '6')
            self.verbs_with_noun_undef = read(DATA_DIR + '7')
            self.verbs_with_adjective = read(DATA_DIR + '8')

        except:
            self.verbs_with_noun_uncountable = ['me', 'you']
            self.verbs_with_noun_undef = ['me', 'you']
            self.verbs_with_adjective = ['me', 'you']
        try:
            self.curses = read(DATA_DIR + '9')
        except:
            self.curses = ['No flag for you']
        try:
            self.comeback = read(DATA_DIR + '10')
        except:
            self.comeback = ['No flag for you']

        self.prev_sentence = None

    def process_sentence(self, sentence):
        if sentence in self.key_greeting:
            return random.choice(self.greeting)
        else:
            return random.choice(self.undefined)