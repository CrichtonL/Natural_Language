import sys
import re
import html.parser



if __name__ == '__main__':
    file_name = sys.argv[1]
    abbrev_english = "/u/cs401/Wordlists/abbrev.english"
    tweet_file = open(file_name,'r')
    abbrev_file = open(abbrev_list, 'r')
    revised_file = open(file_name+"_revised", 'w')

    abbrev_list = []
    for line in abbrev_file:
        abbrev_list.append(line)
        
    line = tweet_file.readline()
    print(line)
    #get rid of tags
    new_line = re.sub('<[^<]*>', '', line)
    print(new_line)
    #replace all html character codes with ASCII equivalent
    parser = html.parser.HTMLParser()
    new_line = parser.unescape(new_line)
    print(new_line)
    #remove all the urls
    new_line = re.sub('http\S+|www\S+', '', new_line)
    print(new_line)
    #remove the preceeding @ and # 
    new_line = re.sub('^@', '', new_line)
    new_line = re.sub('^#', '', new_line)
    print(new_line)
    temp_line = "";
    #break the sentense within the tweets.
    for element in new_line.split():
        if element not in abbrev_list:
            #break the line
        else:
            temp_line = temp_line +  " " + element
          

            #do not break the line
    
    #while line != '' : 
        
    #for line in tweet_file:
        #print(line)
        #line = tweet_file.readline()


    
