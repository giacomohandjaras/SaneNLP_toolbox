function [text_out]=SNLP_removeNumbers(text_in);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Remove numbers from a string. Each identified number will be replaced with a whitespace
%%%%
%%%%Usage:
%%%%	[text_out]=SNLP_removeNumbers(text_in)
%%%%
%%%%	text_in: a string of text, containing numbers (in UTF-8)
%%%%
%%%%	text_out: the original text without numbers
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%It does not handle roman numbers!
text_in = regexprep(text_in, '[0-9]+', '');
text_in = regexprep(text_in,char(185),' '); %superscript 1
text_in = regexprep(text_in,char(178),' '); %superscript 2
text_in = regexprep(text_in,char(179),' '); %superscript 3
text_in = regexprep(text_in,char(8304),' '); %superscript 0

text_in = regexprep(text_in,'',' '); %subscript
text_in = regexprep(text_in,'',' '); %subscript
text_in = regexprep(text_in,'',' '); %subscript
text_in = regexprep(text_in,'',' '); %subscript
text_in = regexprep(text_in,'',' '); %subscript
text_in = regexprep(text_in,'',' '); %subscript
text_in = regexprep(text_in,'',' '); %subscript
text_in = regexprep(text_in,'',' '); %subscript
text_in = regexprep(text_in,'',' '); %subscript
text_in = regexprep(text_in,'',' '); %subscript


for x=8308:8313
    %char(x)
    text_in = regexprep(text_in,char(x),' '); %remove extra superscript number
end
for x=8320:8329
    %char(x)
    text_in = regexprep(text_in,char(x),' '); %remove extra subscript number
end
text_out=text_in;
end
