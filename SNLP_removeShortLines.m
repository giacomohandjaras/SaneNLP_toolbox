function [strings_out]=SNLP_removeShortLines(strings_in,k);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Given an array of strings, strings with a length less or equal to a specified number will be removed
%%%%
%%%%Usage:
%%%%	[strings_out]=SNLP_removeShortLines(strings_in,k);
%%%%
%%%%	strings_in: an array of strings of text
%%%%	k: only lines (array rows) with a k+1 length will be retained
%%%%
%%%%	strings_out: an array of strings with the minimum length required
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

strings_in_mask=zeros(numel(strings_in),1);
lines=numel(strings_in);

for line=1:lines
    strn=strings_in(line);
    if strlength(strn)<=k
        strings_in_mask(line)=1;
    end
end

strings_in(strings_in_mask>0)=[];
strings_out=strings_in;
end
