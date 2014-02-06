import re
import sys
import argparse
import string

FEATURE_NUM = 20

FIRST_PERSON = ["i","my","me","mine","we","our","us","ours"]
THIRD_PERSON = ["he","his","him","she","her","hers","it","its","they","them","their","theirs"]
SECOND_PERSON = ["you","your","yours","u","ur","urs"]
PRONOUN_TAG = ["PRP","PRP$"]
WHWORD = ["WDT","WP","WP$","WRB"]
ADVERB = ["RB","RBR","RBS"]
FUTURE = ["will","gonna"]

FEATURES = ["first_person_pronouns",\
			"second_person_pronouns",\
			"third_person_pronouns", \
			"coord_conj",\
			"past_tense_verb",\
			"future_tense_verb",\
			"commas_num",
			"colons_and_semi_colons",\
			"dash_num",\
			"paren_num",\
			"ellipses_num",\
			"common_nouns",\
			"proper_nouns",\
			"adverb_num", \
			"whwords_num",\
			"slang_num",\
			"all_in_upper_case_num",\
			"avg_len_of_sentense",\
			"avg_len_of_tokens",\
			"num_of_sentense"]

#hard code a list filled with 0s to record statistics
STATS = [0]*FEATURE_NUM

def is_first_person_pronoun(token):
	return int(token.lower() in FIRST_PERSON)

def is_second_person_pronoun(token):
	return int(token.lower() in SECOND_PERSON)

def is_third_person_pronoun(token):
	return int(token.lower() in THIRD_PERSON)

def is_coordinating_conjunction(tagged_token):
	return int(tagged_token == "CC")

def is_past_verb(tagged_token):
	return int(tagged_token == "VBD")

def extract_future_verbs(tag_list):
	cur_total = 0
	for i in range(len(tag_list)):
		tagged_token = tag_list[i]
		result = re.findall(r"[^/]+",tagged_token)
		# thin line could be unsafe
		if result and (result[0].lower() in FUTURE or result[0].find("'ll") != -1):
			if i+1 < len(tag_list):
				next_token = tag_list[i+1]
				result = re.findall(r"[^/]+",next_token)
				if result and result[1] == "VB":
					cur_total += 1
		elif result[0].lower() == "going":
			if i+1 < len(tag_list) and i+2 < len(tag_list):
				next_token = tag_list[i+1]
				next_next_token = tag_list[i+2]
				result_next = re.findall(r"[^/]+",next_token)
				result_next_next = re.findall(r"[^/]+",next_next_token)
				if result_next[0].lower() == "to" and result_next_next[1] == "VB":
					cur_total += 1
	return cur_total


def is_comma(token):
	return int(token == ",")

def is_colon_or_semi_colon(token):
	return int(token == ":" or token ==";")

def is_dash(token):
	#What is the definition of dash
	return int(token == "-" * len(token))

#check the def of parenthese
def is_parentheses(token):
	return int(token == "(" or token == ")")

def is_ellipses(token):
	#need to modify it later
	return (token == "." * len(token) and len(token) > 2)


def is_common_noun(tagged_token):
	return int(tagged_token == "NN" or tagged_token == "NNS")

def is_proper_noun(tagged_token):
	return int(tagged_token == "NNP" or tagged_token == "NNPS")

def is_adverb(tagged_token):
	return int(token.lower() in ADVERB)


def is_whword(tagged_token):
	return int(token.lower() in WHWORD)
	
def is_all_upper(token):
	return (len(token) >= 2 and token.isupper())

def is_slang():
	return None


if __name__ == "__main__":

	max_tweet_num = 100000

	input_args = sys.argv[1:-1]
	file_output = sys.argv[-1]
	arff_file = open(file_output,'w')

	relation = re.findall(r"\w+(?=.arff)",file_output)[0]
	print relation
	classes = []
	class_files = []


	if input_args[0][0] == "-":
		max_tweet_num = int(input_args[0][1:])
		print max_tweet_num
		input_args = input_args[1:]
		print input_args


	for i in range(len(input_args)):
		input_arg = input_args[i].split(":")
		classes.append(input_arg[0])
		class_files.append(input_arg[-1].split("+"))

	print classes
	print class_files

	print FEATURES

	print >> arff_file, "@relation " + relation
	print >> arff_file, ""
	for elem in FEATURES:
		print >> arff_file, "@attribute " + elem + " numeric"
	print >> arff_file, ""
	print >> arff_file, "@data"

	index = 0
	punctuation = set(string.punctuation)
	for class_name in classes:
		
		num_of_sentense = 0
		num_of_tokens = 0
		total_len_of_token = 0
		STATS = [0] * FEATURE_NUM
		files = class_files[index]
		for twt_file in files:
			num_of_tweet = 0
			#processing the file
			for line in twt_file:
				if line.strip() == "|":
					num_of_tweet += 1
				if num_of_tweet == max_tweet_num:
					break
				else:
					num_of_sentense += 1
					tagged_token_list = line.strip().split()
					STATS[FEATURES.index("future_tense_verb")] += extract_future_verbs(tagged_token_list)
					token_list = []
					tag_list = []
					#initialize tag list and token list
					for tagged_token in tagged_token_list:
						r = re.findall(r"[^/]+",tagged_token)
						#check to see if it is punctuation
						token = ''.join(ch for ch in r[0] if ch not in punctuation)
						if len(token) > 0:	
							total_len_of_token + len(token)
							num_of_tokens += 1
						token_list.append(r[0])
						tag_list.append(r[1])

					for i in range(len(tagged_token_list)):
						token = token_list[i]
						tag = tag_list[i]
						#extracting features
						STATS[FEATURES.index("first_person_pronouns")] += is_first_person_pronoun(token)
						STATS[FEATURES.index("second_person_pronouns")] += is_second_person_pronoun(token)
						STATS[FEATURES.index("third_person_pronouns")] += is_third_person_pronoun(token)
						STATS[FEATURES.index("coord_conj")] += is_coordinating_conjunction(token)
						STATS[FEATURES.index("past_tense_verb")] += is_past_verbs(tag)
						STATS[FEATURES.index("commas_num")] += is_commas(token)
						STATS[FEATURES.index("colons_and_semi_colons")] += is_colon_or_semi_colon(token)
						STATS[FEATURES.index("dash_num")] += is_dash(token)
						STATS[FEATURES.index("paren_num")] += is_parentheses(token)
						STATS[FEATURES.index("ellipses_num")] += is_ellipses(token)
						STATS[FEATURES.index("common_nouns")] += is_common_noun(tag)
						STATS[FEATURES.index("proper_nouns")] += is_proper_noun(tag)
						STATS[FEATURES.index("adverb_num")] += is_adverb(tag)
						STATS[FEATURES.index("whwords_num")] += is_whword(token)
						STATS[FEATURES.index("slang_num")] += is_slang(token)
		STATS[FEATURES.index("avg_len_of_sentense")] = int(num_of_tokens/num_of_sentense)	
		STATS[FEATURES.index("avg_len_of_tokens")] = int(total_len_of_token/num_of_tokens)
		STATS[FEATURES.index("num_of_sentense")] = num_of_sentense
		print >> arff_file, str(STATS)[1:-1] + "," + class_name
		index += 1










				


	


