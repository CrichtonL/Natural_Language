AM1000 = load('AM_1000_40.mat');
AM10000 = load('AM_1000_40.mat');
AM15000 = load('AM_1000_40.mat');
AM30000 = load('AM_1000_40.mat');

models = {AM1000.AM,AM10000.AM,AM15000.AM,AM30000.AM}
fn_models = {'NEW_AM_1000_40.mat', 'NEW_AM_10000_40.mat', 'NEW_AM_15000_40.mat', 'NEW_AM_30000_40.mat'};

for i=1:4
	AM = models{i};
	names = fieldnames(AM);
	for w=1:length(names)
		word = names{w};
		if ~strcmp(word,'SENTSTART') && ~strcmp(word,'SENTEND')
			AM.(word).SENTSTART = 0;
			AM.(word).SENTEND = 0;
		end
	end
	% Save the alignment model
	fn_AM = fn_models{i};
  	save( fn_AM, 'AM', '-mat'); 
end