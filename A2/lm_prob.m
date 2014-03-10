function logProb = lm_prob(sentence, LM, type, delta, vocabSize)
%
%  lm_prob
% 
%  This function computes the LOG probability of a sentence, given a 
%  language model and whether or not to apply add-delta smoothing
%
%  INPUTS:
%
%       sentence  : (string) The sentence whose probability we wish
%                            to compute
%       LM        : (variable) the LM structure (not the filename)
%       type      : (string) either '' (default) or 'smooth' for add-delta smoothing
%       delta     : (float) smoothing parameter where 0<delta<=1 
%       vocabSize : (integer) the number of words in the vocabulary
%
% Template (c) 2011 Frank Rudzicz

  logProb = -Inf;

  % some rudimentary parameter checking
  if (nargin < 2)
    disp( 'lm_prob takes at least 2 parameters');
    return;
  elseif nargin == 2
    type = '';
    delta = 0;
    vocabSize = length(fieldnames(LM.uni));
  end
  if (isempty(type))
    delta = 0;
    vocabSize = length(fieldnames(LM.uni));
  elseif strcmp(type, 'smooth')
    if (nargin < 5)  
      disp( 'lm_prob: if you specify smoothing, you need all 5 parameters');
      return;
    end
    if (delta <= 0) or (delta > 1.0)
      disp( 'lm_prob: you must specify 0 < delta <= 1.0');
      return;
    end
  else
    disp( 'type must be either '''' or ''smooth''' );
    return;
  end

  words = strsplit(' ', sentence);
  

  % TODO: the student implements the following
  % TODO: once upon a time there was a curmudgeonly orangutan named Jub-Jub.
  
  %have not considered smoothing
    
  logProb = 0;
  for j=2:length(words)-1
      w_1 = words{j-1};
      if isfield(LM.uni,w_1)
          % w_2 is the next word adjacent to w_1
          w_2 = words{j};
          % setting the denom
          denom = LM.uni.(w_1) + delta*vocabSize;
          if isfield(LM.bi.(w_1),w_2)==1
            % setting the norm
            nom = LM.bi.(w_1).(w_2) + delta;
            logProb = logProb + log2(nom / denom);
          elseif delta ~= 0
            % smooth is specified
            nom = delta;
            logProb = logProb + log2(nom / denom);
          else
            % smooth is not specified, logProb should be -Inf
            logProb = -Inf;
            return
          end
      elseif delta ~= 0
        % smooth is specified
        nom = delta;
        denom = delta*vocabSize;
        logProb = logProb + log2(nom / denom);
      else
        logProb = -Inf;
        return
      end
  end
  return
  