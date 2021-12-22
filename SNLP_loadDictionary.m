function [dictionary,dictionary_counts]=SNLP_loadDictionary(dictionary_file);

dictionary=SNLP_loadWords(dictionary_file);
%%%%%%%%%assumo che la prima sia </s>
dictionary(1)=[];
dictionary=split(dictionary,' ');

dictionary_counts=cellfun(@str2num, dictionary(1:end,2));
dictionary=dictionary(:,1); %%%isoliamo solo le parole
	
end
