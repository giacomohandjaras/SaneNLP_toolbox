function [wordlist_out] = SNLP_stemDictionary(wordlist,language)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Stem a list of words
%%%% 	Please refers to SNLP_stemming_* for the specific algorithms
%%%%
%%%%Usage:
%%%%	[wordlist_out] = SNLP_stemDictionary(wordlist,language)
%%%%
%%%%	wordlist: a list (cell) of words
%%%%	language: the language of the wordlist. It could be 'ita', 'eng' or 'fra'.
%%%%
%%%%	wordlist_out: the stemmed form of the list
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


ITA=0;
ENG=0;
FRA=0;
stemming=0;

lang=lower(language);
if(strcmp(lang,'ita'))
    ITA=1;
    ENG=0;
    FRA=0;
    stemming=1;
end

if(strcmp(lang,'eng'))
    ITA=0;
    ENG=1;
    FRA=0;
    stemming=1;
end

if(strcmp(lang,'fra'))
    ITA=0;
    ENG=0;
    FRA=1;
    stemming=1;
end

num_words=numel(wordlist);

wordlist_out=cell(size(wordlist));
for i=1:num_words
    
    if ITA==1
        wordlist_out{i}=SNLP_stemming_ita(wordlist{i});
    end
    
    if ENG==1
        wordlist_out{i}=SNLP_stemming_eng(wordlist{i});
    end
    
    if FRA==1
        wordlist_out{i}=SNLP_stemming_fra(wordlist{i});
    end
    
end

end
