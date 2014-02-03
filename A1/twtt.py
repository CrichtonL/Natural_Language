import sys
import re
import HTMLParser
import nltk.data
import string
import NLPlib

ENDING_PUNC = ['.','?','!']

def remove_html_stuff(input_line):
    #get rid of tags
    new_line = re.sub('<[^<]*>', '', input_line)
    #replace all html character codes with ASCII equivalent
    parser = HTMLParser.HTMLParser()
    new_line = str(parser.unescape(new_line))
    #remove all the urls
    new_line = re.sub('http\S+|www\S+', '', new_line)
    new_line = re.sub('\S+/\S+', '', new_line)
    #remove the preceeding @ and # 
    new_line = new_line.strip().split()
    for i in range(len(new_line)):
        if re.match(r'^@\w+|^#\w+', new_line[i]):
            new_line[i] = new_line[i][1:]
    new_line = " ".join(new_line)
    #incase some tweet does no include an ending punc
    new_line = new_line.strip()
    if new_line.split()[-1][-1] not in ENDING_PUNC:
        new_line = new_line + '.'
    return new_line

def my_lame_break_line(input_line,abbrev_list):
    # have not consider the case sentense in quotation
    input_list = input_line.strip().split()
    elem_list = []
    sentense_list = []
    for elem in input_list:
        if elem[-1] in ENDING_PUNC and not is_abbrev(elem, abbrev_list):
            elem_list.append(elem)
            sentense_list.append(" ".join(elem_list))
            elem_list = []
        else:
            elem_list.append(elem)
    return sentense_list

def is_abbrev(word_token, abbrev_list):
    return (word_token in abbrev_list)

def tokenize_sentense(sentense_list):
    token_list_list = []
    for sentense in sentense_list:
        # not perfect, still have not covered the case of s' which is a sign of possession
        token_list = re.findall(r"n't|[0-9,]+|[0-9]+% |[\w]+|'\w |[.,!?;:$]+|['\"]+", sentense)
        token_list = map(lambda x: x.strip(), token_list)
        token_list_list.append(token_list)
    return token_list_list


def tag_tokens(token_list_list):
    tag_list_list = []
    for token_list in token_list_list:
        tagger = NLPlib.NLPlib()
        tags = tagger.tag(token_list)
        for i in range(len(token_list)):
            tags[i] = token_list[i] + '/' + tags[i]
        tag_list_list.append(tags)
    return tag_list_list

if __name__ == '__main__':
    file_input = sys.argv[1]
    file_output = sys.argv[2]
    abbrev_english = "/u/cs401/Wordlists/abbrev.english"
    tweet_file = open(file_input,'r')
    abbrev_file = open(abbrev_english, 'r')
    revised_file = open(file_output, 'w')

    abbrev_list = []
    for line in abbrev_file:
        abbrev_list.append(line.strip())
    print abbrev_list
        
    for line in tweet_file:
        print >> revised_file,"|" 
        print >> revised_file,line 
        print >> revised_file,"---------------------------------------------------"
        new_line = remove_html_stuff(line)
        print >> revised_file,new_line
        sentense_list = my_lame_break_line(new_line,abbrev_list)
        print sentense_list
        token_list_list = tokenize_sentense(sentense_list) 
        tag_list_list = tag_tokens(token_list_list)
        print tag_list_list
        for tag_list in tag_list_list:
            print  >> revised_file, " ".join(tag_list)
    print >> revised_file,"|" 

