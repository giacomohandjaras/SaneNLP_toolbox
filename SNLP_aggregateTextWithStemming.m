function cleaned=SNLP_aggregateTextWithStemming(raw,language)

cleaned="";
words=strsplit(raw,' ');
words(cellfun(@isempty,words))=[];

[words_stem] = SNLP_stemDictionary(words, language);
[words_stem_unique,words_stem_unique_A,words_stem_unique_C] = unique(words_stem);
words_cleaned=cell(numel(words_stem_unique),1);

for w=1:numel(words_stem_unique)
mask_word=find(words_stem_unique_C==w);

word_of_interest=" ";

if numel(mask_word)>1
[C,IA,IC]=unique(words(mask_word));
[cnt, uni] = hist(IC,unique(IC));
[~,max_pos]=max(cnt);
for j=1:numel(mask_word)
word_of_interest=strcat(word_of_interest," ",string(C{IC(max_pos)}));
end
else
word_of_interest=string(words(mask_word));
end

words_cleaned{w}=word_of_interest;
end

cleaned=strjoin(string(words_cleaned));

end
