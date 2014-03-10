%
% evalAlign
%
%  This is simply the script (not the function) that you use to perform your evaluations in 
%  Task 5. 

% some of your definitions
trainDir     = '/u/cs401/A2_SMT/data/Hansard/Training';
testDir      = '/u/cs401/A2_SMT/data/Hansard/Testing';
fn_LME       = 'LM_ENG.mat';
fn_LMF       = 'LM_FREN.mat';
lm_type      = 'smooth';
delta        = 0.01;
vocabSize    = 0;
numSentences = {1000,10000,15000,30000};
%alignment model
fn_AM = {'NEW_AM_1000_40.mat', 'NEW_AM_10000_40.mat', 'NEW_AM_15000_40.mat', 'NEW_AM_30000_40.mat'};

% Train your language models. This is task 2 which makes use of task 1
LME = load('LM_ENG.mat');
LME = LME.LM;

f_lines = textread(['./Testing', filesep, 'Task5.f'], '%s','delimiter','\n');
e_lines = textread(['./Testing', filesep, 'Task5.e'], '%s','delimiter','\n');

eng = {};
fre = {};
translated_eng = {};


% Preprocess both French sentense and English Sentense
for i=1:length(f_lines)
    fre{i} = preprocess(f_lines{i}, 'f');
    eng{i} = preprocess(e_lines{i}, 'e');
end


for fn=1:length(fn_AM)
    CUR_AM = fn_AM{fn}
    AMFE = load(CUR_AM);
    AMFE = AMFE.AM;
    for j=1:length(f_lines)
        % Decode the test sentence 'fre'
        translated_eng{j} = decode( fre{j}, LME, AMFE, '', 0, vocabSize );
        fprintf('line #%d \n', j);
        fprintf('%s ', eng{j});
        fprintf('\n')
        fprintf('%s ', translated_eng{j}{:});
        fprintf('\n')
    end

    % compare translated_eng and eng
    total_word_num = 0;
    num_correct_word = 0;
    num_correct_pos_and_word = 0;

    for i=1:length(eng)
        correct_answer = strsplit(' ', eng{i});
        translate_result = translated_eng{i};
        % if the position of the translated word is within def from the position it should to be
        % this translated word is considered as in the correct position.
        def = abs(length(correct_answer) - length(translate_result));

        for j=1:length(correct_answer)
            pos = find(strcmp(translate_result, correct_answer{j}));
            % check to see if correct answer has the translated word
            if ~isempty(pos)
                num_correct_word = num_correct_word + 1;
                % check to see if the ranslated world is at a resonable position
                if abs(pos - j) <= def
                    num_correct_pos_and_word = num_correct_pos_and_word + 1;
                end
            end        
        end
        total_word_num = total_word_num + length(correct_answer);
    end
    r_correct_words = num_correct_word / total_word_num;
    r_correct_pos = num_correct_pos_and_word / total_word_num;
    fprintf('AM_NAME: %s, RATIO_CORRECT_WORDS: %f, RATIO_CORRECT_WORDS&POS: %f.\n', CUR_AM, r_correct_words, r_correct_pos);
end
