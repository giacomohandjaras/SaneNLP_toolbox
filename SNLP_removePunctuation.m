function [text_out]=SNLP_removePunctuation(text_in);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Remove punctuation from a string. Each identified char will be replaced with a whitespace
%%%%
%%%%Usage:
%%%%	[text_out]=SNLP_removePunctuation(text_in)
%%%%
%%%%	text_in: a string of text, containing special characters in UTF-8 associated to punctuation
%%%%
%%%%	text_out: the original text without punctuation
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%version 0.1. REMOVE: [''’,.:;?!"%()=+<>*«»-‘’“”\\/''['']{}''_$£€&©®™@]
text_in = regexprep(text_in,'[''’,.:;?!"%()=+<>*«»\-‘’“”\\/''['']{}''_$£€&©®™@]',' ');
text_in = regexprep(text_in,char(8192),' '); %en quad
text_in = regexprep(text_in,char(8193),' '); %em quad
text_in = regexprep(text_in,'•',' ');
text_in = regexprep(text_in,'·',' ');
text_in = regexprep(text_in,'♦',' ');
text_in = regexprep(text_in,'∧',' ');
text_in = regexprep(text_in,'∨',' ');
text_in = regexprep(text_in,'\|',' ');
text_in = regexprep(text_in,'♥',' ');
text_in = regexprep(text_in,'#',' ');
text_in = regexprep(text_in,'—',' ');
text_in = regexprep(text_in,'§',' ');
text_in = regexprep(text_in,'~',' ');
text_in = regexprep(text_in,'¿',' ');
text_in = regexprep(text_in,'¡',' ');
text_in = regexprep(text_in,'■',' ');
text_in = regexprep(text_in,'°',' ');
text_in = regexprep(text_in,'█',' ');
text_in = regexprep(text_in,'¬',' ');
text_in = regexprep(text_in,'\^',' ');
text_in = regexprep(text_in,'÷',' ');
text_in = regexprep(text_in,'¨',' ');
text_in = regexprep(text_in,'♣',' ');
text_in = regexprep(text_in,'¢',' ');
text_in = regexprep(text_in,'…',' ');
text_in = regexprep(text_in,'’',' ');
text_in = regexprep(text_in,'‹',' ');
text_in = regexprep(text_in,'›',' ');
text_in = regexprep(text_in,'−',' ');
text_in = regexprep(text_in,'˚',' ');
text_in = regexprep(text_in,'−',' ');
text_in = regexprep(text_in,'≤',' ');
text_in = regexprep(text_in,'←',' ');
text_in = regexprep(text_in,'一',' ');


for x=8204:8303
    %char(x)
    text_in = regexprep(text_in,char(x),' '); %remove extra punctuation
end
for x=8314:8319
    %char(x)
    text_in = regexprep(text_in,char(x),' '); %remove extra punctuation
end
text_out=text_in;

end
