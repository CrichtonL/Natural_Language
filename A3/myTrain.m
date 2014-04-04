%myTrain script
function myTrain(M,Q,D,save_name)
% myTrain
%
%  inputs:   M          : number of Gaussians/mixture (integer)
%            Q    		: number of hidden states
%			 D 			: number of dimensions
%

train_path = './speechdata/Training'

speaker_dir = dir(train_path);
speaker_dir(~[speaker_dir.isdir]) = [];
phone_mfcc_dict = struct();
phone_seq_dict = struct();
phone_hmm_dict = struct();

for i=1:length(speaker_dir)
	speaker_name = speaker_dir(i).name;
	speaker_path = [ train_path, '/', speaker_name];
	% exclude the current dir and parent dir
	if (length(speaker_name) == 5)

		phn_files = dir( [speaker_path, filesep, '*', 'phn'] );
		mfcc_files = dir( [speaker_path, filesep, '*', 'mfcc'] );

		%construct matrix of data{i}
		for f=1:length(mfcc_files)
			mfcc_file = [speaker_path, filesep, mfcc_files(f).name]
			phn_file = [speaker_path, filesep, phn_files(f).name]
			data = dlmread(mfcc_file);
			data = transpose(data(:,1:D));

			lines = textread(phn_file, '%s','delimiter','\n');

			T = size(data,2);

			for l=1:length(lines)
				words = strsplit(' ', lines{l});
				start_pos = str2num(words{1})
				end_pos = str2num(words{2})
				phone = words{3}

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
				mfcc_start = start_pos/128 + 1 
				mfcc_end = min(end_pos/128 + 1,T)

				phone_data = data(:,mfcc_start:mfcc_end)

				if isfield(phone_mfcc_dict, phone)
					cur_seq_num = phone_seq_dict.(phone) + 1;
					phone_mfcc_dict.(phone){cur_seq_num} = phone_data;
					phone_seq_dict.(phone) = cur_seq_num;
				else
					phone_mfcc_dict.(phone) = {};
					phone_mfcc_dict.(phone){1} = phone_data;
					phone_seq_dict.(phone) = 1;
				end

			end	
		end
	end

end

%finishing construct struct
%lets train
phones = fieldnames(phone_seq_dict);
for p=1:length(phones)

end
			

end
