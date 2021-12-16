function [external_counts,external_words,total_words, unique_words, unique_ranks, max_ranks,min_ranks,external_ranks]=SNLP_getOccurrence(dictionary_file,external_dictionary)

external_counts=[];
external_words=[];
total_words=[];
unique_words=[];
unique_ranks=[];
max_ranks=[];
min_ranks=[];
external_ranks=[];

dictionary=SNLP_loadWords(dictionary_file);
%%%%%%%%%assumo che la prima sia </s>
dictionary(1)=[];
dictionary=split(dictionary,' ');

dictionary_counts=cellfun(@str2num, dictionary(1:end,2));
dictionary=dictionary(:,1); %%%isoliamo solo le parole

unique_words=numel(dictionary);
total_words=sum(dictionary_counts);

external_counts=zeros(numel(external_dictionary),1);
external_words=cell(numel(external_dictionary),1);
external_ranks=nan(numel(external_dictionary),1);

rank_fixed=(tiedrank(dictionary_counts*-1));  %%%è un trucco per sortare i ranghi in maniera inversa
unique_ranks=numel(unique(rank_fixed));
max_ranks=max(rank_fixed);
min_ranks=min(rank_fixed);

for w=1:numel(external_dictionary)
pos=regexp(external_dictionary{w},"\*");
if pos>0 %%%abbiamo trovato una parola stemmata
%disp(sprintf('Trovato una parola da stemmare %s',external_dictionary(w)));
[word]=strsplit(external_dictionary{w},'*');
word_search=strcat('^',word(1,1),' *');
word_mask=regexp(dictionary,word_search);
word_mask_notempty = ~cellfun(@isempty, word_mask);
word_found=dictionary(find(word_mask_notempty));
external_words{w}=word_found;
word_freq=dictionary_counts(find(word_mask_notempty));
external_counts(w)=sum(word_freq);
temp_ranks=find(word_mask_notempty);
if(numel(temp_ranks)>0)
external_ranks(w)=(rank_fixed(temp_ranks(1)));
end
else
word_search=external_dictionary{w};
word_mask=strcmp(dictionary,word_search);
word_found=dictionary(find(word_mask));
external_words{w}=word_found;
word_freq=dictionary_counts(find(word_mask));
external_counts(w)=sum(word_freq);
temp_ranks=find(word_mask);
if(numel(temp_ranks)>0)
external_ranks(w)=(rank_fixed(temp_ranks(1)));
end
end
end

end



