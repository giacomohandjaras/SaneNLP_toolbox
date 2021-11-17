function [wordlist_stem] = SNLP_stemDictionary(wordlist,language)

ITA=0;
ENG=0;
stemming=0;

lang=lower(language);
if(strcmp(lang,'ita'))
ITA=1;
ENG=0;
stemming=1;
end
if(strcmp(lang,'eng'))
ITA=0;
ENG=1;
stemming=1;
end

num_words=numel(wordlist);

wordlist_stem=cell(size(wordlist));
for i=1:num_words

if ITA==1
wordlist_stem{i}=SNLP_stemming_ita(wordlist{i});
end
if ENG==1
wordlist_stem{i}=SNLP_stemming_eng(wordlist{i});
end

end



end
