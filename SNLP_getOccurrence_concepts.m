function [external_counts,external_words,total_words, unique_words, unique_ranks, max_ranks,min_ranks,external_ranks]=SNLP_getOccurrence_concepts(dictionary_file,external_dictionary)

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

external_counts=zeros(size(external_dictionary,1),1);
external_words=cell(size(external_dictionary,1),1);
external_ranks=nan(size(external_dictionary,1),1);

rank_fixed=(tiedrank(dictionary_counts*-1));  %%%è un trucco per sortare i ranghi in maniera inversa
unique_ranks=numel(unique(rank_fixed));
max_ranks=max(rank_fixed);
min_ranks=min(rank_fixed);

for w=1:size(external_dictionary,1)
current_words=external_dictionary(w,:);
current_words = current_words(~cellfun(@isempty, current_words));
current_words = unique(current_words);


found=0;
word_freq=0;
word_ranks=[];
for j=1:numel(current_words)
word_search=current_words{j};
word_mask=strcmp(dictionary,word_search);

if(sum(word_mask)>0)
found=1;
%j
%word_search
word_freq=word_freq+sum(dictionary_counts(find(word_mask)));
temp_freq=dictionary_counts(find(word_mask));
temp_freq=temp_freq(1);
temp_ranks=find(word_mask);
if(numel(temp_ranks)>0)
word_ranks=cat(2,word_ranks,repmat(rank_fixed(temp_ranks(1)),1,temp_freq));
end
end
end

if found==1
external_words{w}=external_dictionary{w,1};
external_counts(w)=word_freq;
external_ranks(w)=mean(word_ranks);
end

end



