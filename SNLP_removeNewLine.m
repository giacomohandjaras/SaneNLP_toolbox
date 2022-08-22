function [text_out]=SNLP_removeNewLine(text_in);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Remove newline (\n and \r) from a string. Each identified newline will be replaced with a whitespace
%%%%
%%%%Usage:
%%%%	[text_out]=SNLP_removeNewLine(text_in)
%%%%
%%%%	text_in: a string of text, containing newlines (in UTF-8)
%%%%
%%%%	text_out: the original text without newlines
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

text_out = regexprep(text_in,'\n',' ');
text_out = regexprep(text_out,'\r',' ');

end
