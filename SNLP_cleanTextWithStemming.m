function cleaned=SNLP_cleanTextWithStemming(raw,stemmed_words,language)

cleaned=" ";
words=strsplit(raw,' ');
words(cellfun(@isempty,words))=[];

[words_stem] = SNLP_stemDictionary(words, language);
[words_mask] = SNLP_searchWords(words_stem, stemmed_words);
words(find(words_mask))=[];
cleaned=strjoin(words);


end
