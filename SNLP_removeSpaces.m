function [text_out]=SNLP_removeSpaces(text_in);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Remove all the spaces in a string
%%%%
%%%%Usage:
%%%%	[text_out]=SNLP_removeSpaces(text_in)
%%%%
%%%%	text_in: a string of text, containing spaces (even special whitespaces in UTF-8)
%%%%
%%%%	text_out: the original text without spaces
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%temp2=text_in;
%temp1='';
%while ~strcmp(temp1,temp2)
%  temp1=temp2;
%  temp2=regexprep(temp1,' ','');
%end
%text_out=temp2;

text_out=regexprep(text_in,char(160),'');
text_out=regexprep(text_out,char(8194),'');
text_out=regexprep(text_out,char(8195),'');
text_out=regexprep(text_out,char(8196),'');
text_out=regexprep(text_out,char(8197),'');
text_out=regexprep(text_out,char(8198),'');
text_out=regexprep(text_out,char(8199),'');
text_out=regexprep(text_out,char(8200),'');
text_out=regexprep(text_out,char(8201),'');
text_out=regexprep(text_out,char(8202),'');
text_out=regexprep(text_out,char(8203),'');
text_out=regexprep(text_out,char(8239),'');
text_out=regexprep(text_out,char(8287),'');
text_out=regexprep(text_out,'[ ]+','');

end
