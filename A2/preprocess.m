function outSentence = preprocess( inSentence, language )
%
%  preprocess
%
%  This function preprocesses the input text according to language-specific rules.
%  Specifically, we separate contractions according to the source language, convert
%  all tokens to lower-case, and separate end-of-sentence punctuation 
%
%  INPUTS:
%       inSentence     : (string) the original sentence to be processed 
%                                 (e.g., a line from the Hansard)
%       language       : (string) either 'e' (English) or 'f' (French) 
%                                 according to the language of inSentence
%
%  OUTPUT:
%       outSentence    : (string) the modified sentence
%
%  Template (c) 2011 Frank Rudzicz 

  global CSC401_A2_DEFNS
  
  % just to make the script work
  csc401_a2_defns

  % first, convert the input sentence to lower-case and add sentence marks 
  inSentence = [CSC401_A2_DEFNS.SENTSTART ' ' lower( inSentence ) ' ' CSC401_A2_DEFNS.SENTEND];

  % trim whitespaces down 
  inSentence = regexprep( inSentence, '\s+', ' '); 

  % initialize outSentence
  outSentence = inSentence;

  

  % perform language-agnostic changes
  % TODO: your code here
  %    e.g., outSentence = regexprep( outSentence, 'TODO', 'TODO');

  switch language
   case 'e'
    % TODO: your code here
    reg = 'n''t|''ll|[0-9,]+[0-9]+\.[0-9]+|\w+(?=n''t)|\w+|''\w(?= )|[\.?!]+|[\*,&;:$\-\+()%<>]|[''\\"]+'
    outSentence = regexp(outSentence, reg, 'match'); 
   case 'f'
    % TODO: your code 
    % add more ciriteria
    reg = 'l''|qu''|\w+''(?=on)|\w+''(?=il)|\w''|[0-9,]+[0-9]+\.[0-9]+|(\w\.)+|\w+|[\.?!]+|[\*,&;:$\-\+()%<>]|[''\\"]+';
    outSentence = regexp(outSentence, reg, 'match');
  end

  % change unpleasant characters to codes that can be keys in dictionaries
  outSentence = convertSymbols( outSentence );
  outSentence = sprintf('%s ' ,outSentence{:});
  outSentence = strtrim(outSentence);