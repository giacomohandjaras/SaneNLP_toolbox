function text_out=SNLP_cleanTextWithStemming(text_in,stemmed_words_to_remove,language)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Remove from a string of text a set of stemmed words
%%%%
%%%%Usage:
%%%%	text_out=SNLP_cleanTextWithStemming(text_in,stemmed_words_to_remove,language)
%%%%
%%%%	text_in: a string of text (already without punctuation)
%%%%	stemmed_words_to_remove: a list of stemmed words which will be removed from text_in
%%%%	language: the language of the text_in string (e.g., 'eng')
%%%%
%%%%	text_out: a string similar to text_in, with stemmed_words_to_remove removed
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

text_out=" ";
words=strsplit(text_in,' ');
words(cellfun(@isempty,words))=[];

[words_stem] = SNLP_stemDictionary(words, language);
[words_mask] = SNLP_searchWords(words_stem, stemmed_words_to_remove);
words(find(words_mask))=[];
text_out=strjoin(words);

end
