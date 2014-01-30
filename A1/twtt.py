import sys
import re
import HTMLParser
import nltk.data
import string

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

def is_clitic():
    return None

def separate_multiple_puncutaion(word_with_punc):
    return None

def tokenize_sentense(sentense_list):
    token_list = []
    for sentense in sentense_list:
        sentesnse_list = sentense.split()
        for elem in sentense_list:
            if elem[-1] in string.punctuation:
                token_list.append(elem[0:-1])
                token_list.append(elem[-1])
            else:
                token_list.append(elem)
    return None

def tag_tokens(token_list):
    return None

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
    #break the sentense within the tweets.
    #for element in new_line.split():
        #if element not in abbrev_list:
            #break the line

        #else:
            #temp_line = temp_line +  " " + element
          

            #do not break the line
    
    #while line != '' : 
        
    #for line in tweet_file:
        #print(line)
        #line = tweet_file.readline()


    
