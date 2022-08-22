function [words_mask]=SNLP_searchWords(words, vocabulary)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Given a set of words of interest and a vocabulary, find the words included in the vocabulary
%%%%
%%%%Usage:
%%%%	[words_mask]=SNLP_searchWords(words, vocabulary)
%%%%
%%%%	words: a list of words of interest
%%%%	vocabulary: a list of words used as a reference
%%%%
%%%%	words_mask: a binary mask of the same size of words, identifying the terms present in vocabulary
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num_of_stim=numel(words);
words_mask=zeros(num_of_stim,1);

for i=1:num_of_stim
    position=find(strcmp(vocabulary,words(i)));
    if numel(position)>0
        words_mask(i)=1;
    end
end

end
