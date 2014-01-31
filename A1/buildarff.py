import re

FIRST_PERSON = ["i","my","me","mine","we","our","us","ours"]
THIRD_PERSON = ["he","his","him","she","her","hers","it","its","they","them","their","theirs"]
SECOND_PERSON = ["you","your","yours","u","ur","urs"]
PRONOUN_TAG = ["PRP","PRP$"]
WHWORD = ["WDT","WP","WP$","WRB"]
ADVERB = ["RB","RBR","RBS"]




def extract_num_of_first_person_pronouns(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result:
			if result[0].lower() in FIRST_PERSON and result[1] in PRONOUN_TAG:
				cur_total += 1
	return cur_total

def extract_num_of_second_person_pronouns(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.match(r"[^/]+",tagged_token)
		if result:
			if result.group(0).lower() in SECOND_PERSON:
				cur_total += 1
	return cur_total

def extract_num_of_third_person_pronouns(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.match(r"[^/]+",tagged_token)
		if result:
			if result.group(0).lower() in THIRD_PERSON:
				cur_total += 1
	return cur_total

def extract_num_of_coordinating_conjunctions(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result:
			if result[1] == "CC":
				cur_total += 1
	return cur_total

def extract_num_of_past_verbs(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result:
			if result[1] == "VBD":
				cur_total += 1
	return cur_total

def extract_num_of_future_verbs(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result:
			if result[1] == "VBD":
				cur_total += 1
	return cur_total


def extract_num_of_commas(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result:
			if result[0] == ",":
				cur_total += 1
	return cur_total

def extract_num_of_colons_and_semi_colons(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result:
			if result[0] == ":" or result[1] == ";":
				cur_total += 1
	return cur_total

def extract_num_of_dashes(tag_list,total_num):
	#What is the definition of dash
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result:
			if result[0] == "-":
				cur_total += 1
	return cur_total

def extract_num_of_parentheses(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result:
			if result[0] == "(" or result[0] == ")":
				cur_total += 1
	return cur_total

def extract_num_of_ellipses(tag_list, total_num):
	# more that 3 consecutive . still ellipsis?
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result:
			if result[0] == "\"":
				cur_total += 1
	return cur_total


def extract_num_of_common_nouns(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result:
			if result[1] == "NN" or result[1] == "NNS":
				cur_total += 1
	return cur_total

def extract_num_of_proper_nouns(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result:
			if result[1] == "NNP" or result[1] == "NNPS":
				cur_total += 1
	return cur_total


def extract_num_of_adverbs(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result:
			if result[1] in ADVERB:
				cur_total += 1
	return cur_total


def extract_num_of_whwords(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result:
			if result[1] in WHWORD:
				cur_total += 1
	return cur_total
	

def extract_num_of_slangs():
	return None


if __name__ == "__main__":
