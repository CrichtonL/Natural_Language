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
  csc401_a2_defns
  global CSC401_A2_DEFNS
  
  % first, convert the input sentence to lower-case and add sentence marks 
  inSentence = [CSC401_A2_DEFNS.SENTSTART ' ' lower( inSentence ) ' ' CSC401_A2_DEFNS.SENTEND];

  % trim whitespaces down 
  inSentence = regexprep( inSentence, '\s+', ' '); 

  % initialize outSentence
  outSentence = inSentence;

  % perform language-agnostic changes
  % TODO: your code here
  %    e.g., outSentence = regexprep( outSentence, 'TODO', 'TODO');
  outSentence = regexprep( outSentence, '[\*\-\+\=\,\.\?\!:;"`\(\)\[\]/\$\%\&<>](\s)?',' $1 ');
  
  switch language
   case 'e'
    % handle clitics
    outSentence = regexprep( outSentence, '(\w+?)(n{0,1}\''\w*)', '$1 $2');

   case 'f'
    % handle singular definite article
    outSentence = regexprep( outSentence, '(\bl\'')(\w+)', '$1 $2');
    
    % handle single-consonant words ending in e-'muet', except for words
    % d'accord, d'abord, d'ailleurs and d'habitude
    outSentence = regexprep(outSentence, '(?!(d''accord|d''abord|d''ailleurs|d''habitude))(\w\'')(\w+)', '$1 $2');
    
    % handle que
    outSentence = regexprep( outSentence, '(qu\'')(\w+)', '$1 $2');
    
    % handle conjunctions
    outSentence = regexprep( outSentence, '(\w+\'')(on|il)', '$1 $2');
  end
  outSentence = regexprep( outSentence, '\s+', ' ');

  % change unpleasant characters to codes that can be keys in dictionaries
  outSentence = convertSymbols( outSentence );

