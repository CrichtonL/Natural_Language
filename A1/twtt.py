import sys
import re
import HTMLParser
import nltk.data
import string
import NLPlib

def preprocessing_input(input_line):
    return None

def remove_html_simbol(input_line):
    #get rid of tags
    new_line = re.sub('<[^<]*>', '', input_line)
    #replace all html character codes with ASCII equivalent
    parser = HTMLParser.HTMLParser()
    new_line = str(parser.unescape(new_line))
    #remove all the urls
    new_line = re.sub('http\S+|www\S+', '', new_line)
    #remove the preceeding @ and # 
    new_line = re.sub('^@', '', new_line)
    new_line = re.sub('^#', '', new_line)
    return new_line

def break_line(input_line):
    tokenizer = nltk.data.load('tokenizers/punkt/english.pickle')
    sentense_list = tokenizer.tokenize(data)
    return None

def my_lame_break_line(input_line,abbrev_list):
    # have not consider the case sentense in quotation
    ending_punc = ['.','?','!']
    input_list = input_line.strip().split()
    elem_list = []
    sentense_list = []
    for elem in input_list:
        if elem[-1] in ending_punc and not is_abbrev(elem, abbrev_list):
            elem_list.append(elem)
            sentense_list.append(" ".join(elem_list))
            elem_list = []
        else:
            elem_list.append(elem)
    return sentense_list

def is_abbrev(word_token, abbrev_list):
    return (word_token in abbrev_list)

def is_noun(word_token):
    return None

def separate_punctuation(word_token):
    return None

def is_possession(word_token, next_token):
    i = word_token.find("'")
    if i != len(word_token) - 2:
        if word_token[i+1] == 's':
            return is_noun(next_token)
        else:
            # it is clitic
            return False
    else:
        # no idea what it is
        return False

def tokenize_and_tag_sentense(sentense_list):
    token_list_list = []
    for sentense in sentense_list:
        token_list = re.findall(r"[\w']+|[.,!?;]+", sentense)
        for i in range(len(token_list)):
            if i < len(token_list) - 1:
                if is_possession(token_list[i],token_list[i+1]):
                    token_list = token_list[:i] + \
                    re.findall(r"[\w]+|['s]", token_list[i]) +\
                    token_list[i+1:]
    return token_list_list


def tag_tokens(token_list):
    tagger = NLPLib.NLPlib()
    tags = tagger.tag(token_list)
    return tag_sentense = " ".join(tags)


if __name__ == '__main__':
    file_name = sys.argv[1]
    abbrev_english = "/u/cs401/Wordlists/abbrev.english"
    tweet_file = open(file_name,'r')
    abbrev_file = open(abbrev_english, 'r')
    revised_file = open(file_name+"_revised", 'w')

    abbrev_list = []
    for line in abbrev_file:
        abbrev_list.append(line)
        
    line = tweet_file.readline()

    temp_line = "";
