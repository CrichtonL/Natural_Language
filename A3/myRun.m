%myTrain script
function myRun(D,save_name)
% myTrain
%
%  inputs:   D 			: number of dimensions
%			 save_name  : filename to save traineed struct
%
addpath(genpath('./bnt'));
test_path = './speechdata/Testing';

load(save_name);

speaker_dir = dir(test_path);

phn_files = dir( [test_path, filesep, '*', 'phn'] );
mfcc_files = dir( [test_path, filesep, '*', 'mfcc'] );

keys = fieldnames(phone_hmm_dict);
P = length(keys);
likelihood = zeros(1,P);

total_num = 0;
correct_num = 0;

%construct matrix of data{i}
for f=1:length(mfcc_files)
	mfcc_file = [test_path, filesep, mfcc_files(f).name];
	phn_file = [test_path, filesep, phn_files(f).name];
	data = dlmread(mfcc_file);
	data = transpose(data(:,1:D));

	lines = textread(phn_file, '%s','delimiter','\n');
	%size of the data
	T = size(data,2);

	for l=1:length(lines)
		total_num = total_num + 1;
		words = strsplit(' ', lines{l});
		start_pos = str2num(words{1});
		end_pos = str2num(words{2});
		phone = words{3};

		if strcmp(phone,'h#')
          phone = 'sil';
        elseif strcmp(phone,'1')
          phone = 'one';
      	elseif strcmp(phone,'2')
          phone = 'two';
      	elseif strcmp(phone,'ax-h')
          phone = 'axh';
      	end

      	%handle the inconsistancy 
		mfcc_start = start_pos/128 + 1;
		mfcc_end = min(end_pos/128 + 1,T);

		phone_data = data(:,mfcc_start:mfcc_end);

		for p=1:P
			HMM = phone_hmm_dict.(keys{p});
			LL = loglikHMM( HMM, phone_data);
			likelihood(p) = LL;
		end

		[max_ll, max_i] = max(likelihood);
		if strcmp(phone, keys{max_i})
			correct_num = correct_num + 1;
		end
	end	
end

fprintf('classifcation rate for %s is: %f\n', save_name, correct_num / total_num);

end