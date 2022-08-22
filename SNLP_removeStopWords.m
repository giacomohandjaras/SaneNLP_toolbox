function [text_out]=SNLP_removeStopWords(text_in,customStopWords);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Remove stop words from a string of text
%%%%
%%%%Usage:
%%%%	[text_out]=SNLP_removeStopWords(text_in,customStopWords)
%%%%
%%%%	text_in: a string of text, containing tokens divided by spaces
%%%%	customStopWords: a list of words to be removed from text_in
%%%%
%%%%	text_out: the original text with customStopWords removed
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

text_out="";

strn = strsplit(text_in,' ','CollapseDelimiters',true);
words=numel(strn);

for word=1:words
    strn_w=strn(word);
    if strlength(strn_w)>1
        if SNLP_isStopWord(strn_w,customStopWords)==0
            text_out=strcat(text_out,{' '},strn_w);
        end
    end
end

end
