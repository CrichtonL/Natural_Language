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
fn_AM = {'AM_1000_40.mat', 'AM_10000_40.mat', 'AM_15000_40.mat', 'AM_30000_40.mat'};

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


% translate the Frech sentenses
for i=1:1%1:length(numSentences)
    % Train your alignment model of French, given English 
    %AMFE = align_ibm1( trainDir, numSentences{i} , 50, 'am.mat');
    AMFE = load('AM_30000_40.mat');
    AMFE = AMFE.AM;
    % 
    for j=1:length(f_lines)
        % Decode the test sentence 'fre'
        translated_eng{j} = decode( fre{j}, LME, AMFE, '', 0, vocabSize );
        fprintf('line #%d \n', j);
        fprintf('%s ', eng{j});
        fprintf('\n')
        fprintf('%s ', translated_eng{j}{:});
        fprintf('\n')
    end
end

% compare translated_eng and eng
total_word_num = 0;
num_correct_word = 0;
% tolerate off position within two words from the correct position 
num_correct_pos_and_word = 0;

for i=1:length(eng)
    correct_answer = strsplit(' ', eng{i});
    translate_result = translated_eng{i};

    for j=1:length(correct_answer)

    end


    % len = min(length(line1), length(eng_translated{i}));
    % result = strcmp(line1(1:len), eng_translated{i}(1:len));
    % total = total + length(result);
    % total_correct = total_correct + sum(result);
    % total_word_correct = total_word_correct + sum(ismember(eng_translated{1}, line1));
end
