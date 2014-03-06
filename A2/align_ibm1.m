function AM = align_ibm1(trainDir, numSentences, maxIter, fn_AM)
%
%  align_ibm1
% 
%  This function implements the training of the IBM-1 word alignment algorithm. 
%  We assume that we are implementing P(foreign|english)
%
%  INPUTS:
%
%       dataDir      : (directory name) The top-level directory containing 
%                                       data from which to train or decode
%                                       e.g., '/u/cs401/A2_SMT/data/Toy/'
%       numSentences : (integer) The maximum number of training sentences to
%                                consider. 
%       maxIter      : (integer) The maximum number of iterations of the EM 
%                                algorithm.
%       fn_AM        : (filename) the location to save the alignment model,
%                                 once trained.
%
%  OUTPUT:
%       AM           : (variable) a specialized alignment model structure
%
%
%  The file fn_AM must contain the data structure called 'AM', which is a 
%  structure of structures where AM.(english_word).(foreign_word) is the
%  computed expectation that foreign_word is produced by english_word
%
%       e.g., LM.house.maison = 0.5       % TODO
% 
% Template (c) 2011 Jackie C.K. Cheung and Frank Rudzicz
  
  global CSC401_A2_DEFNS
  
  AM = struct();
  
  % Read in the training data
  [eng, fre] = read_hansard(trainDir, numSentences);

  % Initialize AM uniformly 
  AM = initialize(eng, fre);

  % Iterate between E and M steps
  for iter=1:maxIter,
    AM = em_step(AM, eng, fre);
  end

  % Save the alignment model
  save( fn_AM, 'AM', '-mat'); 

  end





% --------------------------------------------------------------------------------
% 
%  Support functions
%
% --------------------------------------------------------------------------------

function [eng, fre] = read_hansard(dir, numSentences)
%
% Read 'numSentences' parallel sentences from texts in the 'dir' directory.
%
% Important: Be sure to preprocess those texts!
%
% Remember that the i^th line in fubar.e corresponds to the i^th line in fubar.f
% You can decide what form variables 'eng' and 'fre' take, although it may be easiest
% if both 'eng' and 'fre' are cell-arrays of cell-arrays, where the i^th element of 
% 'eng', for example, is a cell-array of words that you can produce with
%
%         eng{i} = strsplit(' ', preprocess(english_sentence, 'e'));
%
  eng = {};
  fre = {};

  % TODO: your code goes here.

  DD_f = dir( [ dir, filesep, '*.', 'f'] );
  DD_e = dir( [ dir, filesep, '*.', 'e'] );

  disp([ dir, filesep, '*.', language] );
  % DD_f and DD_e should have the same length
  for iFile=1:length(DD_f)
    DD_e(iFile).name
    DD_f(iFile).name
    e_lines = textread([dir, filesep,DD_e(iFile).name], '%s','delimiter','\n');
    f_lines = textread([dir, filesep,DD_e(iFile).name], '%s','delimiter','\n');

    for l=1:numSentences
      english_sentence = e_lines{l};
      french_sentence = f_lines{l};
      eng{i} = strsplit(' ', preprocess(english_sentence, 'e'));
      fre{i} = strsplit(' ', preprocess(french_sentence, 'f'));
    end
  end

end


function AM = initialize(eng, fre)
%
% Initialize alignment model uniformly.
% Only set non-zero probabilities where word pairs appear in corresponding sentences.
%
% TODO: your code goes here
  AM = {}; % AM.(english_word).(foreign_word)

  AM.SENTSTART.SENTSTART = 1;
  AM.SENTEND.SENTEND = 1;

  for l=1:length(eng)
    english_words = eng{l};
    %english_words = english(2:length(english_words)-1);
    french_words = fre{l};
    %french_words = french_words(2:length(french_words)-1);
    for w_e =2:length(english_words)-1

      e_word = english_words{w_e};

      if isfield(AM,e_word) ~= 1
        AM.(e_word) = {};
      end

      for w_f=2::length(french_words)-1

        f_word = french_words{w_f};

        if isfield(AM.(e_word),f_word) ~= 1
           AM.(e_word).(f_word) = 1 / (length(fre) - 2);
        end

        AM.(e_word).(f_word) = 1 / (1 / AM.(e_word).(f_word) + length(fre) - 2)%ingnore SENTSTART and SENTEND
      end
    end
  end

end

%
% helper function for counting the occurence of a specific word 
%

function wc = count_unique_word(words)
  wc = {};
  for w=2:length(words)-1
    word = words{w};
    if isfield(wc,f_word) ~= 1
      wc.(word) = 1;
    end
    wc.(word) = wc.(word) + 1;
  end
end

function t = em_step(t, eng, fre)


% 
% One step in the EM algorithm.
%
  
  % TODO: your code goes here

  total = {};
  tcount = {};

  f_history = {};
  e_history = {};
  e_fieldnames = fieldnames(t);
  % initialize tcount and total
  for i=1:length(e_fieldnames)
    e = e_fieldnames{i};
    total.(e) = 0;
    tcount.(e) = {};
    f_fieldnames = fieldnames(t.(e));
    for j=1:length(f_fieldnames)
      tcount.(e).(f_fieldnames(j)) = 0;
    end
  end

  for l=1:length(eng)
    english_words = eng{l};
    french_words = fre{l};
    wc_e = count_unique_word(english_words);
    wc_f = count_unique_word(french_words);
    for w_f=2:length(french_words)-1
        f_word = french_words{w_f};
        if isfield(f_history,f_word) ~= 1
          % record history
          f_history.(f_word) = 1;
          denom_c = 0;
          for w_e=2:length(english_words)-1
            e_word = english_words{w_e};
            if isfield(e_history,e_word) ~= 1
              e_history.(e_word) = 1;
              denom_c = denom_c + t.(e_word).(f_word) * wc_f.(f_word);
            end
          end
          % clear history
          e_history = {};
          for w_e=2:length(english_words)-1
            e_word = english_words{w_e};
            if isfield(e_history,e_word) ~= 1
              e_history.(e_word) = 1;
              tcount.(e_word).(f_word) = tcount.(e_word).(f_word) + t.(e_word).(f_word) * wc_f.(f_word) * wc_e.(e_word) / denom_c;
              total.(e_word) =  total(e_word) + t.(e_word).(f_word) * wc_f.(f_word) * wc_e.(e_word) / denom_c;
            end
          end

        end
    end
  end



end








