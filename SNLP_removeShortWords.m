function [text_out]=SNLP_removeShortWords(text_in,k);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Remove all the words with a length less or equal to a specified number
%%%%
%%%%Usage:
%%%%	[text_out]=SNLP_removeShortWords(text_in,k)
%%%%
%%%%	text_in: a string of text, containing tokens separated by spaces
%%%%	k: only words with k+1 length will be retained
%%%%
%%%%	text_out: the original text without short words
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

text_out="";

strn = strsplit(text_in,' ','CollapseDelimiters',true);
words=numel(strn);

for word=1:words
    strn_w=strn(word);
    if strlength(strn_w)>k
        text_out=strcat(text_out,{' '},strn_w);
    end
end


end
