function text_out=SNLP_cleanTextUsingDictionary(text_in,words_to_remove)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Remove from a string of text a set of words
%%%%
%%%%Usage:
%%%%	text_out=SNLP_cleanTextUsingDictionary(text_in,words_to_remove)
%%%%
%%%%	text_in: a string of text (already without punctuation)
%%%%	words_to_remove: a list of words which will be removed from text_in
%%%%
%%%%	text_out: a string similar to text_in, with words_to_remove removed
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

text_out=" ";
words=strsplit(text_in,' ');
words(cellfun(@isempty,words))=[];

[words_mask] = SNLP_searchWords(words, words_to_remove);
words(find(words_mask==0))=[];
text_out=strjoin(words);

end
