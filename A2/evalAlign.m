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

% Train your language models. This is task 2 which makes use of task 1
%LME = lm_train( trainDir, 'e', fn_LME );
%LMF = lm_train( trainDir, 'f', fn_LMF );
LME = load('LM_ENG.mat');
LME = LME.LM;

lines_f = textread([testDir, filesep, 'Task5.f'], '%s','delimiter','\n');
lines_e = textread([testDir, filesep, 'Task5.e'], '%s','delimiter','\n');

eng = cell(1, length(lines_e));
fre = cell(1, length(lines_f));
eng_translated = cell(1, length(lines_f));
for i=1:length(lines_f)
    fre{i} = preprocess(lines_f{i}, 'f');
    eng{i} = preprocess(lines_e{i}, 'e');
end
for i=1:1%1:length(numSentences)
    
    % Train your alignment model of French, given English 
    %AMFE = align_ibm1( trainDir, numSentences{i} , 50, 'am.mat');
    AMFE = load('AM_1000.mat');
    AMFE = AMFE.AM;
    % 
    for j=1:length(lines_f)
        % Decode the test sentence 'fre'
        eng_translated{j} = decode( fre{j}, LME, AMFE, '', 0, vocabSize );
        fprintf('line #%d \n', j);
        fprintf('%s', eng{j});
        fprintf('\n');
        fprintf('%s ', eng_translated{j}{:});
        fprintf('\n');
    end
end

% compare eng_translated and eng
total = 0;
total_correct = 0;
total_word_correct = 0;
for i=1:length(eng)
    line1 = strsplit(' ', eng{i});
    len = min(length(line1), length(eng_translated{i}));
    result = strcmp(line1(1:len), eng_translated{i}(1:len));
    total = total + length(result);
    total_correct = total_correct + sum(result);
    total_word_correct = total_word_correct + sum(ismember(eng_translated{1}, line1));
end
