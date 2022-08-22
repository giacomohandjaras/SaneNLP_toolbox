function [text_out]=SNLP_getUniqueWords(text_in);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Remove repeated words in a text (and also remove single char tokens), and sort them in alphabetical order
%%%%
%%%%Usage:
%%%%	[text_out]=SNLP_getUniqueWords(text_in)
%%%%
%%%%	text_in: a string of text, containing multiple instances of the same words
%%%%
%%%%	text_out: the text without repeated tokens, and with the remaining ones in alphabetical order 
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

text_out="";

strn = strsplit(text_in,' ','CollapseDelimiters',true);
strn=unique(strn);

words=numel(strn);
for word=1:words
    strn_w=strn(word);
    if strlength(strn_w)>1
        text_out=strcat(text_out,{' '},strn_w);
    end
end


end
