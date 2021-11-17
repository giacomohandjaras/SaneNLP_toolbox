function [words_mask]=SNLP_searchWords(words, vocabulary)

num_of_stim=numel(words);
words_mask=zeros(num_of_stim,1);

for i=1:num_of_stim
position=find(strcmp(vocabulary,words(i)));
if numel(position)>0
words_mask(i)=1;
end
end

end
