import re

FIRST_PERSON = ["i","my","me","mine","we","our","us","ours"]
THIRD_PERSON = ["he","his","him","she","her","hers","it","its","they","them","their","theirs"]
SECOND_PERSON = ["you","your","yours","u","ur","urs"]
PRONOUN_TAG = ["PRP","PRP$"]
WHWORD = ["WDT","WP","WP$","WRB"]
ADVERB = ["RB","RBR","RBS"]
FUTURE = ["will","gonna"]




def extract_num_of_first_person_pronouns(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result and result[0].lower() in FIRST_PERSON and result[1] in PRONOUN_TAG:
			cur_total += 1
	return cur_total

def extract_num_of_second_person_pronouns(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.match(r"[^/]+",tagged_token)
		if result and result.group(0).lower() in SECOND_PERSON:
			cur_total += 1
	return cur_total

def extract_num_of_third_person_pronouns(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.match(r"[^/]+",tagged_token)
		if result and result.group(0).lower() in THIRD_PERSON:
			cur_total += 1
	return cur_total

def extract_num_of_coordinating_conjunctions(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result and result[1] == "CC":
			cur_total += 1
	return cur_total

def extract_num_of_past_verbs(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result and result[1] == "VBD":
			cur_total += 1
	return cur_total

def extract_num_of_future_verbs(tag_list, total_num):
	cur_total = total_num
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
		else if result[0].lower() == "going":
			if i+1 < len(tag_list) and i+2 < len(tag_list):
				next_token = tag_list[i+1]
				next_next_token = tag_list[i+2]
				result_next = re.findall(r"[^/]+",next_token)
				result_next_next = re.findall(r"[^/]+",next_next_token)
				if result_next[0].lower() == "to" and result_next_next[1] == "VB":
					cur_total += 1
	return cur_total


def extract_num_of_commas(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result and result[0] == ",":
			cur_total += 1
	return cur_total

def extract_num_of_colons_and_semi_colons(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result and result[0] == ":" or result[1] == ";":
			cur_total += 1
	return cur_total

def extract_num_of_dashes(tag_list,total_num):
	#What is the definition of dash
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result and result[0] == "-":
			cur_total += 1
	return cur_total

def extract_num_of_parentheses(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result and result[0] == "(" or result[0] == ")":
			cur_total += 1
	return cur_total

def extract_num_of_ellipses(tag_list, total_num):
	# more that 3 consecutive . still ellipsis?
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result and result[0] == "\"":
			cur_total += 1
	return cur_total


def extract_num_of_common_nouns(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result and result[1] == "NN" or result[1] == "NNS":
			cur_total += 1
	return cur_total

def extract_num_of_proper_nouns(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result and result[1] == "NNP" or result[1] == "NNPS":
			cur_total += 1
	return cur_total


def extract_num_of_adverbs(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result and result[1] in ADVERB:
			cur_total += 1
	return cur_total


def extract_num_of_whwords(tag_list, total_num):
	cur_total = total_num
	for tagged_token in tag_list:
		result = re.findall(r"[^/]+",tagged_token)
		if result and result[1] in WHWORD:
			cur_total += 1
	return cur_total
	

def extract_num_of_slangs():
	return None


if __name__ == "__main__":
