function [text_out]=SNLP_removeExtraGarbage(text_in);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Remove special chars (ASCII code <= 31). It is a very dangerous function, since it could alter UTF-8 encoding 
%%%%
%%%%Usage:
%%%%	[text_out]=SNLP_removeExtraGarbage(text_in)
%%%%
%%%%	text_in: a string of text
%%%%
%%%%	text_out: the cleaned text
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%remove ASCII code <= 31
temp=str2mat(text_in);
temp_mask=double(temp);
temp(temp_mask<=31)=[];

text_out=temp;
end
