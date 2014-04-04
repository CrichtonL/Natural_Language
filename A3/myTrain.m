%myTrain script



% addpath
% addpath('/u/cs401/A3_ASR/code/');
% addpath(genpath('/u/cs401/A3_ASR/code/FullBNT-1.0.7'));

%initialization of training parameters
train_path = './speechdata/Training'

speaker_dir = dir(train_path)
speaker_dir(~[speaker_dir.isdir]) = []


%dimension of mfcc file we wanto keep
dim_num = 10;

for i=1:length(speaker_dir)
	speaker_name = speaker_dir(i).name;
	speaker_path = [ train_path, '/', speaker_name];
	% exclude the current dir and parent dir
	if ~strcmpi(speaker_name,'.') && ~strcmpi(speaker_name,'..')

		phn_files = dir( [speaker_path, filesep, '*', 'phn'] );
		mfcc_files = dir( [speaker_path, filesep, '*', 'mfcc'] );

		%construct matrix of data{i}
		for f=1:length(mfcc_files)
			mfcc_file = [speaker_path, filesep, mfcc_files(f).name]
			M = dlmread(mfcc_file);
			M = transpose(M(:,1:dim_num));


			lines = textread([dataDir, filesep, DD(iFile).name], '%s','delimiter','\n');
		end

	end

end

























% function HMM = myTrain( M, Q, initType )

% default parameter sizes
% if nargin < 3
%     initType = 'kmeans';
% end
% if nargin < 2
%     Q = 3;
% end
% if nargin < 1
%     M = 8;
% end

% %get the trainning data
% dirinfo = dir('./speechdata/Training')
% dirinfo(~[dirinfo.isdir]) = []



% for K = 1 : length(dirinfo)
% 	% exclude the current dir and parent dir
% 	if ~strcmpi(dirinfo(K).name,'.') && ~strcmpi(dirinfo(K).name,'..')
% 		% open subdirectory one by one
% 		DD = dir( [ './speechdata/Training/', dirinfo(K).name, filesep, '*.', 'phn'] )
% 		for iFile=1:length(DD)
%   			DD(iFile).name
%   			HMM = initHMM(M, Q, initType)


%   		end
		
% 	end
  
% end



% DD = dir( [ './speechdata/Training/*', filesep, '*.', 'phn'] )
% disp([ './speechdata/Training/*', filesep, '*.', 'phn']);


% HMM = initHMM( data, M, Q, initType );

% [HMM,LL] = trainHMM( HMM, data, max_iter ) 

