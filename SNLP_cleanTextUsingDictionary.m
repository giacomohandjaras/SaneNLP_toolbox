function cleaned=SNLP_cleanTextUsingDictionary(raw,dictionary)

cleaned=" ";
words=strsplit(raw,' ');
words(cellfun(@isempty,words))=[];

[words_mask] = SNLP_searchWords(words, dictionary);
words(find(words_mask==0))=[];
cleaned=strjoin(words);


end
